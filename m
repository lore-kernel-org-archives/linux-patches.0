Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0806D1A704B;
	Sun,  7 Sep 2025 20:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277336; cv=none; b=uQtze2rZDQytZodMBZg5l6zBz0oiEvKu1qQHIpEvc+oEBWlqBisSqBCvSSVAwj/oS/HoozBkmw55hrErlgu7irxOQL1X3to6CVEeC+6fL3Cp+ZJGr78jb5/8ocNNArZ2J3EEczkKOd2oXMj4qRhwdSVm+BAP2TTzaFdELeo0XxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277336; c=relaxed/simple;
	bh=Zq1wsj7aXe+SySyz1RpZM0v894lgyrVZEhh4IyntSds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igqtV0G23jUzGrhKkOMRcWNBzV+HOCmsvmBEhPXtp6KQHbhOlqA66EoyetTn413A4mAnN0zyJTeka8kH0pLT9iFj20/fCdjGdw3I+b1rrkqG4ob/riMO+k1gdU8+N3jZYps97PhbSSnFuenoTSH/OXsn9rebEtJiUNENcvtHeJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlyBTvjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlyBTvjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E0DC4CEF0;
	Sun,  7 Sep 2025 20:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277335;
	bh=Zq1wsj7aXe+SySyz1RpZM0v894lgyrVZEhh4IyntSds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mlyBTvjoiJlpDgbEcE4zRRKAmP0Fs5MEj7TPpgOeEjnMzVPwiA4LoGv6bvtrPFm7p
	 orwxW/9+2uSKYOAL9EubAzbBzobXv2ODV85oXfaBuo0V0B8trcfJiSG5PJg0BcgSkd
	 rLLTl1SYfWWYyXSA/mJvuRftllh7iMmba0IVe0aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/175] spi: spi-fsl-lpspi: Reset FIFO and disable module on transfer abort
Date: Sun,  7 Sep 2025 21:59:14 +0200
Message-ID: <20250907195618.620464325@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9d05d18451c6d..2843b559e9413 100644
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



