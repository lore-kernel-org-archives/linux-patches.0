Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B322517AA;
	Tue, 29 Apr 2025 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945844; cv=none; b=rGb+QqxkZ8I2JpGo//ZyhWUG+qYJOlQ+mFGxKE1ABVF9R4jzEgOpkMRron89B43Tqfvri0KtNX+8AlvoRGlLk6xByNWlecP++yx3IrPfLNmOR67h8vdgxoPOwJkqG4w/0hnRkXqv5n5HvcjMw1S7iTAy4vRsnICTlxnOllkPssM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945844; c=relaxed/simple;
	bh=wlH0bKnipYkWTEyXQRFnhV0GOeo4lE1WS6lvrRqrFFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd8+Gmf3oaV/QwJPwFHjk5HnmOKbLUSdYgbgZSheps7e2VOBY0HAET/MBJbOjzEzU+QZd4QzUn9c0aVO+y76eiVFfTqVxtZNzuDkM2pJA7+IJ3gkwwrt7k75ZQ772DoAImsk9Fyqpi0uKMuyQorx5GaOch+u/2BTkqNBuD/+NvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n83p1J3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n83p1J3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2742C4CEE3;
	Tue, 29 Apr 2025 16:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945844;
	bh=wlH0bKnipYkWTEyXQRFnhV0GOeo4lE1WS6lvrRqrFFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n83p1J3Ine/y260NkY6v4dwxsA97R7z6YGUFUQXtCL/G8xr8nJdTCISjGCEMrYftW
	 vQJl3IHKn9hpCXAsNo5vvp7aw7QQQulIfKvhYEJuV0O9c/CxEbWfmtFhVP/8oZX9x7
	 9pqrAGBLHpODDslNLALJMJ/q1Uy9kQIjBtGC8OD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 069/311] net_sched: hfsc: Fix a potential UAF in hfsc_dequeue() too
Date: Tue, 29 Apr 2025 18:38:26 +0200
Message-ID: <20250429161123.872048751@linuxfoundation.org>
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
index e730d3f791c24..5bb4ab9941d6e 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1637,10 +1637,16 @@ hfsc_dequeue(struct Qdisc *sch)
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



