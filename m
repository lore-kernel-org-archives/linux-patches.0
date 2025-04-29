Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD5E2517AA;
	Tue, 29 Apr 2025 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945841; cv=none; b=rVwqy4NCFr1UIzqAnf4bOyc3POHDhWZv8sAhrTr91umh/W7LVhs9h28Gz3PtnlFHZRhdt5A0Lf6djTRwG0KATiaG2HaxNQPw0Yy7nK30Q289vpGPxxKP7vOPjxLKxR99E7BZQutPf7oFfrywlvsg1DgwtZpC1S04kPl0pcrinpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945841; c=relaxed/simple;
	bh=yoziJssfKdHO0auMZQCNQzGvQw5zQUHecImU2DmbreA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVk0R49RPv895TRJyQrpKPcIFKg3A4ICw0emb7y6wN6SkQ+URkP+AySnbjgRYFNBjPcuMS4weCzOJE34CBnUMBTGMoFcF2qkuK/XKg8E7onylBSdeYnDX7FaMqWtXUfbKcFwrB2aMkBBxbs8Wr1Ykrs3pVqh5tsH08aRP5ro0Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cm31bfvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cm31bfvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C0AC4CEE3;
	Tue, 29 Apr 2025 16:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945841;
	bh=yoziJssfKdHO0auMZQCNQzGvQw5zQUHecImU2DmbreA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cm31bfvmz6bzMLvImawdXAYt02gzIdnt6SnGirbMltLMAYxi6w2yLxqs1VmeMzQHL
	 XOoFxhHwSZCV8BqPiYSF3+hpGfCycl4xutRdiVO5f9O90HTWfIvGu4LitJHWxzGVmf
	 v0xT5dR1Id59qL3edJZIz82pklRl+v/F/jWmuQuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 068/311] net_sched: hfsc: Fix a UAF vulnerability in class handling
Date: Tue, 29 Apr 2025 18:38:25 +0200
Message-ID: <20250429161123.831292610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 3df275ef0a6ae181e8428a6589ef5d5231e58b5c ]

This patch fixes a Use-After-Free vulnerability in the HFSC qdisc class
handling. The issue occurs due to a time-of-check/time-of-use condition
in hfsc_change_class() when working with certain child qdiscs like netem
or codel.

The vulnerability works as follows:
1. hfsc_change_class() checks if a class has packets (q.qlen != 0)
2. It then calls qdisc_peek_len(), which for certain qdiscs (e.g.,
   codel, netem) might drop packets and empty the queue
3. The code continues assuming the queue is still non-empty, adding
   the class to vttree
4. This breaks HFSC scheduler assumptions that only non-empty classes
   are in vttree
5. Later, when the class is destroyed, this can lead to a Use-After-Free

The fix adds a second queue length check after qdisc_peek_len() to verify
the queue wasn't emptied.

Fixes: 21f4d5cc25ec ("net_sched/hfsc: fix curve activation in hfsc_change_class()")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Reviewed-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20250417184732.943057-2-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index c287bf8423b47..e730d3f791c24 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -958,6 +958,7 @@ hfsc_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 	if (cl != NULL) {
 		int old_flags;
+		int len = 0;
 
 		if (parentid) {
 			if (cl->cl_parent &&
@@ -988,9 +989,13 @@ hfsc_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 		if (usc != NULL)
 			hfsc_change_usc(cl, usc, cur_time);
 
+		if (cl->qdisc->q.qlen != 0)
+			len = qdisc_peek_len(cl->qdisc);
+		/* Check queue length again since some qdisc implementations
+		 * (e.g., netem/codel) might empty the queue during the peek
+		 * operation.
+		 */
 		if (cl->qdisc->q.qlen != 0) {
-			int len = qdisc_peek_len(cl->qdisc);
-
 			if (cl->cl_flags & HFSC_RSC) {
 				if (old_flags & HFSC_RSC)
 					update_ed(cl, len);
-- 
2.39.5



