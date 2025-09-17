Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122B336934E;
	Wed, 17 Sep 2025 12:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113604; cv=none; b=Vko1DJeBlwPn/Gz3TktshXegkzZt4UmDpghegIoaf9CjuMkBmCwV/LCmNpxO8eIR1efVB507r0ir7uWoHBfJvNQnhZxe+OqGh8Pl9XyHpEImM7eI+WH5ijxm0887z93tt3t6zujtkkhWVIPTbtdg11h4ISfl+R0TXjy+gmylUFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113604; c=relaxed/simple;
	bh=fhcYskp09z9UZ+y56sGTtjfaxWm9kAyMK11V1JHDzDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lHklkv+5NOuI7x7Y0t2GRwZ4IQO+3eYWh3EP1OTa1vJyQ4eoBr6dehvaaq4/zpL/G59Q5fjS/3/J0wKibhXpBqFj5L+fTxrDqJzWa7iaupOhohIHTc6252uRmNvNkH7p2cojhn7aIcGMtIPDSKyA6hULCY3c1Ha+h9W1ufD6jMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dj9Lhb+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dj9Lhb+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEE1C4CEF0;
	Wed, 17 Sep 2025 12:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113603;
	bh=fhcYskp09z9UZ+y56sGTtjfaxWm9kAyMK11V1JHDzDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dj9Lhb+f658lO14gfgpdaKANxSk5EuXjldIWlF+KemevIRC/gX4fLWlh/SmINLy/0
	 VYbE3aLQaXQfo0eOsp8B7YM8fhn++TWu+N+k/RHXda496ngNoawJNCcIiDWaRKq07u
	 T7j3kci/EBp0ElvcNvKsK073ho8KKAGAF4sh6Wec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Buday Csaba <buday.csaba@prolan.hu>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 138/140] net: mdiobus: release reset_gpio in mdiobus_unregister_device()
Date: Wed, 17 Sep 2025 14:35:10 +0200
Message-ID: <20250917123347.691660014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Buday Csaba <buday.csaba@prolan.hu>

commit 8ea25274ebaf2f6be8be374633b2ed8348ec0e70 upstream.

reset_gpio is claimed in mdiobus_register_device(), but it is not
released in mdiobus_unregister_device(). It is instead only
released when the whole MDIO bus is unregistered.
When a device uses the reset_gpio property, it becomes impossible
to unregister it and register it again, because the GPIO remains
claimed.
This patch resolves that issue.

Fixes: bafbdd527d56 ("phylib: Add device reset GPIO support") # see notes
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Cc: Csókás Bence <csokas.bence@prolan.hu>
[ csokas.bence: Resolve rebase conflict and clarify msg ]
Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Link: https://patch.msgid.link/20250807135449.254254-2-csokas.bence@prolan.hu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ csokas.bence: Use the v1 patch on top of 6.12, as specified in notes ]
Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio_bus.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -97,6 +97,7 @@ int mdiobus_unregister_device(struct mdi
 	if (mdiodev->bus->mdio_map[mdiodev->addr] != mdiodev)
 		return -EINVAL;
 
+	gpiod_put(mdiodev->reset_gpio);
 	reset_control_put(mdiodev->reset_ctrl);
 
 	mdiodev->bus->mdio_map[mdiodev->addr] = NULL;
@@ -814,9 +815,6 @@ void mdiobus_unregister(struct mii_bus *
 		if (!mdiodev)
 			continue;
 
-		if (mdiodev->reset_gpio)
-			gpiod_put(mdiodev->reset_gpio);
-
 		mdiodev->device_remove(mdiodev);
 		mdiodev->device_free(mdiodev);
 	}


