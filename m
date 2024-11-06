Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6939A1EBFF3;
	Wed,  6 Nov 2024 13:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898763; cv=none; b=Sg4pnkHBLvGcyDmo2Ww+kbe2TqsaMPwNk4zfFLsEB1RaTMDD7fTLLG6H6vA9MbgTKPTUL+vjsm+SDS8Y032z6bRwj9tFT6eFYQV5+gZ/xJFjWGIoeg1+krTL6R/gox+K4xzGV36GDEtZ3DIuotXhFNyW4+aiG7BwlpijaBImEjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898763; c=relaxed/simple;
	bh=PB2ESyfrx+u34zowbOv21uM18QwRLLo47Vwqocjs+C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSl1bsW9bOi0tdJ+xLv8nbDOcHFH8sq0UscCv/xxlLXN4EH0Bu2sCkVCS1JrhG58L0khLFiGl5OZ7LFdkILB3zCGUXup1qoZdnswZUzM+5NJeZbhR3imcVvNeS8/BTgmZ9+fJtPrhdwM6pHmWGD/pqP/+sP9AJSffOxJCLAz//Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FviDlbSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FviDlbSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D0AC4CECD;
	Wed,  6 Nov 2024 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898763;
	bh=PB2ESyfrx+u34zowbOv21uM18QwRLLo47Vwqocjs+C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FviDlbSO71Qad3iV2KREAHZhn3aGfGdDADVy6mBMGZHeWxV7Rs2ExjwwWyyWfN76u
	 CJ2KLCfS/HiDr8SeEk6h4sPJjTGsu+/+ul+D7KFPM0TaBjSF2aqscKULQbir9B5I8f
	 pg8REbq7DutcEo4BTHoMPs/ORXyquKpORjvjq0oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 311/462] i2c: i801: Use a different adapter-name for IDF adapters
Date: Wed,  6 Nov 2024 13:03:24 +0100
Message-ID: <20241106120339.207126503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 43457ada98c824f310adb7bd96bd5f2fcd9a3279 ]

On chipsets with a second 'Integrated Device Function' SMBus controller use
a different adapter-name for the second IDF adapter.

This allows platform glue code which is looking for the primary i801
adapter to manually instantiate i2c_clients on to differentiate
between the 2.

This allows such code to find the primary i801 adapter by name, without
needing to duplicate the PCI-ids to feature-flags mapping from i2c-i801.c.

Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 2c077ffcee607..6b960cbd045bc 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1861,8 +1861,15 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 
 	i801_add_tco(priv);
 
+	/*
+	 * adapter.name is used by platform code to find the main I801 adapter
+	 * to instantiante i2c_clients, do not change.
+	 */
 	snprintf(priv->adapter.name, sizeof(priv->adapter.name),
-		"SMBus I801 adapter at %04lx", priv->smba);
+		 "SMBus %s adapter at %04lx",
+		 (priv->features & FEATURE_IDF) ? "I801 IDF" : "I801",
+		 priv->smba);
+
 	err = i2c_add_adapter(&priv->adapter);
 	if (err) {
 		platform_device_unregister(priv->tco_pdev);
-- 
2.43.0



