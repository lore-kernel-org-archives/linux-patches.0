Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB003FA5D9;
	Tue, 31 Mar 2026 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974995; cv=none; b=NFnSgkPQoHNS+F4CvC228aONFzUmzIDkN2OstvawHZ4PJqNZloyQtZfTUmUtpdjasQz+1oa9CgsyCwIWqlubaebpAJQs+jIQ4hZ6Zx5iI0rAKoJ+pZeG6vu1PUZ8T0mRn90tQciyy7//7wII2+7XaMEkapd8Zdt4emWczcmKSxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974995; c=relaxed/simple;
	bh=cn8nTwxjc5acMfAtKIf0Tdwu+UMulZ7AQx/yVRb2Y/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLetgsD4antzIziIoUcSKvWBsxwJgo9GDz+vYPBkHUyqB699Fv5NRxw0c/W088M7JWZMC5hwcQZ//JUAniorXOC5AO+fjr912Y9gxtujh+RNBxRwOgWcO1MopPwUdRHHP38EqRPhJBbbJKYXePk3gMivqk7DRG+87PhU0TkMICE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUUi/r3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUUi/r3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BEEC19423;
	Tue, 31 Mar 2026 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974995;
	bh=cn8nTwxjc5acMfAtKIf0Tdwu+UMulZ7AQx/yVRb2Y/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUUi/r3GJaiFMRbG9AzkZCycCbTXxFTBYJtLCTJi9oHOQdFDa/sG2v2P0ia+7J4nb
	 mItDKXaENxqplVUoRIzhbYA1Ghxi4FT4s4RmQmNt8Y/20pWUGyuPA6EDfPe9uf9KpN
	 6RKoVbEXe+UqR8XZw97ObdpwiqWHjZyGG917Aw74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 122/342] net: b44: always select CONFIG_FIXED_PHY
Date: Tue, 31 Mar 2026 18:19:15 +0200
Message-ID: <20260331161803.497848841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 3f0f591b44b04a77ff561676ae53fcfd7532a54c ]

When CONFIG_FIXED_PHY=m but CONFIG_B44=y, the kernel fails to link:

ld.lld: error: undefined symbol: fixed_phy_unregister
>>> referenced by b44.c
>>>               drivers/net/ethernet/broadcom/b44.o:(b44_remove_one) in archive vmlinux.a

ld.lld: error: undefined symbol: fixed_phy_register_100fd
>>> referenced by b44.c
>>>               drivers/net/ethernet/broadcom/b44.o:(b44_register_phy_one) in archive vmlinux.a

The fixed phy support is small enough that just always enabling it
for b44 is the simplest solution, and it avoids adding ugly #ifdef
checks.

Fixes: 10d2f15afba2 ("net: b44: register a fixed phy using fixed_phy_register_100fd if needed")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260320154927.674555-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index cd7dddeb91dd6..9787c1857e13b 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -25,7 +25,7 @@ config B44
 	select SSB
 	select MII
 	select PHYLIB
-	select FIXED_PHY if BCM47XX
+	select FIXED_PHY
 	help
 	  If you have a network (Ethernet) controller of this type, say Y
 	  or M here.
-- 
2.51.0



