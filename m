Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061530;
	b=Wo/cLmiVRng8mSTrahaugi+lhoCfzgJcLL1o5GeSHibrGh5w8mp+zIdQu6NklPuqdSI3
	 8hJSQL/hpuLkNbwmCu6Dj4aRCJydeYQCi0WrzRJVSdWGuw9UpidcumC+1UKtSS35KbojA
	 lLPdRdh1RvG9vu36fSLb8U+kugKAzl8pZ9B3g11oT23UIq5Fhc2JfanLK5ZvSvmrPmBd7
	 0AMx9jNjE/G+WPTmKTD9xETmNKXIt82cuhL9FIBCjxqzZ2QKFGLigthShBg7ouy7lCraa
	 DO/kMYOeuLBlviPmWsQUG6UFZGuQRO6+Vgt1XZCRu91JycEjJgvopmZBTu3rLCSofZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cSnWznrahvOR9P3XBDPYQ7rxX6qlob7BBmu+vT0ZFOs=;
	b=fTkwG+TcLB/xJ507Erir+MgVo4PyQEQx8h7x+HRgKESShidJ0cICRd+Z+mzdOxOZ695m
	 GqRn/YdF0wJJAlYiKFNX7oA5IqcRnBiAc5eOh/DR89bQUx7p9HMAm0CNf7z4jSnpZ1bOC
	 Nj2mm40gx26o+AoZGoKxf9RS6qdUDpB2EaVs9bZdqj7qbw6LhQCc/lZ8XGtEFTXi6iBJh
	 m4pe2AsA3ESPZHZ3H335HI/J6e8KfBQdN+YC3NEJkRH69ReAvuCgsO9tT6XKhNTGJctOX
	 oYmhe/fzhaxzkAgsa1qVPdyg0TwUF/MmtZGvXRh9hXtztm1R1y7k0ttdWj4N9fHy40g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAiaKltD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD59606A32D;
	Sat,  7 Nov 2026 14:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAiaKltD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396D11F0089F;
	Sat,  7 Nov 2026 14:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061530;
	bh=cSnWznrahvOR9P3XBDPYQ7rxX6qlob7BBmu+vT0ZFOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAiaKltDP3KZWjsaOqmElSMF64Xp7W6vgQyX2wKvKDDmF16t8PnrzgjEIisA3+9i6
	 L3ulRKjzVTM3fyOVBLDT/Sr2wUlI/U7QRLs4kLgjEN5uGMrNsNnhYwArQP0ZWJBp14
	 5GMYU5+XvrBUXKAESCXXUZS1hWyqjiUieE5o/KMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 0616/1536] ata: sata_fsl: Fix use-after-free of host_priv on probe() failure
Date: Sat,  7 Nov 2026 08:43:52 -0500
Message-ID: <20261107135014.837313161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 70b1196740d61aabda13b2ad0e9c1dfa2ef9cfa3 upstream.

sata_fsl_host_stop() releases hcr_base and host_priv:

	static void sata_fsl_host_stop(struct ata_host *host)
	{
		struct sata_fsl_host_priv *host_priv = host->private_data;

		iounmap(host_priv->hcr_base);
		kfree(host_priv);
	}

->host_stop() is called by the driver core through the ata_host_stop()
devres action which ata_host_start() registers, so it is called both when
the device is unbound and when probe() fails after the host has been
started.

The error_exit_with_cleanup label of sata_fsl_probe() releases hcr_base
and host_priv as well, and it is reachable from the two
device_create_file() calls which are done after the host has been
activated. In that case sata_fsl_host_stop() runs on an already freed
host_priv, resulting in a use-after-free and a double iounmap()/kfree().

Add a separate error label for the failures happening after the host has
been activated, which only detaches the host and leaves hcr_base and
host_priv to sata_fsl_host_stop().

Note that ata_host_detach() is dropped from error_exit_with_cleanup, as
that label is now only reachable while host is still NULL.

Fixes: 6c8ad7e8cf29 ("sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20260915084127.692494-11-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/sata_fsl.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1499,7 +1499,7 @@ static int sata_fsl_probe(struct platfor
 	host_priv->intr_coalescing.attr.mode = S_IRUGO | S_IWUSR;
 	retval = device_create_file(host->dev, &host_priv->intr_coalescing);
 	if (retval)
-		goto error_exit_with_cleanup;
+		goto error_exit_detach;
 
 	host_priv->rx_watermark.show = fsl_sata_rx_watermark_show;
 	host_priv->rx_watermark.store = fsl_sata_rx_watermark_store;
@@ -1509,16 +1509,24 @@ static int sata_fsl_probe(struct platfor
 	retval = device_create_file(host->dev, &host_priv->rx_watermark);
 	if (retval) {
 		device_remove_file(&ofdev->dev, &host_priv->intr_coalescing);
-		goto error_exit_with_cleanup;
+		goto error_exit_detach;
 	}
 
 	return 0;
 
-error_exit_with_cleanup:
+error_exit_detach:
+	/*
+	 * Once the host has been activated, hcr_base and host_priv are
+	 * released by sata_fsl_host_stop(), which is called by the driver core
+	 * through the ata_host_stop() devres action registered by
+	 * ata_host_start(). Releasing them here as well would result in a
+	 * double iounmap() and a use-after-free.
+	 */
+	ata_host_detach(host);
 
-	if (host)
-		ata_host_detach(host);
+	return retval;
 
+error_exit_with_cleanup:
 	if (hcr_base)
 		iounmap(hcr_base);
 	kfree(host_priv);


