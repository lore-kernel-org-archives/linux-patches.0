Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A48826FA60;
	Wed, 25 Feb 2026 01:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983938; cv=none; b=ZKqVSOhWBgGgo00Gm0j2vfMV2bnTm7It1pINtxh3bPkYN4UqPvfOORpfbgUcPgvZLHx1XokuMzZvzF/aW22Neqw497/aJpHqeK+gM+x0yxPEGyBQRJQhtMDN6fNBTsfIdW1CYCGVIOzTW85ND1DWUkf+1hlpfsHjbGFj2Xjtjeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983938; c=relaxed/simple;
	bh=0Wn5D2OB+QUkznVNi2MrXquSfrkML41h9dhc8tKljiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JScsK+5WOltql7BUE4zWdpmuZuaaJ3mfpIatunnA96SseXw5c60S6SZa6zd0D96BLia++fUXVWZchRy9qVOBDgpANx6fVe/NXsz0imTnykoX+Mfbf32bb2KYbs9EDwTRYcPpCsI8il8TiPjyOP01sJf3Wp3AWU9+SYfFbI7Q/F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqMSFFZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqMSFFZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49F7C116D0;
	Wed, 25 Feb 2026 01:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983937;
	bh=0Wn5D2OB+QUkznVNi2MrXquSfrkML41h9dhc8tKljiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqMSFFZyncl3iyL43x6U22NwdOhMwWrCZt/72JFiMZ3+KJCXKlY0ENaex0Xiy7OKW
	 zqxYRF7ShFtZeuDKKHZudi5ZVcJUSFBJp5frwL7++8S/o7jPLohyezbEZm8Jg5EGMn
	 1grzt+6BLNSF5uxyAmtBV4B3zxjNy/W48XbV38to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	David Heidelberg <david@ixit.cz>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/641] media: ccs: Accommodate C-PHY into the calculation
Date: Tue, 24 Feb 2026 17:18:48 -0800
Message-ID: <20260225012353.865333259@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 3085977e734dab74adebb1dda195befce25addff ]

We need to set correct mode for PLL to calculate correct frequency.
Signalling mode is known at this point, so use it for that.

Fixes: 47b6eaf36eba ("media: ccs-pll: Differentiate between CSI-2 D-PHY and C-PHY")
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: David Heidelberg <david@ixit.cz>
[Sakari Ailus: Drop extra newline.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs/ccs-core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ccs/ccs-core.c b/drivers/media/i2c/ccs/ccs-core.c
index 1c889c878abd3..08e78f0bf2528 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3425,7 +3425,21 @@ static int ccs_probe(struct i2c_client *client)
 	sensor->scale_m = CCS_LIM(sensor, SCALER_N_MIN);
 
 	/* prepare PLL configuration input values */
-	sensor->pll.bus_type = CCS_PLL_BUS_TYPE_CSI2_DPHY;
+	switch (sensor->hwcfg.csi_signalling_mode) {
+	case CCS_CSI_SIGNALING_MODE_CSI_2_CPHY:
+		sensor->pll.bus_type = CCS_PLL_BUS_TYPE_CSI2_CPHY;
+		break;
+	case CCS_CSI_SIGNALING_MODE_CSI_2_DPHY:
+	case SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK:
+	case SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE:
+		sensor->pll.bus_type = CCS_PLL_BUS_TYPE_CSI2_DPHY;
+		break;
+	default:
+		dev_err(&client->dev, "unsupported signalling mode %u\n",
+			sensor->hwcfg.csi_signalling_mode);
+		rval = -EINVAL;
+		goto out_cleanup;
+	}
 	sensor->pll.csi2.lanes = sensor->hwcfg.lanes;
 	if (CCS_LIM(sensor, CLOCK_CALCULATION) &
 	    CCS_CLOCK_CALCULATION_LANE_SPEED) {
-- 
2.51.0



