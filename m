Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C13A1D88D0;
	Sun,  7 Sep 2025 20:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276842; cv=none; b=lvfAZZATAjNiYHPwJMP38+XUPE2me3eQGxQl3bomeuc8LSH7XvYHK9D+tShIKa2JQAuJ14nWhZivaUrqgP/1xaMCjOKecY7xo2BIClcArzUCe3E5cY14jCxCRCbv5ujg/d8VBszPMERkUWRHpHYsQqPj2tlfERcQsoD3Sko/7SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276842; c=relaxed/simple;
	bh=O1nzX3F6VN/Ei87rOZM8cKeszaJF3x1jhf+mVGZKAmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGhN8e/pZbdMTfSnQhvMbJhtcRpX+8zkEuOMJB/yc55X/XPTmPN3IwFBM75TggHmTCD36jMcMn1b4viD7/1QBiTzRMKpo526NIejY0NF8MHZZDKl07iACLiLxoCTSfFZCIZFHucjdveQ5r0FuWduyEzigiQc7SFBwMfL41O6Nbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hi1GJVV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hi1GJVV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15645C4CEF0;
	Sun,  7 Sep 2025 20:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276842;
	bh=O1nzX3F6VN/Ei87rOZM8cKeszaJF3x1jhf+mVGZKAmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hi1GJVV5XQaSbUujwkl8zqS9KlAn8HLj/OsCTAtOXjfYB1DsYMk8A8Fs9QMUprKiH
	 80JtRX8zgMdyQXG3OeFUV8F4TFOSJ6roUmNmlq0w8+xtcwhs6+T2w8u8PaOcWrAyIV
	 khFItn4Od5xQqIJHbIefi04ipJdjsMiJRZymp9Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/121] spi: spi-fsl-lpspi: Reset FIFO and disable module on transfer abort
Date: Sun,  7 Sep 2025 21:59:00 +0200
Message-ID: <20250907195612.518241048@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit e811b088a3641861fc9d2b2b840efc61a0f1907d ]

In DMA mode fsl_lpspi_reset() is always called at the end, even when the
transfer is aborted. In PIO mode aborts skip the reset leaving the FIFO
filled and the module enabled.

Fix it by always calling fsl_lpspi_reset().

Fixes: a15dc3d657fa ("spi: lpspi: Fix CLK pin becomes low before one transfer")
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://patch.msgid.link/20250828-james-nxp-lpspi-v2-3-6262b9aa9be4@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index b1ed34d237948..d437ed1349edb 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -730,12 +730,10 @@ static int fsl_lpspi_pio_transfer(struct spi_controller *controller,
 	fsl_lpspi_write_tx_fifo(fsl_lpspi);
 
 	ret = fsl_lpspi_wait_for_completion(controller);
-	if (ret)
-		return ret;
 
 	fsl_lpspi_reset(fsl_lpspi);
 
-	return 0;
+	return ret;
 }
 
 static int fsl_lpspi_transfer_one(struct spi_controller *controller,
-- 
2.51.0



