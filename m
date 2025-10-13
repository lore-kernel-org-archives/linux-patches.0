Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B0130C601;
	Mon, 13 Oct 2025 15:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368200; cv=none; b=nfZ+5Wr9h25WCqKpy2Iu+kXgBVCkD46WLwU9JOR7akDHrvMZnyLcHMlJKp4teMw12hWCNy5DFO2Abf6JY7XlGbv5QbF7NAOoU+rs1lvMJqcq8OMIATD0e1ZIjM3Aeg8TlwSdAt9gDswCHkp+Yj+20ZloTph/mGTRkWdH7lP0bVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368200; c=relaxed/simple;
	bh=mlHIBPMJT8ZepJmzCOq2P41SPcetpnMo5NisEjqBf/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/MvKeeE5Ul2z67gTVwoHSmNyMj1A3mkPkUhy0vhPZ6J9Dy+Ag6lMXXNYSIBpo7e1o2D8BsCZ/aJs6W7V/xXXc9RHZ7NorWFqO8A/rJBrjtjW3LooExAOyETXjT/RIX25yWL0W7RHYW7aR/iyubJzwR/9l3nSvehHFLOOgjQYAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqRfQHWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqRfQHWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B7BC4CEE7;
	Mon, 13 Oct 2025 15:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368200;
	bh=mlHIBPMJT8ZepJmzCOq2P41SPcetpnMo5NisEjqBf/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqRfQHWgkUTDbaNnMEAnBKQES+KX9R9S1lcNmPr7lCa07uzdRMaI07ygzaT2L77KR
	 pOJmC5lWLf9/naNhA6gExzEpJ5IVWeR1CXmT9g6WeGFiHbXkSuwWmItUJdq6UEF+fl
	 BpEXqNGvSazCYqvYzpukUo7mNAji68HK/3NfMfXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/262] spi: fix return code when spi device has too many chipselects
Date: Mon, 13 Oct 2025 16:43:41 +0200
Message-ID: <20251013144328.972451559@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 188f63235bcdd207646773a8739387d85347ed76 ]

Don't return a positive value when there are too many chipselects.

Fixes: 4d8ff6b0991d ("spi: Add multi-cs memories support in SPI core")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250915183725.219473-2-jonas.gorski@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 8d6341b0d8668..5ad9f4a2148fa 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2462,7 +2462,7 @@ static int of_spi_parse_dt(struct spi_controller *ctlr, struct spi_device *spi,
 	if (rc > ctlr->num_chipselect) {
 		dev_err(&ctlr->dev, "%pOF has number of CS > ctlr->num_chipselect (%d)\n",
 			nc, rc);
-		return rc;
+		return -EINVAL;
 	}
 	if ((of_property_read_bool(nc, "parallel-memories")) &&
 	    (!(ctlr->flags & SPI_CONTROLLER_MULTI_CS))) {
-- 
2.51.0



