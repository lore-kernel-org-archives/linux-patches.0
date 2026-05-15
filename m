Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7B83E0089;
	Fri, 15 May 2026 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862591; cv=none; b=L8AiEb3hrc0EvC20nMraBiia1VRHFVw9sdtEmQyvRZ/fyRtcu/DjaU+tKZizQo0lxxS/QBw7jYn7M8eraTkwOFkcxXefrTNVYP7INdVC+kwEcH6TwTraWQkdk0ZDkTn1EXHmmB0KzgPlmJtW/rDW4Awcqcqwu+urPEgTK7hDYPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862591; c=relaxed/simple;
	bh=FvwA3mAkrMohEOvKV0pf3LIFcQrofwMUp2VOzt7TtzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRkB6tHLvbR6QpMagS/W0oDAbVXMIb5lVzBRp5oocGMne9lHHevClpi1lW8x0W7GY2uY2Q7iSpTs6L27QBrXpB96rsc09t2vsNcUGSvsDjG92Q1D+Jn83P4AhJTwJp5LRy6X7RWYRkkZtDl38w9haEYgwrE/dvvmLqTnETLNADQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIF/gdVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIF/gdVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A59DC2BCB0;
	Fri, 15 May 2026 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862591;
	bh=FvwA3mAkrMohEOvKV0pf3LIFcQrofwMUp2VOzt7TtzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIF/gdVNqAlKB+bj/ANWsQ3griBe11R+kuo6BfqO5lGiMUbp/Bc0bQnzhj76Yuz77
	 C9NOctOcxdoLZ2/EvO3ukMWuEj9ZQqwHS4/pod05cxBcR8vj7cPRmASt9Z3agBsO8r
	 ufeS10wK2Msvr/OQmaIIJVYCYaqfbesMkW37+8nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 107/201] spi: octeon: fix controller deregistration
Date: Fri, 15 May 2026 17:48:45 +0200
Message-ID: <20260515154700.867723210@linuxfoundation.org>
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

commit 3c49a4d8799bee423a80f392ba95b26af8e9ab91 upstream.

Make sure to deregister the controller before disabling it to avoid
hanging or leaking resources associated with the queue when the queue is
non-empty.

Fixes: 22ad2d8df77d ("spi: octeon: use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-9-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cavium-octeon.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-cavium-octeon.c
+++ b/drivers/spi/spi-cavium-octeon.c
@@ -54,7 +54,7 @@ static int octeon_spi_probe(struct platf
 	host->bits_per_word_mask = SPI_BPW_MASK(8);
 	host->max_speed_hz = OCTEON_SPI_MAX_CLOCK_HZ;
 
-	err = devm_spi_register_controller(&pdev->dev, host);
+	err = spi_register_controller(host);
 	if (err) {
 		dev_err(&pdev->dev, "register host failed: %d\n", err);
 		goto fail;
@@ -73,8 +73,14 @@ static void octeon_spi_remove(struct pla
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct octeon_spi *p = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	/* Clear the CSENA* and put everything in a known state. */
 	writeq(0, p->register_base + OCTEON_SPI_CFG(p));
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id octeon_spi_match[] = {


