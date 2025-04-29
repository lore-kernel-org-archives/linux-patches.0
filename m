Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC0319F424;
	Tue, 29 Apr 2025 18:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950327; cv=none; b=lcbgYxZaKJQ60E8dBLHkKp2bxYsSmOcfgqYQ0f7mam0IR+jPK/g9hpqNY7/svrJ64fWQPwHjhzYg3r0vw0iZnD7ViTN3InN3+kQYyrSxgsjXkGtAnaL8vxsNu5J4z/mobbqmu28ac8obyAt9ldHERMYelCnR8aoHFziLbbSjLcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950327; c=relaxed/simple;
	bh=MqX9JngJvbZ8Lgq+fuIG9k43SZl1IzIRP9DdsispUa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsMJGfw9zpT01ZLPCssCa8OUuOOCuX6PJNb7wr/uoOjgJTLvcVIgc8SqmJAKM0ZVFZ0Xm/wdvPEHyGyomZqkfk8tyrwNn7np6uXeLdBmj+XkvLlG8UpQhwhXbi9Z4t6X7oJ3Hoy9M1VRA/UzENR8PU31yoGxxjRPx5N3aja3Sqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8/z5W63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8/z5W63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9147FC4CEE3;
	Tue, 29 Apr 2025 18:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950327;
	bh=MqX9JngJvbZ8Lgq+fuIG9k43SZl1IzIRP9DdsispUa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8/z5W630VuoahbnJBqlBPZTlyiz/h+ZzrfsXgdos3IGmaqvdcl9NOrJjCqS7Mh2n
	 cezYcrjLyMSj4IYA6YUsCBUMxPg/eht5TAQQG1w1ymtQ9FA1Jzqah3zQ2gA7tCeD7j
	 yYRTB/2Wb2Fkofu1Hw06ZdtOWt1R+fT15cyeSHu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerrard Tai <gerrard.tai@starlabs.sg>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/204] net_sched: hfsc: Fix a potential UAF in hfsc_dequeue() too
Date: Tue, 29 Apr 2025 18:42:28 +0200
Message-ID: <20250429161101.888589464@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 90801b6fe2b08..371255e624332 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1638,10 +1638,16 @@ hfsc_dequeue(struct Qdisc *sch)
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



