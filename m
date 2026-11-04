Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827056;
	b=kO3WhU2meKJ4j+aGg5lSDb8VJDNkqHb3bvZc9xITQlt2B+LRBVu9cnDb66kqVgeAieTC
	 C1qoHAkps2B+jHhw0FajN/iPSwfNTXK9Vo4I2I8YuWbkE/Fgq12JnacvYTrJ2wGk9cl6J
	 S1mcj2e4dG2wpr07K9k24RjbchEiR4ghI2bzkZUwZAhaRnWaSv1PTmrqW9MXgWLcdLwsG
	 SKQi8/q0g11LOvE4iEkLvb5xMKZR3gJIpeiTD/SSzOcy6nn1zJpTX4Kh+SFW7s4X9NsH9
	 fU/meZ1oSJmxzEHcU6HOYsOQRIQ/bHIN6foVlIw2FlEMC5naIbKdVwFcuDnN763zcqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qDBdW8vdf47M3Ce4Xpk6V9uJoHb1mdrgZz5QEJguZsM=;
	b=NxrUKYjOYFtAffKbU7aPVGeflvHNwiOgOVMKa3qjwFwoZZz2cz0S6DN6PYi8MV/n+SRq
	 +1HCitc1SJSzEKBxd1dajF0+dnOcfYSDfomgzUWqlGsJ8mHsjIXcJLumFUVXV1rRcN3Kd
	 AqVbFKwv+Id/HA0PmIOJpEibPtx++84R/V/bvVI8Id6zzgXUNASJxKzogJoSzg2OeVUnf
	 Kyv+kFGSPZnjGT26dLmPWnpHTMwS5rX8nvJ5bEAKIFaG2ul6+b0BTVfNGTMTmcqxK+hu7
	 hCx7IaGCWlGmjgD/LyQ9BDKct+dp+2lwpPJzORQau9ZzYrpoeX3pxMidga7DbCMpjDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="v/OrcNWj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1D3606AE22;
	Wed,  4 Nov 2026 21:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v/OrcNWj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C881F000C1;
	Wed,  4 Nov 2026 21:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827056;
	bh=qDBdW8vdf47M3Ce4Xpk6V9uJoHb1mdrgZz5QEJguZsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/OrcNWjSHutDTbpiQApk8RkezkS47ctQO3lb9Dp70ZXZzEgl1oR7G8NnnkwOYlG1
	 ALl6EjI0eyXEtL/2gKh/XLxNunMSIX7G4G1YufNmRjemL0I+gPG9VPRz9M4B7qqWV8
	 grxkAKrY7yfdUB2ehn+p6ycy2cM4Zy+VEVNdw0ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 7.3 167/547] ata: sata_fsl: Fix use-after-free of host_priv on probe() failure
Date: Wed,  4 Nov 2026 16:05:51 -0500
Message-ID: <20261104211042.894982821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1500,7 +1500,7 @@ static int sata_fsl_probe(struct platfor
 	host_priv->intr_coalescing.attr.mode = S_IRUGO | S_IWUSR;
 	retval = device_create_file(host->dev, &host_priv->intr_coalescing);
 	if (retval)
-		goto error_exit_with_cleanup;
+		goto error_exit_detach;
 
 	host_priv->rx_watermark.show = fsl_sata_rx_watermark_show;
 	host_priv->rx_watermark.store = fsl_sata_rx_watermark_store;
@@ -1510,16 +1510,24 @@ static int sata_fsl_probe(struct platfor
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


