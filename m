Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871F25335E;
	Tue, 29 Apr 2025 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947292; cv=none; b=lDOWcK+RAyqWubPP5b5trbxePzvO4CyvWjibV2w9bFbcmZxNSS9PBGoDjdsyYsRdoNY22kzFdSJrUU4vXTNDqcBXGSV0cKMw0yoB6ZXYhGBTSj/LvlgaTy8UJiJwek/Zwr1UsiiolWvIEXa4wrXY7mfzinfipFoLxkGulBKwxn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947292; c=relaxed/simple;
	bh=SLePKTdMOxgqo6P+S/6O++o+lvXenMcUzWJKYGIu8C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IK+2Tzrjsj8jM87V+Q8TUn65Ffc8qt2UaF9yhlX6XalLkuY6t4xBC931cuGPJKN0SK8+hK93LWGP7Lcbj2FktVTQSYyz+c6SBITdz45Y/z6NZBhKdyJ56QmwWzanNwJYSsEzlZQYo0EHGl3W7vcSag2tAR/xFa7Fe1GUnXda3VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRfqlrRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRfqlrRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA9AC4CEE3;
	Tue, 29 Apr 2025 17:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947292;
	bh=SLePKTdMOxgqo6P+S/6O++o+lvXenMcUzWJKYGIu8C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xRfqlrRAd6u7RBqMJGTxCLe7LPqtYX5V0KwtAk8r2ZnrUJHX5PFdEFeKUm1ob0db8
	 wgwnACAfPjhhyyz5q1/KhCi7sUb8TdmRzqfJ4IpKI+g4r6eIuXpWAn/16RUAABEIdf
	 tFKduG436Nu8Wwk1ATE4rHymPizntj7GuSsrdTsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/286] net_sched: hfsc: Fix a potential UAF in hfsc_dequeue() too
Date: Tue, 29 Apr 2025 18:42:19 +0200
Message-ID: <20250429161117.596931634@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 6ccbda44e2cc3d26fd22af54c650d6d5d801addf ]

Similarly to the previous patch, we need to safe guard hfsc_dequeue()
too. But for this one, we don't have a reliable reproducer.

Fixes: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2")
Reported-by: Gerrard Tai <gerrard.tai@starlabs.sg>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20250417184732.943057-3-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index ed8211c8d1f4c..aad090fd165b0 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1643,10 +1643,16 @@ hfsc_dequeue(struct Qdisc *sch)
 		if (cl->qdisc->q.qlen != 0) {
 			/* update ed */
 			next_len = qdisc_peek_len(cl->qdisc);
-			if (realtime)
-				update_ed(cl, next_len);
-			else
-				update_d(cl, next_len);
+			/* Check queue length again since some qdisc implementations
+			 * (e.g., netem/codel) might empty the queue during the peek
+			 * operation.
+			 */
+			if (cl->qdisc->q.qlen != 0) {
+				if (realtime)
+					update_ed(cl, next_len);
+				else
+					update_d(cl, next_len);
+			}
 		} else {
 			/* the class becomes passive */
 			eltree_remove(cl);
-- 
2.39.5



