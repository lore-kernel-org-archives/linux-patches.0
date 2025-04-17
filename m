Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF88259C8C;
	Thu, 17 Apr 2025 18:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915759; cv=none; b=fofLqo0Raest5z3bkod9MTggh/iFYmJv0cvf/JffLis+hV2nLt2UNCWsSTSjOuOmmsuMOFDYhu7Vz4j/ZLkgqFO0XtklWIHvKehmFMpWOF49DsqaZHZrYYXmQCYnLJ7R77QdEOyJI1RO2t9LVoDprpN1LhJ1tukzmFNz3ca46+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915759; c=relaxed/simple;
	bh=JADnaoDmmf3yXiqVjKG4OmXLWCDUt4qfVTc6CNu513o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8ZqqcLy7MvoKnWMKF4Xrdtcj4ZSF9v4AIAO+oGfDc7iFNkxceuOlvR+4PqjAGcVWD5HSPHXZqxNhKYqZjKwSjp5VsPqIZKyadCcIhx0bXXITFrDsPlpqqHl4iUrL8yDjiHwVdmjX76uCu0KIeEf7VwbkRju30wiYxEim4TI74c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvH9h41X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvH9h41X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF9AC4CEE4;
	Thu, 17 Apr 2025 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915755;
	bh=JADnaoDmmf3yXiqVjKG4OmXLWCDUt4qfVTc6CNu513o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvH9h41X+PUjN+WOOFMgpLCvZ5I3KeJ+PgPORO/sCia8ekDTTaFR9gMQA392ri+ZM
	 RyzfvpSpS9cioA06mHpQn54dP9/qqV36DJY3YiRNnj/DH2/bLtl1zchoyLlltQS1TW
	 ST+ZRpH6FbvY6RgehsTHA1M7q84eG+4vFHSc5TY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jackson.lee" <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 230/393] media: chips-media: wave5: Avoid race condition in the interrupt handler
Date: Thu, 17 Apr 2025 19:50:39 +0200
Message-ID: <20250417175116.839762046@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -54,12 +54,12 @@ static void wave5_vpu_handle_irq(void *d
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


