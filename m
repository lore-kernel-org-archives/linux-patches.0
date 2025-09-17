Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F98F32E731;
	Wed, 17 Sep 2025 12:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113941; cv=none; b=hsjsUoGSLVYxpRrs8JT58PdnCROpOo4f3DwO/6yenQYhB0K0T3BP9zFO3dVgtQ3aTudn+zkUvYwnEQ+mVZEN29xEZKfLacXY3UGoEvrT2QXAGeZdNalJUmWK2o9Ne4uI0412BxhxZyqr5jjB7IIZ4Adja4CatLsyUZDfn0BHYEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113941; c=relaxed/simple;
	bh=lvxTkHGz+oj5xft//XOR+kusE+FfSOPH2CIXsEYfjc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9Oj7vlq+hfCoDY6xfN8vfqJTPVDJPNsTWbtBATJ3aqlIhSRmGVWA2vSMhpzD7czNVdkKfxHQ2G56nuQEiCSyq/L58Q9yDga80gMzWCfADG9Q+FKE6J61kn5TlAGTSjS0UkMpmvmsKAmcANH9wrEIbaAt2aJ3Pvfxg2q7HbKKPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aITjZHNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aITjZHNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8EBC4CEF0;
	Wed, 17 Sep 2025 12:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113941;
	bh=lvxTkHGz+oj5xft//XOR+kusE+FfSOPH2CIXsEYfjc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aITjZHNgGBV/jpPChHShLih5tSuSt1GFNoWeHGgzbcHHvQeoDs33urxRPhaqlX9+w
	 dFAKadccakt/A1jJ/5wQ/fnSi3cKQRLt0E7PMtH1Z74EfZXuBYRbvUdtPVX0nnS/24
	 sf8zpW/k/aDEN6TA6f21LRzcl7jOtCFP6RXEJeaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Buday Csaba <buday.csaba@prolan.hu>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 099/101] net: mdiobus: release reset_gpio in mdiobus_unregister_device()
Date: Wed, 17 Sep 2025 14:35:22 +0200
Message-ID: <20250917123339.223063178@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ csokas.bence: Use the v1 patch on top of 6.6, as specified in notes ]
Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio_bus.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -99,6 +99,7 @@ int mdiobus_unregister_device(struct mdi
 	if (mdiodev->bus->mdio_map[mdiodev->addr] != mdiodev)
 		return -EINVAL;
 
+	gpiod_put(mdiodev->reset_gpio);
 	reset_control_put(mdiodev->reset_ctrl);
 
 	mdiodev->bus->mdio_map[mdiodev->addr] = NULL;
@@ -775,9 +776,6 @@ void mdiobus_unregister(struct mii_bus *
 		if (!mdiodev)
 			continue;
 
-		if (mdiodev->reset_gpio)
-			gpiod_put(mdiodev->reset_gpio);
-
 		mdiodev->device_remove(mdiodev);
 		mdiodev->device_free(mdiodev);
 	}


