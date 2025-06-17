Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0AC2EF282;
	Tue, 17 Jun 2025 16:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177635; cv=none; b=B3LGLIaSyE+1GJApRRuhCyjXhbLPyXZKMd9H2uca6hersE4p6sfgB4CYqLClWxRvcZZEY9t0USb+HdDmziSMNfmdoH9A07nOS1nqUla+CxoCXFc/qJ40Q+67zuwxT87Qi4N+M/VCkdEN2hqv2jX7ipLqaXPcz8ZoXRNkI4y09UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177635; c=relaxed/simple;
	bh=rkgl8ZT68Az0s6QCrBr280g4SZOqHyINRgsU6w5dCrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8hBoV++NP/V4aGB/KkMxUEqekhPQjM/6YHmtOvT+yr0dSJLwyvsaOOqb+0tsx3QOQY7DWZEFqyN1gDkCt9Z+pHH+LNfpj6+61zXUIVy9Ziepni3/1e0BWPKor4nTW+oSRNJCoKrjuc3L3ixbmJ40lmZOgxcfHtZg5yJk3xp7UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubLG3zOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubLG3zOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E86C4CEE3;
	Tue, 17 Jun 2025 16:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177635;
	bh=rkgl8ZT68Az0s6QCrBr280g4SZOqHyINRgsU6w5dCrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubLG3zOWrot9U/EbrhMrMKf1iDUaP1z027JxnpM49+q+U5IntSwERp9iTpBvuCRV2
	 X4dKs0hyFwr6WA+GdBUzwD6ozB18+cWadlFUfElDuh5NHc3jiXtJKgWWzuyEO/QM+4
	 LKjZJrSFE2zlCfZCGqgbkIzjWesQHYsqUI1XA2t4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <alobakin@pm.me>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 329/780] net: phy: fix up const issues in to_mdio_device() and to_phy_device()
Date: Tue, 17 Jun 2025 17:20:37 +0200
Message-ID: <20250617152504.850752368@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit e9cb929670a1e98b592b30f03f06e9e20110f318 ]

Both to_mdio_device() and to_phy_device() "throw away" the const pointer
attribute passed to them and return a non-const pointer, which generally
is not a good thing overall.  Fix this up by using container_of_const()
which was designed for this very problem.

Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Fixes: 7eab14de73a8 ("mdio, phy: fix -Wshadow warnings triggered by nested container_of()")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2025052246-conduit-glory-8fc9@gregkh
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mdio.h | 5 +----
 include/linux/phy.h  | 5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 3c3deac57894e..e43ff9f980a46 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -45,10 +45,7 @@ struct mdio_device {
 	unsigned int reset_deassert_delay;
 };
 
-static inline struct mdio_device *to_mdio_device(const struct device *dev)
-{
-	return container_of(dev, struct mdio_device, dev);
-}
+#define to_mdio_device(__dev)	container_of_const(__dev, struct mdio_device, dev)
 
 /* struct mdio_driver_common: Common to all MDIO drivers */
 struct mdio_driver_common {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index a2bfae80c4497..bef68f6af99a9 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -744,10 +744,7 @@ struct phy_device {
 #define PHY_F_NO_IRQ		0x80000000
 #define PHY_F_RXC_ALWAYS_ON	0x40000000
 
-static inline struct phy_device *to_phy_device(const struct device *dev)
-{
-	return container_of(to_mdio_device(dev), struct phy_device, mdio);
-}
+#define to_phy_device(__dev)	container_of_const(to_mdio_device(__dev), struct phy_device, mdio)
 
 /**
  * struct phy_tdr_config - Configuration of a TDR raw test
-- 
2.39.5



