Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2187C23EA92;
	Mon, 27 Oct 2025 19:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593519; cv=none; b=nekLjDkjpqN1IqQZMo2BxnqIeZkH5SQFodw69tcxt0ghuCIc49oOJYAwKDaI/WL0gbkb8vI4VWOV3njlKtOgYIAKlbD90hOLs5BW9Y2DSMOQi+Bu9V9rddltwiuH4PCZLq962wdO6Rl+tJsqHIklaZiGbcqkvqJxR284T1zoLSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593519; c=relaxed/simple;
	bh=BsnHBZBHWuFlFMudWx+tLrJXzqzz7yigVXyh/GkkhA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOmCVPpCYwWhrE6rvNRK0NuXD0ROC/PoCsFqhioN1YC2TL0GKseOK8+XsN4/o77yqEHj6xrjBjS79wMIX1+d7QjkVCgmSdZwMlHFRfx5aiVHzsh5rmGmgGX06Jq32Dqbj1P00cznA1HHIqASDpUt46qNq2vtKEJsnMj1cGjtu+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yDxKtsr4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yDxKtsr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5E4C4CEF1;
	Mon, 27 Oct 2025 19:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593519;
	bh=BsnHBZBHWuFlFMudWx+tLrJXzqzz7yigVXyh/GkkhA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yDxKtsr4g/B0RoTqZn0/ZTWFp1+pfb5ZYfhsQ6iHdq848tZWEFpXo5t+J1Dt6vzhc
	 5AFoE8w/8/vacT/yJQ450ah9Cf+0PsZW8nI+lq8qROTQ/5XZQe7/t4CinAYTWaaX6k
	 zmGnjvIvlz+hea27ut+6e7kOLZPGPdUyLbWlLljI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Haibo Chen <haibo.chen@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 118/184] spi: spi-nxp-fspi: add extra delay after dll locked
Date: Mon, 27 Oct 2025 19:36:40 +0100
Message-ID: <20251027183518.120808140@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Han Xu <han.xu@nxp.com>

[ Upstream commit b93b4269791fdebbac2a9ad26f324dc2abb9e60f ]

Due to the erratum ERR050272, the DLL lock status register STS2
[xREFLOCK, xSLVLOCK] bit may indicate DLL is locked before DLL is
actually locked. Add an extra 4us delay as a workaround.

refer to ERR050272, on Page 20.
https://www.nxp.com/docs/en/errata/IMX8_1N94W.pdf

Fixes: 99d822b3adc4 ("spi: spi-nxp-fspi: use DLL calibration when clock rate > 100MHz")
Signed-off-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20250922-fspi-fix-v1-2-ff4315359d31@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index 542d6f57c1aef..bde6d131ab8b7 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -709,6 +709,12 @@ static void nxp_fspi_dll_calibration(struct nxp_fspi *f)
 				   0, POLL_TOUT, true);
 	if (ret)
 		dev_warn(f->dev, "DLL lock failed, please fix it!\n");
+
+	/*
+	 * For ERR050272, DLL lock status bit is not accurate,
+	 * wait for 4us more as a workaround.
+	 */
+	udelay(4);
 }
 
 /*
-- 
2.51.0



