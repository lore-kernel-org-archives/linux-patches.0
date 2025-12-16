Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EC4358D02;
	Tue, 16 Dec 2025 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888131; cv=none; b=sACakPJ95lGdr0D/FG1uOVgn8IMp9J8/sNtHRPc/BMeiU90HlzW33Q5wFHxVl3PNHtpFniLK1y8XYaUFQyCaJnfiH6a7PEf3lyZp2fdmv9xP0zIPti2y0kGvclcItKBOXUuatDE8WudMbCmjOX8LqkDLeXWkm6dzFh8Eku+L1gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888131; c=relaxed/simple;
	bh=DaT+H4WO65guA/rUoJ6NlojCyOgnhts2xY/HwDsANLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGlg2Aew0cjLZvLjb79VPhv2XL1w7HW6HWqTo0MITFViyPxDAHDnUWu+jeM5OolIepxT8aBXn7Fr39Vrktu1STOiSa9P6g0C75t7aOcfICMZhcTulDL+xSFuvdggDiEIjQJe7/woAB7itB6t7lysIPEZfMk5T01shCXYPSIaUsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhIQAOpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhIQAOpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DCAC4CEF1;
	Tue, 16 Dec 2025 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888131;
	bh=DaT+H4WO65guA/rUoJ6NlojCyOgnhts2xY/HwDsANLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhIQAOpW6yJ7N+qBotPWdf2W0e+xeO6VR05+GzWpyGQBhKeamiVtHei0JoSN+c73U
	 MmLg38ZknkFIThG+QRGAGpzi/DjNC5qBZVYGkvu56TwZcDG9af0kWp1rJIR8B4Pzmz
	 rB+c85i9vi3uvdOfO2jylrATKINY36eLEYWeU2sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 441/614] ASoC: fsl_xcvr: clear the channel status control memory
Date: Tue, 16 Dec 2025 12:13:28 +0100
Message-ID: <20251216111417.350792641@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 73b97d46dde64fa184d47865d4a532d818c3a007 ]

memset_io() writes memory byte by byte with __raw_writeb() on the arm
platform if the size is word. but XCVR data RAM memory can't be accessed
with byte address, so with memset_io() the channel status control memory
is not really cleared, use writel_relaxed() instead.

Fixes: 28564486866f ("ASoC: fsl_xcvr: Add XCVR ASoC CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20251126064509.1900974-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 5d804860f7d8c..58db4906a01d5 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1421,7 +1421,7 @@ static irqreturn_t irq0_isr(int irq, void *devid)
 						bitrev32(val);
 				}
 				/* clear CS control register */
-				memset_io(reg_ctrl, 0, sizeof(val));
+				writel_relaxed(0, reg_ctrl);
 			}
 		} else {
 			regmap_read(xcvr->regmap, FSL_XCVR_RX_CS_DATA_0,
-- 
2.51.0



