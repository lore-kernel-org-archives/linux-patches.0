Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB3E3242BE;
	Sat, 30 May 2026 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159833; cv=none; b=mfp7yANOpLlJmI8FYXJKg0kuu9MHPSfxEteR2ahdVwgeT2M/jzYDNqJDEbecNC3usjaLbtElbTyLSd4ahluBqLeB68LFocoPOQD/mYOvrmDx172RQQoUx458xYt5GJT9PKGF+8ClvV4LOCBLZ6NZnUycxMuglGHUdhpCR4wV0Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159833; c=relaxed/simple;
	bh=UeWMFmTGifq0Y8GzD8Z3ebODll8dxXPdHIZ9ZG+ERq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=taKHc53G9IkxzxFdS0ORpq5Ep9T7qwHE2+PLaFH7VHBnLNm6zJiWY5BXqhhrnw59miEmDFHDlAs3UUX4t/MxM7mfqtCzp5b+afblYcRLppf+2N5Qp0hZQ8OtBQ2NsL1TPHaF5EMnUf4GnWmbjmV+m4ofCegGP9avccuEc0syRl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r83Xzhax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r83Xzhax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D993F1F00893;
	Sat, 30 May 2026 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159832;
	bh=Bgx/JOf9IEhWickSd91u1QjfVDxOmh3kB/eWxU2T/Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r83Xzhax//9OW9IVkiq6FCGryx1eWStQH9k8Q2BTqANM1WykihGY+vi06NB/GxdlO
	 JiRZpLSnU5VRm0tn1QS5Y4bz4LU22npyLSEeKoFaXmy3RtZ4vZF7BpjWJ1RX8K2Sq1
	 zUmBOdOIZMTNTtRbvr849JrxwLzi8Irf33j2ry+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Chen <leonchen.oss@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/969] blk-mq: fix NULL dereference on q->elevator in blk_mq_elv_switch_none
Date: Sat, 30 May 2026 17:54:58 +0200
Message-ID: <20260530160305.306206198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 245165658e1c9f95c0fecfe02b9b1ebd30a1198a ]

After grabbing q->sysfs_lock, q->elevator may become NULL because of
elevator switch.

Fix the NULL dereference on q->elevator by checking it with lock.

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230616132354.415109-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Leon Chen <leonchen.oss@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f480b6ddba5ee..8a9d9e3db1668 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4732,9 +4732,6 @@ static bool blk_mq_elv_switch_none(struct list_head *head,
 {
 	struct blk_mq_qe_pair *qe;
 
-	if (!q->elevator)
-		return true;
-
 	qe = kmalloc(sizeof(*qe), GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY);
 	if (!qe)
 		return false;
@@ -4742,6 +4739,12 @@ static bool blk_mq_elv_switch_none(struct list_head *head,
 	/* q->elevator needs protection from ->sysfs_lock */
 	mutex_lock(&q->sysfs_lock);
 
+	/* the check has to be done with holding sysfs_lock */
+	if (!q->elevator) {
+		kfree(qe);
+		goto unlock;
+	}
+
 	INIT_LIST_HEAD(&qe->node);
 	qe->q = q;
 	qe->type = q->elevator->type;
@@ -4756,6 +4759,7 @@ static bool blk_mq_elv_switch_none(struct list_head *head,
 	 */
 	__module_get(qe->type->elevator_owner);
 	elevator_switch(q, NULL);
+unlock:
 	mutex_unlock(&q->sysfs_lock);
 
 	return true;
-- 
2.53.0



