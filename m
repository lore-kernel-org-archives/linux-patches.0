Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824ED2949E0;
	Fri, 15 May 2026 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862020; cv=none; b=HsKBfkUCMlEYjuTRK92av3yn7hzQ5/EawdIdUv8A/unh1QavJdnfE4DxmOpPgnLpYoTrGYTB3kVXP0k69z90Wvm3VgkLcqbmiFRR6zru9wjFEaiJSJa5BWL2gs4+UgQqc5c5DvJrWtqVLjrzFYavWCSckYiCuBBQg4FqQckre8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862020; c=relaxed/simple;
	bh=FmcjpobUlxXLAUmj+8voD6T3tzCIsatRU7eUNQo5UA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCm95ldorIw/dIHVznFyguYGiaXPXAc97hSpkZkJ0EHTQm3Cu4Fyo3mCOO1ZM4yFvBBgBpIOlC7wYXnukMeit0rsWJWpcQVWUm+nZsoKg2rmiU2nhp7KvPpuLvD1g6gl1+ET9gjVY42TSiwMwHSZYadsL5tBJDNZIVcEpxIFMww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q421pIGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q421pIGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18276C2BCB0;
	Fri, 15 May 2026 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862020;
	bh=FmcjpobUlxXLAUmj+8voD6T3tzCIsatRU7eUNQo5UA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q421pIGxZK6vB+Oy/zudl8+b+QEjowig/Mmp74TvRbNeTGgfyp6/44T9P+nmUTkmn
	 1PmSo8u960w0EEQwSlW4RmpzhiEFYKVawvf5pv7zKTHj4D2qBOTv8FjErz99mhaTNx
	 whhhck6VmD4/TZUsjuS/OJsolr91/PkCPzK7qdcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Glauber <jan.glauber@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 078/188] spi: cavium-thunderx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:15 +0200
Message-ID: <20260515154659.012586427@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit dbb6b01267c0c866eaac4019cec19f414beec61d upstream.

Make sure to deregister the controller before disabling it to avoid
hanging or leaking resources associated with the queue when the queue
non-empty.

Fixes: 7347a6c7af8d ("spi: octeon: Add ThunderX driver")
Cc: stable@vger.kernel.org	# 4.9
Cc: Jan Glauber <jan.glauber@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-10-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cavium-thunderx.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-cavium-thunderx.c
+++ b/drivers/spi/spi-cavium-thunderx.c
@@ -71,7 +71,7 @@ static int thunderx_spi_probe(struct pci
 
 	pci_set_drvdata(pdev, host);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto error;
 
@@ -91,8 +91,14 @@ static void thunderx_spi_remove(struct p
 	if (!p)
 		return;
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	/* Put everything in a known state. */
 	writeq(0, p->register_base + OCTEON_SPI_CFG(p));
+
+	spi_controller_put(host);
 }
 
 static const struct pci_device_id thunderx_spi_pci_id_table[] = {


