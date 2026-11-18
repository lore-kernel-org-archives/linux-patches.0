Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057766;
	b=uRuVjyCI0uvSIabvXu62EJc6/Ra6av5JX2JAW4QydAx6Y0RIjelOSCnl3TxdtSKTS7wT
	 H5b4VFgg6mM3naZ7MqnRwdA0zMteKd3Tsh7i4crhrAhxqQpZeb6MBhzPGSydKGnlQACNc
	 bx6u54GSw764soSg1u4IKTqzXjJ8u4kY9DsVe55ZQ+ilJy+svD7prR/6N3BKc8AZQSJZp
	 pLhGncf0//F5f2e8MUGDnmbdu754zNui7sb4OYaUD0c/8TfaMyGPSZAJoWYoUsTkfQwwA
	 75SN8inkiS34VSxEY8m0+LJozALqkss0El1fzEIQk0AW6K9FcHRE+Uub5L0f+nqquWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p6epQWgDsfHuOjs/Co6vxKbYeRqeaug2JlePqTepRY0=;
	b=e8pqbGqdARXMEILaQ2zkIiGl/qILCK6+ipABGt4BCywyXpayHGHSDh5NsTshY9yhibpV
	 qBFfrlhUG4Vf9SChAnGjFN4a/Wa3Ri7xYFkq4crmYqcLTw5fvLUhmGSFPxYUUhcLHPrPh
	 LOvuo5qA4gDkvCMbUlkE/7lRnxp9/41a6HAaSK+gXoEbo2F0sK36cHJi3vclF3htGYlmW
	 vPZ8ex1gFVI993u2EUC/0eHeWFYSHunu3dxP9a/Rmq4v6PuB1fheo7uaYOQY5wDmGDp4T
	 LHY9s6nB2Hq1AIWHkbxU25HMyhPhfxmv3JDVANb5PzriwymdO+SAVgV7YZQltVs8DkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6gYgZ9C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DD1606A31C;
	Thu, 19 Nov 2026 03:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h6gYgZ9C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22811F000C4;
	Thu, 19 Nov 2026 03:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057766;
	bh=p6epQWgDsfHuOjs/Co6vxKbYeRqeaug2JlePqTepRY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h6gYgZ9C5XoZDhvWi8mi5HkgRQPStWFAo8+xWw/Bq2bFyf23ya607zRlDsxCHA9G/
	 NFBpXSO62Jln8Nl+B8mvETj+jUKqL27jaajEexvskKlPvyqKmzEy6tfZuUzaXiWOdM
	 8CUSqBtW7nBADPEXqGWTjgnT6fDzJDRURBcZIN7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 5.10 0246/1848] ata: sata_fsl: Fix use-after-free of host_priv on probe() failure
Date: Wed, 18 Nov 2026 15:38:04 +0100
Message-ID: <20261118145922.255241070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1530,7 +1530,7 @@ static int sata_fsl_probe(struct platfor
 	host_priv->intr_coalescing.attr.mode = S_IRUGO | S_IWUSR;
 	retval = device_create_file(host->dev, &host_priv->intr_coalescing);
 	if (retval)
-		goto error_exit_with_cleanup;
+		goto error_exit_detach;
 
 	host_priv->rx_watermark.show = fsl_sata_rx_watermark_show;
 	host_priv->rx_watermark.store = fsl_sata_rx_watermark_store;
@@ -1540,16 +1540,24 @@ static int sata_fsl_probe(struct platfor
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


