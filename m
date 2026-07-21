Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8FF3C276E;
	Tue, 21 Jul 2026 17:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655020; cv=none; b=hpEDbJ+SS338K0H8n18yYmxi1scLAtepDcHHu2rGjLOm+6EDOaw3r6siBZQf9d0KqctN4fmmUSLvi3UuXfGO/zwVlgxduVPL3Pb2MbXyAkmojQE3zl6NujD/R5yWbaKvV2qW4sPZa24Tj43VcJk1UXNDvk3MdPc83HAh12C6TA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655020; c=relaxed/simple;
	bh=k9Sza0tJSCh0fRrn0XXA4px34n3fonImVcV70gT/dZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lowsmUuL0h+7BGN/9HeP2Fj3kdsmJSJi6lye3mwZGTkYHOzGylsFX+FSg2ab6M5tXrmNo7wSE6v7U9PQ5H6cdxqD209+KrlmA07N89P2SIerNNOJoIaNmAOjoSr7LaY5bRQRbGL9Hf2Xy83ZikhFpgt3UfwGGFs/9gwms1Hdk54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/HK0TB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/HK0TB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284841F000E9;
	Tue, 21 Jul 2026 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655018;
	bh=UQDhGTlwEJYFY8D/HSYm4kKNoMaPOa7Qa1XxTcUs2e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/HK0TB4mfjDHX5+ZMJbqdCDTsNVV4x+tDr7dtLYv1WmHf1u8lXeasZAhFZsqTYII
	 btkFZnU4bUP0YkxMFQhvCEgqWtPoXMpR8RJMIExMyN0piZXirBUnu/PNf5/xARTcCi
	 LaA/h63ndicgwxpFZti+/SzNsy7sFiSTiSAtxnUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 7.1 1924/2077] ieee802154: ca8210: fix cas_ctl leak on spi_async failure
Date: Tue, 21 Jul 2026 17:26:37 +0200
Message-ID: <20260721152638.092700106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shitalkumar Gandhi <shital.gandhi45@gmail.com>

commit e09390e439bd7cca30dd10893b1f64802961667a upstream.

ca8210_spi_transfer() allocates cas_ctl with kzalloc_obj(GFP_ATOMIC)
and relies entirely on the SPI completion callback
ca8210_spi_transfer_complete() to free it.

The spi_async() API only invokes the completion callback on successful
submission.  On failure it returns a negative error code without ever
queuing the callback, which leaves cas_ctl and its embedded spi_message
and spi_transfer orphaned.  Every kfree(cas_ctl) in the driver is
inside the completion callback, so there is no other reclamation path.

ca8210_spi_transfer() is called from ca8210_spi_exchange(), the
interrupt handler ca8210_interrupt_handler(), and from the retry path
inside the completion callback itself.  The exchange and interrupt
handler paths loop on -EBUSY, so under sustained SPI bus contention
every retry iteration leaks a fresh cas_ctl (~600 bytes per
occurrence).

Fix it by freeing cas_ctl on the spi_async() error path.  While here,
correct the misleading error string: the function calls spi_async(),
not spi_sync().

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Shitalkumar Gandhi <shitalkumar.gandhi@cambiumnetworks.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/20260421073259.2259783-1-shitalkumar.gandhi@cambiumnetworks.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ieee802154/ca8210.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -919,9 +919,10 @@ static int ca8210_spi_transfer(
 	if (status < 0) {
 		dev_crit(
 			&spi->dev,
-			"status %d from spi_sync in write\n",
+			"status %d from spi_async in write\n",
 			status
 		);
+		kfree(cas_ctl);
 	}
 
 	return status;


