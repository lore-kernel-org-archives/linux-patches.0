Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EE62512F3;
	Tue, 29 Apr 2025 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949351; cv=none; b=HqsG+glEnoaUKsOCAkk9NGIcJz3UGmwcAYMfmNR8Glx9urKpyEOFwtEJkq6MQiCmFRACUKqlufxtZqbT5pV9CvAYI5DjaPwLbv/Nl2u6uwBLfylTqV79Y1ix1w1Oli11kW0jfXZ0cl4jbuGpHJfGgqpkT+MNfldaeLEmvk8mv5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949351; c=relaxed/simple;
	bh=TBFMpmQqYqDlM+JE6WY9Hu/JB4fEYgQDX5mwEAUyP0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euLvDuiBQ7p4Vz4fHWxnPVWYVecb1HCCq//5CrDP1zVQI+HwXviWD5VKtdZO7i4j6bzCyBZ/ED1KjI/QKMPk6YlzCEguHUZC/l6KKKiHQUYW1bGNhTYbBU/FPVD/8K+vXhiCuZ6gBCxHdUXSOYY6rnDXMweQPrpSakF6yzy/FPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnOckQ0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnOckQ0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6DEC4CEE3;
	Tue, 29 Apr 2025 17:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949350;
	bh=TBFMpmQqYqDlM+JE6WY9Hu/JB4fEYgQDX5mwEAUyP0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnOckQ0NU2xw2ir+19CK6IuhyFpIcRFzvRwqrjxOGGuKfHovXMXiNaVc8dKtqxXD9
	 XMLLiQ/xP8K2t4JOSz8XwLDQiyXAV1WN8gAC0DNMFzw4gkRNV4A/Th3GmW+ljncsIh
	 HKLDvNO/lGszluzUAS7QgbFghtPczmQlCLJF9GOM=
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
Subject: [PATCH 5.15 292/373] net_sched: hfsc: Fix a UAF vulnerability in class handling
Date: Tue, 29 Apr 2025 18:42:49 +0200
Message-ID: <20250429161135.124345817@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1f0db6c85b09c..ea42708aac7e2 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -959,6 +959,7 @@ hfsc_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 
 	if (cl != NULL) {
 		int old_flags;
+		int len = 0;
 
 		if (parentid) {
 			if (cl->cl_parent &&
@@ -989,9 +990,13 @@ hfsc_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
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



