Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDBB1A6192;
	Tue, 30 Jul 2024 16:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357126; cv=none; b=YuC0XH21KKK222e+vsGQXpRHrHgO+oB1HA6498TSHR33QSJEFMeCc0KUy53ViT6B97QgfJLKxKv/WoH43ycFRMueKQfyGwOmlqIZ2aPIir3gQBjWeH7lMSmLqjcGpGA44fVpGLqCIhQIhUz9P1KYnXgNqCWH/RysMA/Md1uaZPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357126; c=relaxed/simple;
	bh=LblBgt9YUkWIRuvOHPCGKjELgYPhSkY9Vk1PDlAyMTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUzcQABTNJiV02yCYDfuEmqIY6MdUmJoGtHBlMtgNeGdJoHwlfehHFCIovE79U/WMenWdPz5j7P9uU+ziaIsLHs9GszyzYC3daaJF3c5Bo9hkR4BwXgMptuAg4uyFzhjthyKqgTBo45HXR5jxTinTfxstgMaDxIJGydh0Gi7Ieg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrIbCp/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrIbCp/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C84BC32782;
	Tue, 30 Jul 2024 16:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357126;
	bh=LblBgt9YUkWIRuvOHPCGKjELgYPhSkY9Vk1PDlAyMTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrIbCp/wM9+idIqWv3P4HpYHgVLMqwKzHwOG3YwsjUKaH9MUtexx0T/vjdy8FNuMH
	 kzk33vYsRUOK5+s+867SuYFeM/EfBv3tpu0bmgomhDwQ2dAQtnhznjxy0roN6mO4Xp
	 vGobjefHTSKF7U1LOKvSi8vXJpirGVhXo1ZRTgNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 202/809] net: dsa: ksz_common: Allow only up to two HSR HW offloaded ports for KSZ9477
Date: Tue, 30 Jul 2024 17:41:18 +0200
Message-ID: <20240730151732.587137544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit dcec8d291da8813b5e1c7c0967ae63463a8521f6 ]

The KSZ9477 allows HSR in-HW offloading for any of two selected ports.
This patch adds check if one tries to use more than two ports with
HSR offloading enabled.

The problem is with RedBox configuration (HSR-SAN) - when configuring:
ip link add name hsr0 type hsr slave1 lan1 slave2 lan2 interlink lan3 \
	supervision 45 version 1

The lan1 (port0) and lan2 (port1) are correctly configured as ports, which
can use HSR offloading on ksz9477.

However, when we do already have two bits set in hsr_ports, we need to
return (-ENOTSUPP), so the interlink port (lan3) would be used with
SW based HSR RedBox support.

Otherwise, I do see some strange network behavior, as some HSR frames are
visible on non-HSR network and vice versa.

This causes the switch connected to interlink port (lan3) to drop frames
and no communication is possible.

Moreover, conceptually - the interlink (i.e. HSR-SAN port - lan3/port2)
shall be only supported in software as it is also possible to use ksz9477
with only SW based HSR (i.e. port0/1 -> hsr0 with offloading, port2 ->
HSR-SAN/interlink, port4/5 -> hsr1 with SW based HSR).

Fixes: 5055cccfc2d1 ("net: hsr: Provide RedBox support (HSR-SAN)")
Signed-off-by: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 0580b2fee21c3..baa1eeb9a1b04 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -3917,6 +3917,13 @@ static int ksz_hsr_join(struct dsa_switch *ds, int port, struct net_device *hsr,
 		return -EOPNOTSUPP;
 	}
 
+	/* KSZ9477 can only perform HSR offloading for up to two ports */
+	if (hweight8(dev->hsr_ports) >= 2) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot offload more than two ports - using software HSR");
+		return -EOPNOTSUPP;
+	}
+
 	/* Self MAC address filtering, to avoid frames traversing
 	 * the HSR ring more than once.
 	 */
-- 
2.43.0



