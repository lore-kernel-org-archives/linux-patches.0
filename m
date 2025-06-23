Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAB61F5820;
	Mon, 23 Jun 2025 21:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714392; cv=none; b=G9HNlp16CY2LUv7Kvk6GthJBmw6J37HYNCo2BII155v9vwCMm53vphIGLdjrbE3Jx5E9XBZJhTFDNY6aQ9hgoE3wN7cew/brLUdohfU0b4mRIy5Byhn3Z7bp4dqWrNGxgSpENCeEMr6Nitwi2/Q216ZHq8wl5NZFEw+eFWNNqe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714392; c=relaxed/simple;
	bh=wNuQs3lZfWKjHhD/lEfGSYIKV2w6br707vfXKws+rDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lTjt9LtZJ6ViRIelnTxMHSPwqwJ+GWM+sKtGVwckaK7Lg08a8kCXSHIUOPtXTl3JJsEzY3Kn2vNKDbBJvedKtwC1tJsf733YB8lcdU9KbAAfJcoShCTYsOVS+XNQe7vRTvN2immz27AeuEVDDdAkBWSSHPYUuuZNfHDzfsL64Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyOW6Hiu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyOW6Hiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0BDC4CEEA;
	Mon, 23 Jun 2025 21:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714392;
	bh=wNuQs3lZfWKjHhD/lEfGSYIKV2w6br707vfXKws+rDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyOW6HiuCVT7aVGMNlwYI9bV9id+yf790SO1L/N/xPRRqTH3EIcD3pooAguweI2uo
	 Xc/iJ7Gi5IoBLdhJqQnYorzZTbGh91WDa+ps1uuC24wdxI7FfQb4sRQEvJ743jpNmr
	 KWilBhiwmKwE7CDQ1A8ayEXCy0Hl/CcDJU6D+GSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/290] net: lan743x: Modify the EEPROM and OTP size for PCI1xxxx devices
Date: Mon, 23 Jun 2025 15:06:35 +0200
Message-ID: <20250623130630.943845166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

[ Upstream commit 3b9935586a9b54d2da27901b830d3cf46ad66a1e ]

Maximum OTP and EEPROM size for hearthstone PCI1xxxx devices are 8 Kb
and 64 Kb respectively. Adjust max size definitions and return correct
EEPROM length based on device. Also prevent out-of-bound read/write.

Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://patch.msgid.link/20250523173326.18509-1-rengarajan.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/lan743x_ethtool.c   | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index 72b3092d35f71..39a58c3578a02 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -18,6 +18,8 @@
 #define EEPROM_MAC_OFFSET		    (0x01)
 #define MAX_EEPROM_SIZE			    (512)
 #define MAX_OTP_SIZE			    (1024)
+#define MAX_HS_OTP_SIZE			    (8 * 1024)
+#define MAX_HS_EEPROM_SIZE		    (64 * 1024)
 #define OTP_INDICATOR_1			    (0xF3)
 #define OTP_INDICATOR_2			    (0xF7)
 
@@ -272,6 +274,9 @@ static int lan743x_hs_otp_read(struct lan743x_adapter *adapter, u32 offset,
 	int ret;
 	int i;
 
+	if (offset + length > MAX_HS_OTP_SIZE)
+		return -EINVAL;
+
 	ret = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
 	if (ret < 0)
 		return ret;
@@ -320,6 +325,9 @@ static int lan743x_hs_otp_write(struct lan743x_adapter *adapter, u32 offset,
 	int ret;
 	int i;
 
+	if (offset + length > MAX_HS_OTP_SIZE)
+		return -EINVAL;
+
 	ret = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
 	if (ret < 0)
 		return ret;
@@ -497,6 +505,9 @@ static int lan743x_hs_eeprom_read(struct lan743x_adapter *adapter,
 	u32 val;
 	int i;
 
+	if (offset + length > MAX_HS_EEPROM_SIZE)
+		return -EINVAL;
+
 	retval = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
 	if (retval < 0)
 		return retval;
@@ -539,6 +550,9 @@ static int lan743x_hs_eeprom_write(struct lan743x_adapter *adapter,
 	u32 val;
 	int i;
 
+	if (offset + length > MAX_HS_EEPROM_SIZE)
+		return -EINVAL;
+
 	retval = lan743x_hs_syslock_acquire(adapter, LOCK_TIMEOUT_MAX_CNT);
 	if (retval < 0)
 		return retval;
@@ -604,9 +618,9 @@ static int lan743x_ethtool_get_eeprom_len(struct net_device *netdev)
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 
 	if (adapter->flags & LAN743X_ADAPTER_FLAG_OTP)
-		return MAX_OTP_SIZE;
+		return adapter->is_pci11x1x ? MAX_HS_OTP_SIZE : MAX_OTP_SIZE;
 
-	return MAX_EEPROM_SIZE;
+	return adapter->is_pci11x1x ? MAX_HS_EEPROM_SIZE : MAX_EEPROM_SIZE;
 }
 
 static int lan743x_ethtool_get_eeprom(struct net_device *netdev,
-- 
2.39.5



