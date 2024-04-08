Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CDB7F470;
	Mon,  8 Apr 2024 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585066; cv=none; b=JngQMwnNAgOmcx0cdhT5IYp19YtkgrFq195mXQsuc1kV2feiZ/2F5S4yN0OhdiiRzClOAC3HTeXnM3LK/WMyEqbHFX/iLKrbq0rgOezyCKcCCBoXMyPua36qzzVcNgHw2bAmjnBaJ8l8NESGQ3ZFBbKMKWAQk47oPcMc5lD/0nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585066; c=relaxed/simple;
	bh=t5Ulj0ZV1Wiv8wC9CsfaBdXRKvT2FObOiH5kNBhP48E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUP41auJLoYd7P+WG0ohWz3ZnRJA2O03eqZ6UlOHJTYR6HLC7j1LJ4664QZbC6+RBozaPbxaWDnPMhDFk+qeFZC4dkyeXu8d1/oiXDgxE8+oACljw5IxYtu0CJcbVoX70xwm4K+teNJfld/9wwZyz3R+j5tFkq5vpqvqWmfIVoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11HPadh6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11HPadh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C7FC433C7;
	Mon,  8 Apr 2024 14:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585066;
	bh=t5Ulj0ZV1Wiv8wC9CsfaBdXRKvT2FObOiH5kNBhP48E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11HPadh6Cuv6lHOjnAdYc7WoeO7V9wFIOdkcNpkrNDDT/0rzJTLnpiU3uWidEn1FS
	 +8cB+Igcz9jrwArxbYCe1u9h9zmgRuh2tpe6rym7I3e/ZF+dFqdtDi8HS5ZUVHE2aW
	 kB/OpMH2Q97Nq/sfqwP9d/dnWTMGfCRA6MxB+lek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 621/690] r8169: fix issue caused by buggy BIOS on certain boards with RTL8168d
Date: Mon,  8 Apr 2024 14:58:07 +0200
Message-ID: <20240408125422.134585414@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 5d872c9f46bd2ea3524af3c2420a364a13667135 upstream.

On some boards with this chip version the BIOS is buggy and misses
to reset the PHY page selector. This results in the PHY ID read
accessing registers on a different page, returning a more or
less random value. Fix this by resetting the page selector first.

Fixes: f1e911d5d0df ("r8169: add basic phylib support")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/64f2055e-98b8-45ec-8568-665e3d54d4e6@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5138,6 +5138,15 @@ static int r8169_mdio_register(struct rt
 	struct mii_bus *new_bus;
 	int ret;
 
+	/* On some boards with this chip version the BIOS is buggy and misses
+	 * to reset the PHY page selector. This results in the PHY ID read
+	 * accessing registers on a different page, returning a more or
+	 * less random value. Fix this by resetting the page selector first.
+	 */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_25 ||
+	    tp->mac_version == RTL_GIGA_MAC_VER_26)
+		r8169_mdio_write(tp, 0x1f, 0);
+
 	new_bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!new_bus)
 		return -ENOMEM;


