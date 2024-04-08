Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459552DF73;
	Mon,  8 Apr 2024 13:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581498; cv=none; b=OEaOxMLJQEJ6uJJExOrVdw4UdU5yWchLbq70LQOuI8EWdKVqn6i6KhqPscyoIYIouPEMwnrQuQnEkRk0L0Ku3dNGyH+VkShJwzOpWrMbTvv/mK8Sesq0NGuyBhbMTXWNkozsoDTfdb5rOUHQD7vnvjx5AHmuvXVvpztALqGvF6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581498; c=relaxed/simple;
	bh=Ps/gmsruFVGcpRGneaod62Q2RA9L1HI+lQzDcAds2SE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lw4kJukw+wPb6J3on4MWKEMnonJHY0IV2K2ioUxo1G09H6QtZJJ1K+2oV4RnfIYfcZyUzvftfZlB/YJGYkgaOJmgNDOhWlVFvVhIZ9g8vhAqoiwWrijeyqJWZClftj8ribyAznlQi5aEMPwbkClFj4Gtg8XJowHbm2hzZ8mGae4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwovCF+W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwovCF+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89C9C433F1;
	Mon,  8 Apr 2024 13:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581498;
	bh=Ps/gmsruFVGcpRGneaod62Q2RA9L1HI+lQzDcAds2SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwovCF+WtIneJJeXHE14mpG5XKMUInc+3pTvaxdFSutpdXpsoKQN/5bsQMecyiyu2
	 qYEp2DLvUpwgH3ZbG1dCi6Sp18l6kPHANLOQaAofLtfSTZd5e0uGH4DptD0F+jqsic
	 yyIfMh6+MEZkv3K1m02M+IobghdH1+MMr+pA918E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 027/138] r8169: fix issue caused by buggy BIOS on certain boards with RTL8168d
Date: Mon,  8 Apr 2024 14:57:21 +0200
Message-ID: <20240408125257.071479892@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5032,6 +5032,15 @@ static int r8169_mdio_register(struct rt
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


