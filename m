Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8776D25C6ED;
	Tue, 11 Mar 2025 15:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706817; cv=none; b=e7+Q+EUJAJQXZatNevkyO+YnlFJaGTEtMZ5X2cczL5h1EvTKJZdOELuvtfauFwUDB5LvsvTAHXETRKLxkkLRsg8AB5eEErvwXKUYAJZvZhdbt10JHSpgTxRGpxlzbyIwZWLI0LMbYtIFQ6ISCEEoShx7Qiv2p+7o9fnUdENXnbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706817; c=relaxed/simple;
	bh=k3YqGFK91idIIqVFnqiYp8oAl7LaE4Ro/Xi4puZ1NVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gks6zmUp3hnxz2Kl888c3gECIzRe1xjULuRcmhCdpZpvBCoz173qS5NPm2TRshjl6TzwY48WDVP5U8YMeHCYQ/Pk1DRshjuC+WJ7FDfie/Bjwu+hWh4iECrm/Dc3A7q+qaoowgLJHHi7w1NWWQmjFckiYGsJP16nuRy7g9DIn4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EScrAbGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EScrAbGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9D9C4CEEA;
	Tue, 11 Mar 2025 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706817;
	bh=k3YqGFK91idIIqVFnqiYp8oAl7LaE4Ro/Xi4puZ1NVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EScrAbGGqPFjKBoWcS24ec7Oht1tErl8AX1J0nYL6ietQ33sK/psGtw1fURGUBC5l
	 90fAnUYusn/t9SI3Wj2wL6m499iKeV0Tnq0sEwQtsrL9NywH7qdtDNip2ZeEOR331p
	 PwcG8xLO5XUYuMvnhqBNO8oANcRoGX5w5BHoY/eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Renner Berthing <kernel@esmil.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/462] net: usb: rtl8150: use new tasklet API
Date: Tue, 11 Mar 2025 15:56:53 +0100
Message-ID: <20250311145804.159421665@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Renner Berthing <kernel@esmil.dk>

[ Upstream commit 1999ad32d4ff00581007543adffc465694b2e77b ]

This converts the driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 90b7f2961798 ("net: usb: rtl8150: enable basic endpoint checking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index d128b4ac7c9f0..c7137fa9eb269 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -577,9 +577,9 @@ static void free_skb_pool(rtl8150_t *dev)
 		dev_kfree_skb(dev->rx_skb_pool[i]);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
-	struct rtl8150 *dev = (struct rtl8150 *)data;
+	struct rtl8150 *dev = from_tasklet(dev, t, tl);
 	struct sk_buff *skb;
 	int status;
 
@@ -879,7 +879,7 @@ static int rtl8150_probe(struct usb_interface *intf,
 		return -ENOMEM;
 	}
 
-	tasklet_init(&dev->tl, rx_fixup, (unsigned long)dev);
+	tasklet_setup(&dev->tl, rx_fixup);
 	spin_lock_init(&dev->rx_pool_lock);
 
 	dev->udev = udev;
-- 
2.39.5



