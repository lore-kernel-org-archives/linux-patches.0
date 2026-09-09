Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F9D56E051;
	Wed,  9 Sep 2026 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962801; cv=none; b=TCsalpgPV8bg50sqEpRTV0JB/bc7hdwmhqGtnke/2sGc6TaXJ4JGewGPK3hUIJsiCz0FAIKwMt8CtXAIEwiyb2o63OBI7vPjSSGSr8TOPsi0kU3qO5Legdm8emZmtXJOcIaOObLgEyLEj1U3+zdthTmVgrgjaiWD3YKHKRQAPiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962801; c=relaxed/simple;
	bh=YG+nvKHtw+lg67bHt/2UfsPfcWK9EjF5YhbMaFP1eKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/gIRp6P/2WGQ5w77r3CdGA8DH3tbmSVWuEW/ZdUyYnFCdYrgaarsnqz08/qQ2dUCsHaGV3f9KV4gLgqtTLB/S14yfxiZ/VIMoakSyRNUrS62R4uF4riofd7spvEyuA/n66gOPAzrgTQ8wxqCH692ZUX1vQclsv2kjXRX4ZAp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJbhI6Xt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJbhI6Xt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6E31F00A3A;
	Wed,  9 Sep 2026 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962800;
	bh=hf19owVUZCYmVaXUfaIuQlheiqaMaz6h9FKIVFiboqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJbhI6Xtx/VEl/DqwkBPG39F1Kkq9qVT8rJqZSfVjAid5W6lnmKOmsc61EzAhs4b2
	 SRl8Nno5x/GZasFWLJ8qUTIKPTinTU/PxeDF9FLfaLPh4Hg8Zvh4DAbPDGbNZHP+Ns
	 YF2IVFuJpBSk18ndVkEWPsrhWm6UnFL+OrkzCJfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 415/556] media: chips-media: wave5: Resume device before setting EOS flag
Date: Wed,  9 Sep 2026 15:41:35 +0200
Message-ID: <20260909134245.206217181@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson Lee <jackson.lee@chipsnmedia.com>

commit a52e6f7923c17a672135b485ffd96fbd72f46267 upstream.

Setting the EOS flag talks to the firmware via send_firmware_command(),
which accesses VPU registers. Both the STREAMOFF path
(wave5_vpu_dec_job_abort()) and the V4L2_DEC_CMD_STOP path
(wave5_vpu_dec_stop()) can run while the device is runtime suspended, so
those register accesses hit powered-down hardware and the SoC raises an
asynchronous SError, panicking the kernel:

  SError Interrupt on CPU3, code 0x00000000bf000000 -- SError
   send_firmware_command+0x2c/0x160 [wave5]
   wave5_vpu_dec_set_bitstream_flag+0x6c/0x80 [wave5]
   wave5_vpu_dec_update_bitstream_buffer+0x80/0xec [wave5]
   wave5_vpu_dec_job_abort+0x44/0xa0 [wave5]
   v4l2_m2m_cancel_job+0x110/0x19c [v4l2_mem2mem]
   v4l2_m2m_streamoff+0x24/0x140 [v4l2_mem2mem]

Resume the device with pm_runtime_resume_and_get() around the EOS
firmware command and release it with pm_runtime_put_autosuspend(),
matching the runtime PM handling already done in
wave5_vpu_dec_device_run().

Fixes: 9707a6254a8a ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c |   19 +++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -823,7 +823,15 @@ static int wave5_vpu_dec_stop(struct vpu
 		 * calls do not block on a mutex while inside this spinlock.
 		 */
 		spin_unlock_irqrestore(&inst->state_spinlock, flags);
+		/*
+		 * V4L2_DEC_CMD_STOP can arrive while the device is runtime
+		 * suspended (e.g. on pipeline teardown). Setting the EOS flag
+		 * accesses VPU registers via send_firmware_command(), so the
+		 * device must be resumed first to avoid an asynchronous SError.
+		 */
+		pm_runtime_resume_and_get(inst->dev->dev);
 		ret = wave5_vpu_dec_set_eos_on_firmware(inst);
+		pm_runtime_put_autosuspend(inst->dev->dev);
 		if (ret)
 			return ret;
 
@@ -1797,11 +1805,22 @@ static void wave5_vpu_dec_job_abort(void
 	if (ret)
 		return;
 
+	/*
+	 * job_abort() runs from the STREAMOFF path and may be called while the
+	 * device is runtime suspended. Setting the EOS flag talks to the
+	 * firmware (send_firmware_command() accesses VPU registers), so the
+	 * device must be resumed first; otherwise the register access faults
+	 * with an asynchronous SError.
+	 */
+	pm_runtime_resume_and_get(inst->dev->dev);
+
 	ret = wave5_vpu_dec_set_eos_on_firmware(inst);
 	if (ret)
 		dev_warn(inst->dev->dev,
 			 "Setting EOS for the bitstream, fail: %d\n", ret);
 
+	pm_runtime_put_autosuspend(inst->dev->dev);
+
 	v4l2_m2m_job_finish(inst->v4l2_m2m_dev, m2m_ctx);
 }
 


