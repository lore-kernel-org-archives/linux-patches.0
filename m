Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB8479C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41E7C433D6;
	Wed, 30 Nov 2022 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834210;
	bh=7EPRkVUBQYDyzRQxr5veA5LCGVvk0iYxBc6G0F3Mljo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQkcU/uaKK96jsQBGeGKxyOfSbT8WzBtLtmxOZ2gO3duISnt0hWOEdZGOi4osL7CY
	 C0SCWsfdKpFUTz88Uh++bSbQCLgB4GIn+NcNT4xvfv2OKYBzT6C3nbXpr5J1GQTnPf
	 3jUUC6MjLDiDcxDJWXLHXlMJS+ule7S9QeFCo4S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Santiago=20Ruano=20Rinc=C3=B3n?= <santiago.ruano-rincon@imt-atlantique.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 142/289] net/cdc_ncm: Fix multicast RX support for CDC NCM devices with ZLP
Date: Wed, 30 Nov 2022 19:22:07 +0100
Message-Id: <20221130180547.357274617@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Santiago Ruano Rincón <santiago.ruano-rincon@imt-atlantique.fr>

[ Upstream commit 748064b54c99418f615aabff5755996cd9816969 ]

ZLP for DisplayLink ethernet devices was enabled in 6.0:
266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices").
The related driver_info should be the "same as cdc_ncm_info, but with
FLAG_SEND_ZLP". However, set_rx_mode that enables handling multicast
traffic was missing in the new cdc_ncm_zlp_info.

usbnet_cdc_update_filter rx mode was introduced in linux 5.9 with:
e10dcb1b6ba7 ("net: cdc_ncm: hook into set_rx_mode to admit multicast
traffic")

Without this hook, multicast, and then IPv6 SLAAC, is broken.

Fixes: 266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices")
Signed-off-by: Santiago Ruano Rincón <santiago.ruano-rincon@imt-atlantique.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 8d5cbda33f66..0897fdb6254b 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1915,6 +1915,7 @@ static const struct driver_info cdc_ncm_zlp_info = {
 	.status = cdc_ncm_status,
 	.rx_fixup = cdc_ncm_rx_fixup,
 	.tx_fixup = cdc_ncm_tx_fixup,
+	.set_rx_mode = usbnet_cdc_update_filter,
 };
 
 /* Same as cdc_ncm_info, but with FLAG_WWAN */
-- 
2.35.1



