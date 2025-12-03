Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D24834E769;
	Wed,  3 Dec 2025 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777869; cv=none; b=m1/TSH74RUOJZjGVsHI9leUsrjmKChRZa53nL8At2WMkLCXWmzZ9y5MeFlYekM3rVOlvOdf0WFrvKxWfig9nPy4yUXNUNPV++vhi+UZvjJiNlJwmLH2knaQUSAWmGg7vARHHy1mnKkj3CY6sfWB+wxW7x4HCnNXzftHJpjzDy3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777869; c=relaxed/simple;
	bh=L+LyCavVTfDRMhMG2qmn85b1vJT/qA6g/ggPOEjBTo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjDpTBVqIj3HaSS7c/5D5Xb+joE8mnxDJxSuJjXurIKRp6KZyvqCIqezpul1kKDUvEwY03IMl0oE+mjuoFM4QBEJ5VRqMMchsK6Zvsfrybp67UlrT5iYmcpkvu/y2INpSnoYnW3veYCF8YM6NyQmpkftKcbBsZ5botC82n/8ziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuLTO8hU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuLTO8hU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC16C4CEF5;
	Wed,  3 Dec 2025 16:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777869;
	bh=L+LyCavVTfDRMhMG2qmn85b1vJT/qA6g/ggPOEjBTo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuLTO8hU5ECzE6kg1o3b4rYWeejiCrw00Wxr3XwCbf7V8Z6CYxB0c2ATaplk74JWV
	 Qk6pcdzT4bw7NoYOwLeMO0mijDxXl55Ii2Ke7FGeUrh6/61vUBA73YNz/ltZCdFuuT
	 l9uookhrKPINRVyauqX9tuQFE4GyplHZFLjLG6s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonino Maniscalco <antomani103@gmail.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/392] drm/msm: make sure to not queue up recovery more than once
Date: Wed,  3 Dec 2025 16:24:49 +0100
Message-ID: <20251203152419.204096005@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1c38c3acacbeb..95c31009bbec1 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1386,6 +1386,9 @@ static void a6xx_fault_detect_irq(struct msm_gpu *gpu)
 	/* Turn off the hangcheck timer to keep it from bothering us */
 	del_timer(&gpu->hangcheck_timer);
 
+	/* Turn off interrupts to avoid triggering recovery again */
+	gpu_write(gpu, REG_A6XX_RBBM_INT_0_MASK, 0);
+
 	kthread_queue_work(gpu->worker, &gpu->recover_work);
 }
 
-- 
2.51.0



