Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6586233A9FC;
	Thu, 28 May 2026 20:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000932; cv=none; b=bj7+S2e6XT6YfZ93pCU7bdqJ0gw2Ly5G1hsqc/8kX3eIL2AuEABYP7kVyMblZR9YjQl/3fn1Sa0HeMEyTyBIl8y2UQsxDBryagzqzJvyoX9h99rD2LA0a4CF4m9z91Rfmv/ZC1zJeMR55b7IL+qPpQayQQ/cr9wiX8CA7Vuy48Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000932; c=relaxed/simple;
	bh=i+wRXxPhrS9A/3veoqjEKyTzZGSxzZLw09nErHPs4eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEj4PBVi/2MQI6VukSWHp7jTP46AmwQcxCtRHyTVf0i3WKvGIYF8qEOVcaEe9J3RfU32qyiQZG92i3qDnvV/BvPH++6jy4eisBV9uMj04xHx8O/qocrjvd3kNmXpUdEDBsQ8NztT2Uk6LonPZe8VxqOlOz4wDRvGqPmFHoSxGdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmOPyuy7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmOPyuy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30BF1F000E9;
	Thu, 28 May 2026 20:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000931;
	bh=XB4fb0AzFK8ps3S35PQSdsHYy7OlORLD0VkkcHShHhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmOPyuy7Jj7nI5INGnBBQK62yhGpChVeGfUBwiLo306wE1e0HeplgHALjWeQPbGcS
	 Fd0Gseelr0YsnH/iuBRr51ECVIunAnI2WQJ1ZwPHm8LNeUg38iXA4KlNd9HZfMPhJm
	 MJ8hiqeB4l7e4rTNJPG/PVNQDHQyfDYe1xmrvca4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/272] drm/msm/dsi: dont dump registers past the mapped region
Date: Thu, 28 May 2026 21:49:55 +0200
Message-ID: <20260528194635.386679465@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6f538c578f740..c9b580771609b 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1942,6 +1942,7 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* fixup base address by io offset */
 	msm_host->ctrl_base += cfg->io_offset;
+	msm_host->ctrl_size -= cfg->io_offset;
 
 	ret = devm_regulator_bulk_get_const(&pdev->dev, cfg->num_regulators,
 					    cfg->regulator_data,
-- 
2.53.0



