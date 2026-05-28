Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F886316905;
	Thu, 28 May 2026 20:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001477; cv=none; b=dOdIumHxLsrCSW6zpgcdBSFa344cHeNJMBbKeRiU2TOhrFXmajr6eB7+AtXFebOQMUS1LWfkxD2K6x2QCW16FAMCnRxACxTozg4/jeAaaru567Jf6MUsIWhmFYevugm59IxNVbLbOIHSIpguxOo/cb5a1Cd8YdrC2HjWNBjb0Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001477; c=relaxed/simple;
	bh=Kn7+jvF1KRUtyOlW6E7AMbMs84IoCTbal5cTih4tpZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKQ6XO73F8UaUeusRFEeZA8LeNX4wiOrhfA48q5H0s7HKyOAi2upzLcBoRS2DUeUeu8LNQrNoKfOnlfxinuSRFk1cHfq2WTNa4Eu0TpCPMHFuHjLbKiDgQ7hd1AS0NwPnLyaO3YvuJjvj18SIrjRseckSF+pwtovT4TWCH/Edik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtxn7p1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtxn7p1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96601F000E9;
	Thu, 28 May 2026 20:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001476;
	bh=nuWYQ2x65AUvoJOna3+6q0ggKdMsEvyj3Z1LS8nog2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtxn7p1mKjKJlIEOSLwWdTKKQhokT1gNIu08SkWUX0RGJcnZFPGPigfe/XUt9K+hl
	 fXtDdzvFqkFvTZwyI9hUGmCCA3+6cYUn6K4VeFVzfqXwR3Ql2IsN0ZlFexOQ5iU5s0
	 KqKrKCgbX4VGN5UO3RCvHyB1+X1lqI0zSpHK7Ekc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/186] drm/msm/dsi: dont dump registers past the mapped region
Date: Thu, 28 May 2026 21:50:20 +0200
Message-ID: <20260528194932.730781763@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 5b49a46baa853b26dbefa65c6c75dd9ff69f63d4 ]

On DSI 6G platforms the IO address space is internally adjusted by
io_offset. Later this adjusted address might be used for memory dumping.
However the size that is used for memory dumping isn't adjusted to
account for the io_offset, leading to the potential access to the
unmapped region. Lower ctrl_size by the io_offset value to prevent
access past the mapped area.

 msm_disp_snapshot_add_block+0x1d4/0x3c8 [msm] (P)
 msm_dsi_host_snapshot+0x4c/0x78 [msm]
 msm_dsi_snapshot+0x28/0x50 [msm]
 msm_disp_snapshot_capture_state+0x74/0x140 [msm]
 msm_disp_snapshot_state_sync+0x60/0x90 [msm]
 _msm_disp_snapshot_work+0x30/0x90 [msm]
 kthread_worker_fn+0xdc/0x460
 kthread+0x120/0x140

Fixes: bac2c6a62ed9 ("drm/msm: get rid of msm_iomap_size")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/721747/
Link: https://lore.kernel.org/r/20260428-msm-fix-dsi-dump-v1-1-5d4cb5ccfac7@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 771ac34561037..f5ac0e20665f7 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1929,6 +1929,7 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* fixup base address by io offset */
 	msm_host->ctrl_base += cfg->io_offset;
+	msm_host->ctrl_size -= cfg->io_offset;
 
 	ret = devm_regulator_bulk_get_const(&pdev->dev, cfg->num_regulators,
 					    cfg->regulator_data,
-- 
2.53.0



