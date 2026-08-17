Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB0D64AA4;
	Mon, 17 Aug 2026 15:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980165; cv=none; b=tF3TQlbQ7G4Z1VUO9WWxeFYB9/gKUBcVyi8gymvusxfYRKIwY0KA/hwG5qmUTLJxFy73UoFVpTWYM7UNRGxyRzn3tjYB5vog8Z0863avbjkmFwizCNHTUCfh0LwwIo0S550IZyXhNHLfKuSZcLoVQq3GErCxyHEIdLYDtTWoEuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980165; c=relaxed/simple;
	bh=IgiP/RnrP55b4coSOt8TVVXp0RPOHDC8GumyJ8dqdL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GdoX6IiuZ0MoCFadNYJHmYuSs/ZJf3bKBAtxs5rX4pRiL2ykIbytqHk8p36lQUXOXzuD5yfVW2J5k8l0Y34PvoM1pBSkBt9RaOQegN1V8EGfWQO/mxNe8+Pl9ICIjUM+rh5SzpkQLnoAC5FXt7g9Dky76AaahOgwvNCE9BwRcQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQkSHyLX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQkSHyLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770B21F000E9;
	Mon, 17 Aug 2026 15:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980164;
	bh=kQyIYXss/JZE4LTEHQrNHSUwi9ssOYrQ930BRQkCRO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQkSHyLX2iZMGx4KZf/+MbJqmpvpsCdn6F1EhWCGQzfhav7M16O6O1dRWY9ImIZ7m
	 zxA3gaCKzTwH4q83WCiQaBo1A2IMpAGeq3h+aWiFi69Vbo93GoLHky11pe4wGEvSj3
	 gwHaMPy8EWNsqCD8JZAsKvqiI9P/fvbKP6iLSdoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.1 477/609] ata: ahci: Make ahci_ignore_port() handle empty mask_port_map
Date: Mon, 17 Aug 2026 15:32:53 +0200
Message-ID: <20260817132559.913838275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 130ff5c8b78e6fd05270a04985c50bce6a3de6c1 upstream.

Commit 8c87215dd3a2 ("ata: libahci_platform: support non-consecutive port
numbers") added a skip to ahci_platform_enable_phys() for ports that are
not in mask_port_map.

The code in ahci_platform_get_resources(), will currently set mask_port_map
for each child "port" node it finds in the device tree.

However, device trees that do not have any child "port" nodes will not have
mask_port_map set, and for non-device tree platforms mask_port_map will
only exist as a quirk for specific PCI device + vendor IDs, or as a kernel
module parameter, but will not be set by default.

Therefore, the common thing is that mask_port_map is only set if you do not
want to use all ports (as defined by Offset 0Ch: PI – Ports Implemented
register), but instead only want to use the ports in mask_port_map. If
mask_port_map is not set, all ports are available.

Thus, ahci_ignore_port() must be able to handle an empty mask_port_map.

Fixes: 8c87215dd3a2 ("ata: libahci_platform: support non-consecutive port numbers")
Fixes: 2c202e6c4f4d ("ata: libahci_platform: Do not set mask_port_map when not needed")
Fixes: c9b5be909e65 ("ahci: Introduce ahci_ignore_port() helper")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/linux-ide/10b31dd0-d0bb-4f76-9305-2195c3e17670@samsung.com/
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Co-developed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250225141612.942170-2-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.h    |    8 ++++++--
 drivers/ata/libahci.c |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -388,8 +388,12 @@ struct ahci_host_priv {
 static inline bool ahci_ignore_port(struct ahci_host_priv *hpriv,
 				    unsigned int portid)
 {
-	return portid >= hpriv->nports ||
-		!(hpriv->mask_port_map & (1 << portid));
+	if (portid >= hpriv->nports)
+		return true;
+	/* mask_port_map not set means that all ports are available */
+	if (!hpriv->mask_port_map)
+		return false;
+	return !(hpriv->mask_port_map & (1 << portid));
 }
 
 extern int ahci_ignore_sss;
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -539,6 +539,7 @@ void ahci_save_initial_config(struct dev
 		hpriv->saved_port_map = port_map;
 	}
 
+	/* mask_port_map not set means that all ports are available */
 	if (hpriv->mask_port_map) {
 		dev_warn(dev, "masking port_map 0x%lx -> 0x%lx\n",
 			port_map,


