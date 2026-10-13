Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858636E466;
	Tue, 13 Oct 2026 12:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894014; cv=none; b=JxmglFLeIX+bV2YTOgXeKgODLbfOpJ2vgq8X7YFRmoCjfNbJ5c1U471nKdn9x9pyZSOu88rOVX+YqjUa6ZiC6GyFH3PLKYrSmDdTGORQqIa62SkaErMV4/3zLIWZcI5nlQ9696OtNFuKfvfnmJeFpSlLiIIdwid0tjYI+bCleAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894014; c=relaxed/simple;
	bh=NDlTfzt92Kmy+NF2LQ5/FCKzhlbdmNJaUWzN+sg9+FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EU53bc45g4ShWc0VllZVAd6jQS3ME5V0kDktHD8NESDplYmOl//G2BHIKFb9/xih5Sia45U65krdoDwMuQxaG5c3agwjWJULJECoWQmQ0RhYwtzMVqR3kvQlwjshqdMvMKuyNgktBYFiBgFcKqF6xKKugBEzirzsTPkWIUTAhmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QVXpstP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QVXpstP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24F31F000FF;
	Tue, 13 Oct 2026 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894013;
	bh=asfjfWcnk712y8ns9QCyLwjQQuTCK/t4wdTbhfNRZ+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QVXpstPkwaS/C6wRI6cRwucpEYKaG9f53ysYQGVkXKbSLdPhFH5DOoa4Ey9cFmK2
	 TCxL3sHybApCrvz36J/bLl1LC8VB9+0i2MGfoy0TEYLQVMhMk86tH9+Pqu68pPjcCb
	 K8L//wxoCkEehz/hDu0PKD/9aZqOttEmt/VsV310=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/621] media: chips-media: wave5: Resume device before setting EOS flag
Date: Tue, 13 Oct 2026 13:36:26 +0200
Message-ID: <20261013112930.121460365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jackson Lee <jackson.lee@chipsnmedia.com>

[ Upstream commit a52e6f7923c17a672135b485ffd96fbd72f46267 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../chips-media/wave5/wave5-vpu-dec.c         | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index 30f523a5edb15..e1ad685a42e52 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -809,7 +809,15 @@ static int wave5_vpu_dec_stop(struct vpu_instance *inst)
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
 
@@ -1706,10 +1714,21 @@ static void wave5_vpu_dec_job_abort(void *priv)
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
+
+	pm_runtime_put_autosuspend(inst->dev->dev);
 }
 
 static int wave5_vpu_dec_job_ready(void *priv)
-- 
2.53.0



