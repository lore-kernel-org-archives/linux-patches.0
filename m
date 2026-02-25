Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA2420C012;
	Wed, 25 Feb 2026 01:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983907; cv=none; b=RE8EIke523RV1pXrym4yN8ZRBZIevrAxBpFW9a9O1mk/c6uQs/iSNeJVCBS2bzkMdoJZetFdapRZm8+TySIsZlpUVMWr3ekdN9e6I1cuAxGFi3VeAs63uMHbRpHIJP+SKrFvBVzJdLlEfxd5aJFiIGzc9FsIzwE1ZtILvjghUbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983907; c=relaxed/simple;
	bh=WLMMpkcjKz6fcYFfCBafRzHT1HPa44bgmgMp0GMfnOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JayFL6yXmgz1gJLG8NCTIQDMaqJZjC0Vw4iAir0RtLqU7egJs9qDpXeMPTAVnrs+syC5ySz19tfoPYO4OMAqu93zixOibCRJ8DPin4Ug+hIVZY/HIvCGeDx7FV2Tc3EkepjXyiFXLKnZlvIR5wvKLLVw3b1XdTgEXnlmUHP260M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0ofhgMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0ofhgMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E623CC116D0;
	Wed, 25 Feb 2026 01:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983907;
	bh=WLMMpkcjKz6fcYFfCBafRzHT1HPa44bgmgMp0GMfnOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0ofhgMdCyoTyX7bSGmFfNQ4hmE2CWCPRHE5PRBME0CG6/LwLAF6/t1uZZpp9vR1h
	 ZF2+9Uj65pmt8Yqhz4E2CkmhcJ8jdiiNfIeGiDrVvky0YE8ebrSZ5BMhNngWrWOjuZ
	 l9RfTR3sWaM+khATi4KeZlHfkjWj8rXgwmxQPr1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/641] workqueue: Factor out assign_rescuer_work()
Date: Tue, 24 Feb 2026 17:18:20 -0800
Message-ID: <20260225012353.253976892@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

[ Upstream commit 99ed6f62a46e91dc796b785618d646eeded1b230 ]

Move the code to assign work to rescuer and assign_rescuer_work().

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: e5a30c303b07 ("workqueue: Process rescuer work items one-by-one using a cursor")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 45320e27a16c4..2fa3187101725 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3443,6 +3443,23 @@ static int worker_thread(void *__worker)
 	goto woke_up;
 }
 
+static bool assign_rescuer_work(struct pool_workqueue *pwq, struct worker *rescuer)
+{
+	struct worker_pool *pool = pwq->pool;
+	struct work_struct *work, *n;
+
+	/*
+	 * Slurp in all works issued via this workqueue and
+	 * process'em.
+	 */
+	list_for_each_entry_safe(work, n, &pool->worklist, entry) {
+		if (get_work_pwq(work) == pwq && assign_work(work, rescuer, &n))
+			pwq->stats[PWQ_STAT_RESCUED]++;
+	}
+
+	return !list_empty(&rescuer->scheduled);
+}
+
 /**
  * rescuer_thread - the rescuer thread function
  * @__rescuer: self
@@ -3497,7 +3514,6 @@ static int rescuer_thread(void *__rescuer)
 		struct pool_workqueue *pwq = list_first_entry(&wq->maydays,
 					struct pool_workqueue, mayday_node);
 		struct worker_pool *pool = pwq->pool;
-		struct work_struct *work, *n;
 
 		__set_current_state(TASK_RUNNING);
 		list_del_init(&pwq->mayday_node);
@@ -3508,18 +3524,9 @@ static int rescuer_thread(void *__rescuer)
 
 		raw_spin_lock_irq(&pool->lock);
 
-		/*
-		 * Slurp in all works issued via this workqueue and
-		 * process'em.
-		 */
 		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
-		list_for_each_entry_safe(work, n, &pool->worklist, entry) {
-			if (get_work_pwq(work) == pwq &&
-			    assign_work(work, rescuer, &n))
-				pwq->stats[PWQ_STAT_RESCUED]++;
-		}
 
-		if (!list_empty(&rescuer->scheduled)) {
+		if (assign_rescuer_work(pwq, rescuer)) {
 			process_scheduled_works(rescuer);
 
 			/*
-- 
2.51.0



