Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5087D4C9574;
	Fri, 15 May 2026 16:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862588; cv=none; b=exOmPLSoqvDP1rR9CLSJATeHqvSYQEGZpg1Fheys24G7mKORGRtny80VL1JWx+blQ51a8yGnDhpag8ObGELlDxmt3LCdHJqUaSTfV7fKWYg0uth1FZDHO30OtqeaTMHUTnORkE6ucLiTY7OUUVr1HfdJ9L3ZV5lUc5kAe86I4RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862588; c=relaxed/simple;
	bh=1CqYAbtcM96E/j2bNb3a45HWJ24ABF1IpBeF3yloumM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAdfOZsDSJYrVBMR8Yw85I/TA7PXaJb7tNPwLSPOEybmEBdqd3b04JpniqSZ41l/GZbXmfMApZJDcmYGcAyPTns004CFiBfQdSIzc7/nIpNnE+/1Zk8ZpFNCPAGdGItSQ7L4q2oDkC3UvPEPYu/u/YzRFfgq0Gtsh6uRskUhbrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTFzPqau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTFzPqau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA6BC2BCB0;
	Fri, 15 May 2026 16:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862588;
	bh=1CqYAbtcM96E/j2bNb3a45HWJ24ABF1IpBeF3yloumM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTFzPqau8S4BLvKkfN9UcbHft8PUNPd0Spuyvrpqv3JicR3BEUzosToESTLjjQPME
	 lRrUctBAlkROIw60CChQSB/7WOoiGlSEzTP5IpIVXAz2p0aqxpspR57H3gI/iasTii
	 +T2fdGMn2t65rP36rNDc3mJNFqgOxoZnGJwrOLu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 106/201] spi: mpfs: fix controller deregistration
Date: Fri, 15 May 2026 17:48:44 +0200
Message-ID: <20260515154700.845884401@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 573c7db8fce91a1b07dd64a260bb44b9e6d05943 upstream.

Make sure to deregister the controller before disabling underlying
resources like interrupts during driver unbind.

Fixes: 9ac8d17694b6 ("spi: add support for microchip fpga spi controllers")
Cc: stable@vger.kernel.org	# 6.0
Cc: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260409120419.388546-21-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mpfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mpfs.c
+++ b/drivers/spi/spi-mpfs.c
@@ -574,7 +574,7 @@ static int mpfs_spi_probe(struct platfor
 
 	mpfs_spi_init(host, spi);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		mpfs_spi_disable_ints(spi);
 		mpfs_spi_disable(spi);
@@ -592,6 +592,8 @@ static void mpfs_spi_remove(struct platf
 	struct spi_controller *host  = platform_get_drvdata(pdev);
 	struct mpfs_spi *spi = spi_controller_get_devdata(host);
 
+	spi_unregister_controller(host);
+
 	mpfs_spi_disable_ints(spi);
 	mpfs_spi_disable(spi);
 }


