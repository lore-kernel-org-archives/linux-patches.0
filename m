Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A5A23A562;
	Sat, 12 Sep 2026 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232335; cv=none; b=pg0Xc0rtDYqEoCzd5Bly2FbxDpZ7T2o1fPS+Q0iVPWPOVinSdyol5wfHrNCMvNVXMytdWIxxAAAbmfvgG+Nr+Sf/eStZh8UvJLG+bFmmVRjN9yGhkGPbns36v3CGkOS7v0aOUOgfejszD8Z2fFvoivcdEMa30v7V/mo54P6Wm1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232335; c=relaxed/simple;
	bh=EC5kGbadYfQRGzQdOv/G/Gxfeq/MTj2k7wgfXq0EUZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdsaDMLF1h/91/ivNazwMXH4Z9t7ptwBG4ipqnTo8APi+XXfQnvINjTWpG+7ndyBoYSXnTjit2/h/iwbUFDZXtzzMSRPTvtdmKfeWoCbVJUW79fSATM2J9meYBcwfK8tWoUpGTb2o0Wju9/ViS3scLnCKEawd8X5kjHnqOKiA8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1x7vxXU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1x7vxXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896891F000FF;
	Sat, 12 Sep 2026 16:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232333;
	bh=2WCmodECrz2kRfeNUb0osd9hTNtBCj7VjOXUFRI/Mfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1x7vxXUSFyptA0+ufqvTXXP5qqllDhdNtYXeuE4cJzBN682P3HmCMvbEHQE67Sz0
	 WCEf/zOtX9PdBPagelQb4prw9X96VUmgt7bUv0YCLmRiVP3yljHgSc5W2D4Jfx1nhn
	 +ZwhhnI15bragkmCObl9evXWELGAYpeQ3FR/B7eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Nick Chan <towinchenmi@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1180/1191] nvme-apple: Prevent shared tags across queues on Apple A11
Date: Sat, 12 Sep 2026 09:05:08 +0200
Message-ID: <20260912065614.642903192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Nick Chan <towinchenmi@gmail.com>

[ Upstream commit 6fe0687245e8406bf26143bd45eb16441bbe5280 ]

On Apple A11, tags of pending commands must be unique across the admin
and IO queues, else the firmware crashes with
"duplicate tag error for tag N", with N being the tag.

Apply the existing workaround for M1 of reserving two tags for the admin
queue to A11.

Cc: stable@vger.kernel.org
Fixes: 04d8ecf37b5e ("nvme: apple: Add Apple A11 support")
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 6fb881f3807c5..060f80c5ebeda 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -239,7 +239,7 @@ static unsigned int apple_nvme_queue_depth(struct apple_nvme_queue *q)
 {
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
-	if (q->is_adminq && anv->hw->has_lsq_nvmmu)
+	if (q->is_adminq)
 		return APPLE_NVME_AQ_DEPTH;
 
 	return anv->hw->max_queue_depth;
@@ -317,7 +317,7 @@ static void apple_nvme_submit_cmd_t8015(struct apple_nvme_queue *q,
 		memcpy((void *)q->sqes + (q->sq_tail << APPLE_NVME_IOSQES),
 			cmd, sizeof(*cmd));
 
-	if (++q->sq_tail == anv->hw->max_queue_depth)
+	if (++q->sq_tail == apple_nvme_queue_depth(q))
 		q->sq_tail = 0;
 
 	writel(q->sq_tail, q->sq_db);
@@ -1114,10 +1114,7 @@ static void apple_nvme_reset_work(struct work_struct *work)
 	}
 
 	/* Setup the admin queue */
-	if (anv->hw->has_lsq_nvmmu)
-		aqa = APPLE_NVME_AQ_DEPTH - 1;
-	else
-		aqa = anv->hw->max_queue_depth - 1;
+	aqa = APPLE_NVME_AQ_DEPTH - 1;
 	aqa |= aqa << 16;
 	writel(aqa, anv->mmio_nvme + NVME_REG_AQA);
 	writeq(anv->adminq.sq_dma_addr, anv->mmio_nvme + NVME_REG_ASQ);
@@ -1300,8 +1297,7 @@ static int apple_nvme_alloc_tagsets(struct apple_nvme *anv)
 	 * both queues. The admin queue gets the first APPLE_NVME_AQ_DEPTH which
 	 * must be marked as reserved in the IO queue.
 	 */
-	if (anv->hw->has_lsq_nvmmu)
-		anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
+	anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
 	anv->tagset.queue_depth = anv->hw->max_queue_depth - 1;
 	anv->tagset.timeout = NVME_IO_TIMEOUT;
 	anv->tagset.numa_node = NUMA_NO_NODE;
-- 
2.53.0



