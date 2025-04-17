Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9A02522AC;
	Thu, 17 Apr 2025 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914541; cv=none; b=Jj6FSd3gvTYmTRFRoB7Q4LkF7W9C5QKHI7urEzIukQBlJ7OH3L2fTiZf2Wa+2CmGNrplCGmNy3vVayLfLJ6iXFL64h57mLgEfxjd4yLhKCQTl9bXab5rkdeSVIXC8LRd7Ao4nMKXpdry7jS0KnBhucYvWTtuEfxuoUIxIuGHXFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914541; c=relaxed/simple;
	bh=oIE+TXZLokVQAnnhNeHk/juBtQQhV+AutG3oogbINWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRKx1nOdG9vcETxZiX/Dmu8fmD8h2MHU5yzQUzm4jucGz132eBtbHD6pU0zCHCUtHenWgjod5PftCjXdzfEtPJJBm6eRDK22GTz1wZF6nIYLxPacEc1mN0JG9B+FzbHtcq2BMObc1CwJ/C3DcuUncEk2Js0AKn2r/9f01+CbkMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asfQ4PZZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asfQ4PZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD797C4CEE4;
	Thu, 17 Apr 2025 18:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914541;
	bh=oIE+TXZLokVQAnnhNeHk/juBtQQhV+AutG3oogbINWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asfQ4PZZblCw37WtpX7Eo4ZD4kRSnZKL94gybYpDS9YLWPf+k/umwuXrowRgMPVtw
	 59zf3Z56D50c1Fg/VSq72Z10ekGm1TT+th03y2JOQ1k3BaDOt4fGpUx2rlEe7T2BHx
	 Xl7N3dVeQUZ+v+FgWSz5HpL1ZZT1A12nfV8xwV/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jackson.lee" <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 242/414] media: chips-media: wave5: Avoid race condition in the interrupt handler
Date: Thu, 17 Apr 2025 19:50:00 +0200
Message-ID: <20250417175121.159904952@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson.lee <jackson.lee@chipsnmedia.com>

commit ac35f768986610480a1c01323d9cf9f5eaf3ee9b upstream.

In case of multiple active instances, new interrupts can occur as soon
as the current interrupt is cleared. If the driver reads the
instance_info after clearing the interrupt, then there is no guarantee,
that the instance_info is still valid for the current interrupt.

Read the instance_info register for each interrupt before clearing the
interrupt.

Fixes: ed7276ed2fd0 ("media: chips-media: wave5: Add hrtimer based polling support")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson.lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu.c
@@ -55,12 +55,12 @@ static void wave5_vpu_handle_irq(void *d
 	struct vpu_device *dev = dev_id;
 
 	irq_reason = wave5_vdi_read_register(dev, W5_VPU_VINT_REASON);
+	seq_done = wave5_vdi_read_register(dev, W5_RET_SEQ_DONE_INSTANCE_INFO);
+	cmd_done = wave5_vdi_read_register(dev, W5_RET_QUEUE_CMD_DONE_INST);
 	wave5_vdi_write_register(dev, W5_VPU_VINT_REASON_CLR, irq_reason);
 	wave5_vdi_write_register(dev, W5_VPU_VINT_CLEAR, 0x1);
 
 	list_for_each_entry(inst, &dev->instances, list) {
-		seq_done = wave5_vdi_read_register(dev, W5_RET_SEQ_DONE_INSTANCE_INFO);
-		cmd_done = wave5_vdi_read_register(dev, W5_RET_QUEUE_CMD_DONE_INST);
 
 		if (irq_reason & BIT(INT_WAVE5_INIT_SEQ) ||
 		    irq_reason & BIT(INT_WAVE5_ENC_SET_PARAM)) {


