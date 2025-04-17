Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9399518C034;
	Thu, 17 Apr 2025 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913304; cv=none; b=gMmH8hdxgmRn2slAYVYWdACYoe+9WXJK4/2lV1a1qxm1i7e9HUC4A9/dlpFXRbC6T2guJGh0r/401C+uAyMX/DHmfta0H4hzGiiEpbHvNYSBseLQrAdHqayuJEesJq6TCnaXNjd2URcbJCq+aB5Vv9UfG+eJlu/K1M6eO+S2+P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913304; c=relaxed/simple;
	bh=KNOaL+LT/s5yrmf9dq0zMiWl7mvGJKI383C1LGeibgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gF0kOlBmjYOzxnJeQGCFfn3Hcgngzi7FIQMfQJsz/aWZl8RZ9S0p3nasURtaqPvhvzAJ7GaMOcyii52sngurJjzX20Wts5C5R21xUjEVlkkvOMKtvm0qRlbXjNAz9Uckntm4MW8d8Usa1VQu4ZeWISJSj9MaT1ClX0eZtIGludM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtSxTw/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtSxTw/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1125AC4CEE4;
	Thu, 17 Apr 2025 18:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913304;
	bh=KNOaL+LT/s5yrmf9dq0zMiWl7mvGJKI383C1LGeibgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtSxTw/DGPWBeSuuEjwfM2qX+FDPdnxD3265ZgzFfo75tdZG5CBIqDoWnFWT5x3sn
	 Au4fVk5cDISBQjuppFilhgnQvmMGn+pSDCBnRZt0oPzows9+SVSA0XdEuJH+o5fVMZ
	 vB/+bxo7ue4jw3jP3DNpZlz+nxUWldN0rlv3AevU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jackson.lee" <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 264/449] media: chips-media: wave5: Avoid race condition in the interrupt handler
Date: Thu, 17 Apr 2025 19:49:12 +0200
Message-ID: <20250417175128.646306824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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


