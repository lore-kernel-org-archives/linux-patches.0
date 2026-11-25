Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625634;
	b=0O/HHrDBt1h1S1ITz37U5u+4+JSo8/cSL5sv5jHTTkID+OJJOy6yVXmsAT8JfjkiSfbf
	 +KVS7A9vCdRAQJwu5amjGxPWaKbnG4eLaVDASIYatjld7RRjy7v9JyI2rZQi49EV6GOMQ
	 mvSWw+JNOwSLOIZTehCsN6m5JvHeZsSy//WhLXO4+OzCeCAu1Y+CgzBTaHs3RB8uSsofE
	 E6SgdGsO7fyh4GaQxFba5dSqKRustIbNmL9vZOuJBab7C7mLVGv2p++GmoGVLWRmXpppz
	 BNS6UjO346X7geZT3CjsjAQu3X0g6pIz5JFJKzCtDLBRASdYdWPuOEq+JaQCKcE+4yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qy+xbyM8nFM5LAP/zEJeFsr+ph8capYYNsk0FD4NHzI=;
	b=LlKddAu5dWEVhmWizivmamdgOVjaqI7XC96K11zn8VAyHHOVMH8c5CTiT+dS5m6If+4a
	 MNJKgw0OZN1dfVDGgFAP7gCchY/kYmh1KldZ/D33Y7VgFYqmauBBmfTp40TpCpmweBXuA
	 qrFTuksJIW/1T/aueuayLMc2Fc/ijswEcEmAaq75nuVbLtVIf3t2JjPbhcYzM+mOkB27b
	 VTz8ob3W6O9Q6rjPkRjb2G8ehWM0pGcWhsn0gmoiPPjhDFSvnjkQVI9FQQMMJVW7I6Y2k
	 08HExTbmHwO5Ue03DUg2wlRwGbOsFaCGPb7RcfUxagVWzgYG4h13bc8YLYrNf4d28jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eOAUH8Ho;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB69606A323;
	Wed, 25 Nov 2026 16:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eOAUH8Ho
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE851F000C0;
	Wed, 25 Nov 2026 16:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625633;
	bh=Qy+xbyM8nFM5LAP/zEJeFsr+ph8capYYNsk0FD4NHzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOAUH8HoJZsExXMQKkcURAt0hJzNaVQX1JzQ7yZ5Hc+e6MuX9AeW0Wv3Yf5Y241LB
	 QJgFFhzz17939zLSecK75Yn5x1jlMGdeZKwLMardrooShnGv826b8BICmw2ciFcxH2
	 9wTO1nm5H3xWOMeRPrArp48WJfhFSOKhVtUblk4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tapio Reijonen <tapio.reijonen@vaisala.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 581/816] net: dsa: microchip: initialize the IRQ access mutex
Date: Wed, 25 Nov 2026 15:35:29 +0100
Message-ID: <20261125143902.628145572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tapio Reijonen <tapio.reijonen@vaisala.com>

commit ba1dc196502f3435f4ae53ed6745caacf066f83e upstream.

ksz_switch_register() initializes dev_mutex, regmap_mutex, alu_mutex and
vlan_mutex but not lock_irq, which the IRQ chip takes in its bus lock
callbacks on every mask and unmask of a switch interrupt, and the PTP
code takes the same way. The zeroed mutex happens to work on the
uncontended fast path, but with CONFIG_DEBUG_MUTEXES the first lock,
from the IRQ domain mapping during probe, warns:

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  WARNING: kernel/locking/mutex.c:625 at __mutex_lock
  ...
  ksz_irq_domain_map
  irq_domain_associate_locked
  irq_create_mapping_affinity
  ksz_irq_common_setup
  ksz9477_setup
  dsa_register_switch
  ksz_spi_probe

and turns lock debugging off for the rest of the boot.

Initialize it with the other mutexes.

Triggered at every boot of a KSZ9897S over SPI on an i.MX6 SoloX board
with CONFIG_DEBUG_MUTEXES, on v7.4-rc1 and earlier. With this patch the
same board boots with lock debugging enabled and it stays enabled
(debug_locks 1) through two hours of unrelated stress tests.

Fixes: c9cd961c0d43 ("net: dsa: microchip: lan937x: add interrupt support for port phy link")
Cc: stable@vger.kernel.org
Signed-off-by: Tapio Reijonen <tapio.reijonen@vaisala.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261104-ksz-irq-mutex-init-v1-1-e3bb7d9dbd80@vaisala.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -4806,6 +4806,7 @@ int ksz_switch_register(struct ksz_devic
 	mutex_init(&dev->regmap_mutex);
 	mutex_init(&dev->alu_mutex);
 	mutex_init(&dev->vlan_mutex);
+	mutex_init(&dev->lock_irq);
 
 	ret = ksz_switch_detect(dev);
 	if (ret)


