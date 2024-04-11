Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D8D146D6D;
	Thu, 11 Apr 2024 10:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830833; cv=none; b=XY/IRVDn+5lx4OlgioX/p+ZF+6qfkjmUYgyqOE8SG+Ctyn+u+hSxDl/g8+8svnCGbyialIc1almTudHYQkk3olOXd22KQdJCpgI6m9Kh0lFqUtZpXP1Yw0BVP2zL0JKk68CJw8qYCjNJ3DnVmaAHGSAgTp78rMk578HmqYYr66s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830833; c=relaxed/simple;
	bh=O+ZpGbcUsL5k1tY82kQeyJ/8hDFW0mJaKbydmzB+oVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuD+t0ELDY/TO5OdeQnHCbOBlR0mskRg9PGRbwkTXqeCIJOmmqhnSsns1hzrTexifIykK/2GwBI1hwEQz/TcMAq0j8tqYfXxuUwzU73aAtmCveWxyojMlKGvB2L40pmdT05y2ssXP0qW94nSvoUNeHXoEeyH1ha1hvxjTUAqvZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aclmPF82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aclmPF82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99105C43394;
	Thu, 11 Apr 2024 10:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830833;
	bh=O+ZpGbcUsL5k1tY82kQeyJ/8hDFW0mJaKbydmzB+oVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aclmPF82w4FaHPjp1sx2fthgMw4aYW66QRGHhm62NuKLktVAjy2T21WgciR1Bzr8G
	 BSTlhjCAZ+/WPkij7ToE9jT+4+rO4hhRVzgwK6XSeiH7EdYhzmSlIguzZE18Zv0iQf
	 I+g2FfjRTgE0/1bpbFamZP3h99OEodadvDOwpLVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 133/215] r8169: fix issue caused by buggy BIOS on certain boards with RTL8168d
Date: Thu, 11 Apr 2024 11:55:42 +0200
Message-ID: <20240411095428.893228603@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6851,6 +6851,15 @@ static int r8169_mdio_register(struct rt
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


