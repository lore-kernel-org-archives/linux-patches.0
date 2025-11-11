Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B18F2E8B78;
	Tue, 11 Nov 2025 01:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824259; cv=none; b=WlKQijbHfBz4r0uYLjos2GpTWONx1M/imcHiqt/IVYmhaA9LKQOFRe+/w3iGRiLifSVPnKkwV1h/0eguxnr3VkTTJvABsL7GJPkTguQnG15O4z5zVupNsEOCsUUgpJWYryLEc9vJzJOCpr5i254+SWV5O8lmK1KBOmKYFwQWots=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824259; c=relaxed/simple;
	bh=tmy9AXKTL4oDSiz8Eu/UyQxrTHPAme0yFO40pGLnSec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBssVigJ83jjaS5d1oseB5TGf0mq+QRFvd4/z5A+tj6mtZoC4hoCJyC4B5VJ5ViP8w8I5aA+J8QDNy2cT9E+PdruUaWd40vRTtTCeW4FZLYT9EtPqMoSfB/Ho/2+Knm6ChUJYsENtF8Ri6mh3k3yAkOp7XED7z9WMd5KNZj3cN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQE9rBcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQE9rBcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6057C113D0;
	Tue, 11 Nov 2025 01:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824258;
	bh=tmy9AXKTL4oDSiz8Eu/UyQxrTHPAme0yFO40pGLnSec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQE9rBcGezvP5gmesLFXHc4tGQ9VeUFUTbmvW4hqi8vsaPW0xa6iCJuro12ZJ1Mli
	 KBvTyWXNaL40sqw1vzvIhzpWr2C3QEYGf58eOjCBUryIPIsdunKr2XmQaydg7XSUYb
	 SWUQkLK+cwJKL692fozWskaM+VTBum8mExUOfB/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonino Maniscalco <antomani103@gmail.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 472/849] drm/msm: make sure to not queue up recovery more than once
Date: Tue, 11 Nov 2025 09:40:42 +0900
Message-ID: <20251111004547.859755005@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonino Maniscalco <antomani103@gmail.com>

[ Upstream commit 10fb1b2fcaee5545a5e54db1ed4d7b15c2db50c8 ]

If two fault IRQs arrive in short succession recovery work will be
queued up twice.

When recovery runs a second time it may end up killing an unrelated
context.

Prevent this by masking off interrupts when triggering recovery.

Signed-off-by: Antonino Maniscalco <antomani103@gmail.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/670023/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 45dd5fd1c2bfc..f8992a68df7fb 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1727,6 +1727,9 @@ static void a6xx_fault_detect_irq(struct msm_gpu *gpu)
 	/* Turn off the hangcheck timer to keep it from bothering us */
 	timer_delete(&gpu->hangcheck_timer);
 
+	/* Turn off interrupts to avoid triggering recovery again */
+	gpu_write(gpu, REG_A6XX_RBBM_INT_0_MASK, 0);
+
 	kthread_queue_work(gpu->worker, &gpu->recover_work);
 }
 
-- 
2.51.0



