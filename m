Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1A933B974;
	Wed,  3 Dec 2025 16:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779264; cv=none; b=b13sGNNemP+4VK29M+fnt0MhzcsTZknwJsvznl55kkp/Uy7mlYPT3ag52Hs4LcN/92mO/tR9R6nkBniKVVuTsd3SjT1f2FkgHgAsLc2y8U5Lcb6QEx384isNUckd4DsXCnRR0VtFBSTcaMqnFMM60yrYH8JzIEGhp9oAZTRZ+UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779264; c=relaxed/simple;
	bh=BHaDXYVQX/SEGzZfdkIUd+LbTR22LgMSVQs30p58OGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5Vb/e6sXNy+Prx7Pj9ccuCiS9rVNNC8DBD7oYaL4BUC6DwySIStlBNvqRgLdhj331E1vywT8NYSncxxz7bRDg5X671y8TXO8D6qtWC7AeqD8dILu06nfc1W7VwQkf/ts/vKTZWJGTzsheVJzCKt8uRZwG+P/o6V//anK37Si9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=reY+Z53H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="reY+Z53H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830DCC4CEF5;
	Wed,  3 Dec 2025 16:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779263;
	bh=BHaDXYVQX/SEGzZfdkIUd+LbTR22LgMSVQs30p58OGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=reY+Z53H23Ff/RSMPa2n2Zis7uWhg7Mu+DYVyMi+H5SWBd640G4hLuq1R/6jPF1im
	 OStlXNV8dVQ/qh9kCG5TCVcEs/0ftSaMmAAlmAVOLiWQ6DiTruOQyrXcaHG+mpOWSC
	 BWrEmeNMb7ijsYbeU5eFD5so6BLuzNHEH50JC3+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonino Maniscalco <antomani103@gmail.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/568] drm/msm: make sure to not queue up recovery more than once
Date: Wed,  3 Dec 2025 16:23:26 +0100
Message-ID: <20251203152448.197633905@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index cdb4665b953c8..e06204e00e935 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1507,6 +1507,9 @@ static void a6xx_fault_detect_irq(struct msm_gpu *gpu)
 	/* Turn off the hangcheck timer to keep it from bothering us */
 	del_timer(&gpu->hangcheck_timer);
 
+	/* Turn off interrupts to avoid triggering recovery again */
+	gpu_write(gpu, REG_A6XX_RBBM_INT_0_MASK, 0);
+
 	kthread_queue_work(gpu->worker, &gpu->recover_work);
 }
 
-- 
2.51.0



