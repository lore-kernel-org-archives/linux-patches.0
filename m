Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B58313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301042; cv=none; b=jvEUtOPIUmQdzTXYjreL1zXuJE4NGkLR97qMxfRp8VG76UBpoAfmETevtrci5S4kiVrHsK+81yo0Nkt9BgjNf1e2kpBAy0ptM0VtdTDKxU51H4Xp2jShxk2EoykKYmbcBSWOLA7sVWeuPYBBqht9B2A/py2BQFzekJbFVOC48zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301042; c=relaxed/simple;
	bh=3CLd5qKIcPjQnHfPnPrBIHoRr5SRZxROPj3AIzkr4O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9PQTSs19DwYid3FbJlY+83dYYU9tKHJBM5VLDZp3mF/SusXBfCfnqPbdoJz44aRU1IfuX7w4XtbTePj3CnxZkvO1GxHShrtABDvXmdm4GJz7qc1AHo+FQtps8+uX53Wsezev6AdK/MBZfwvWZ7SHffLdDVSpt2Ydm3S5687q/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlYMLxW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlYMLxW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB99C116D0;
	Sat, 28 Feb 2026 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301042;
	bh=3CLd5qKIcPjQnHfPnPrBIHoRr5SRZxROPj3AIzkr4O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlYMLxW/zU+Z3bFM2rHyaQoaHGwo4VXjpRAJgXgUKbjUbZLvu05JjDJGpgrNpzxMn
	 p8YnHbFYkWj+p3DnGPkS0m8DOQJcwwx6MmaEtoosQ7mThvLqL7FaQIOYj4WIqs1Pxo
	 XtPNYANSf+CwFTVvsXBfyo8FeKwZrIc92WQVsHX108CGIBmnMWThefFEBLNdk7ie+t
	 BuqoeMNijZErg6vWnPqbv4WuoGcK7Pw9RXhavlQV/OrHfb23TtQFE59LLvpJjjDRMa
	 sthwYmeh/tNz/E7ZqhEBeDxYyMgzxp4+hVtyewgUONZaqG0T0bkJ0r5qf3T5r58RBn
	 D0dg+CnVaGJzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Rui Wang <rui.wang@ideasonboard.com>,
	Stefan Klug <stefan.klug@ideasonboard.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/752] media: rkisp1: Fix filter mode register configuration
Date: Sat, 28 Feb 2026 12:38:11 -0500
Message-ID: <20260228174750.1542406-180-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Rui Wang <rui.wang@ideasonboard.com>

[ Upstream commit 5a50f2b61104d0d351b59ec179f67abab7870453 ]

The rkisp1_flt_config() function performs an initial direct write to
RKISP1_CIF_ISP_FILT_MODE without including the RKISP1_CIF_ISP_FLT_ENA
bit, which clears the filter enable bit in the hardware.

The subsequent read/modify/write sequence then reads back the register
with the enable bit already cleared and cannot restore it, resulting in
the filter being inadvertently disabled.

Remove the redundant direct write. The read/modify/write sequence alone
correctly preserves the existing enable bit state while updating the
DNR mode and filter configuration bits.

Signed-off-by: Rui Wang <rui.wang@ideasonboard.com>
Reviewed-by: Stefan Klug <stefan.klug@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260105171142.147792-2-rui.wang@ideasonboard.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-params.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
index f1585f8fa0f47..1c90b1810fcb9 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-params.c
@@ -409,12 +409,6 @@ static void rkisp1_flt_config(struct rkisp1_params *params,
 	rkisp1_write(params->rkisp1, RKISP1_CIF_ISP_FILT_LUM_WEIGHT,
 		     arg->lum_weight);
 
-	rkisp1_write(params->rkisp1, RKISP1_CIF_ISP_FILT_MODE,
-		     (arg->mode ? RKISP1_CIF_ISP_FLT_MODE_DNR : 0) |
-		     RKISP1_CIF_ISP_FLT_CHROMA_V_MODE(arg->chr_v_mode) |
-		     RKISP1_CIF_ISP_FLT_CHROMA_H_MODE(arg->chr_h_mode) |
-		     RKISP1_CIF_ISP_FLT_GREEN_STAGE1(arg->grn_stage1));
-
 	/* avoid to override the old enable value */
 	filt_mode = rkisp1_read(params->rkisp1, RKISP1_CIF_ISP_FILT_MODE);
 	filt_mode &= RKISP1_CIF_ISP_FLT_ENA;
-- 
2.51.0

