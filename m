Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BA912EBEA;
	Tue, 25 Jun 2024 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308662; cv=none; b=Xf+CrhSYpHlqFVz+tMGnVx7NKmWUlIuJDDkyxQQOx138mW1FDJXf2dACKGyh5eEf0+JLa7oBrnln0wILlqif71QNKqjvRx+Mwj6Y/onIek0AEthV2dYJpocsR0muAoTdToSW/ip0wBO+NxlE69tOuTMFw/ogaiez5eswBIHFKYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308662; c=relaxed/simple;
	bh=6iT3MBQI8tcwxa4frv2xP7jNK4We6C3tHLiVrs919Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeI5gBdGJKzpgsVrNFbI0FhpRw0DpPRuGmlHoD8gSF8byBPG4LTkapcgTr92+HGmMAVQ9cKgl37d2TIevejbww23i8WneG6WPY8Kzlb8bdvnmAkRT2ehjnFKJ+TZHV8PGITYa7mWRmPcsug+9P7VCpeuKznvPp94z+UhgUab2dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUMkaGFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUMkaGFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD45C32781;
	Tue, 25 Jun 2024 09:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308662;
	bh=6iT3MBQI8tcwxa4frv2xP7jNK4We6C3tHLiVrs919Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUMkaGFmGaBFAzoDEjB0MSv42CzvJMjPmqG67IhwsVZUdDo5HIHEtghrS0mhMksSH
	 yzcpMuNkyn9mq3zUobnDhBR9Maa+HpmjHlJQhPrmOMuotNtYy8F8cTScabWdEqYbYo
	 9u8Hal37LlvtM5eNUnfFywBsGDa3rjnokEVsJbLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 167/250] spi: Fix SPI slave probe failure
Date: Tue, 25 Jun 2024 11:32:05 +0200
Message-ID: <20240625085554.466309424@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>

[ Upstream commit 2c1b7bbe253986619fa5623a13055316e730e746 ]

While adding a SPI device, the SPI core ensures that multiple logical CS
doesn't map to the same physical CS. For example, spi->chip_select[0] !=
spi->chip_select[1] and so forth. However, unlike the SPI master, the SPI
slave doesn't have the list of chip selects, this leads to probe failure
when the SPI controller is configured as slave. Update the
__spi_add_device() function to perform this check only if the SPI
controller is configured as master.

Fixes: 4d8ff6b0991d ("spi: Add multi-cs memories support in SPI core")
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Link: https://msgid.link/r/20240617153052.26636-1-amit.kumar-mahapatra@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 2cea7aeb10f95..c349d6012625a 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -685,10 +685,12 @@ static int __spi_add_device(struct spi_device *spi)
 	 * Make sure that multiple logical CS doesn't map to the same physical CS.
 	 * For example, spi->chip_select[0] != spi->chip_select[1] and so on.
 	 */
-	for (idx = 0; idx < SPI_CS_CNT_MAX; idx++) {
-		status = spi_dev_check_cs(dev, spi, idx, spi, idx + 1);
-		if (status)
-			return status;
+	if (!spi_controller_is_target(ctlr)) {
+		for (idx = 0; idx < SPI_CS_CNT_MAX; idx++) {
+			status = spi_dev_check_cs(dev, spi, idx, spi, idx + 1);
+			if (status)
+				return status;
+		}
 	}
 
 	/* Set the bus ID string */
-- 
2.43.0



