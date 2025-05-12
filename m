Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C278329710F;
	Mon, 12 May 2025 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073359; cv=none; b=fG3cRIOpBegWW/VDSVWCZVSkgMaHbDsBFmDmdFoQXUOhetMnGBCSehQ/XzEhbIombm5K0A0Wo6p1nkRKUwM6Iu/sXokbCDRyy7CqeX0BrKB53GnBFs++A7Tm1YJWLmi7firdVvSwZJzM5JNSt+2h1qRx18fYp1dsWfhgI1f4xNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073359; c=relaxed/simple;
	bh=t0o2/x6kNYnC8+8rom1Q66alTRs6LeR04c4PQwUNpvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cj1lzsgCEuc6LrbD2UbKsgz2WtX62KLnokv88MMaN4coKazs7j4ACF1pWiZyyQaxLDZF3b1IODpq2Z3WHzb/qRpD4ug2Dxj3MVN81E+t5Hc9yMu0VlHwEyl//Sk67yu8dGmIBxF8N8Jx8VeCCOLDv30D6Rk1auPymxNtcyQJrTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQmGDU/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQmGDU/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4EBC4CEE7;
	Mon, 12 May 2025 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073359;
	bh=t0o2/x6kNYnC8+8rom1Q66alTRs6LeR04c4PQwUNpvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQmGDU/ZDmzjWWthZ/AQ2dro1hSY4oxUHAUDmVKU6xa0KPI2xGqq0X6KtEuIALd0m
	 JBt4fWj3Wjh58XAJUdX9iR10DtFJTCGk88emHRfM+HkDffG/0SfJ7qRa/inrPikUBR
	 YCAaAzQJSyVvsFuWU5r+Jo+kYpVm3QCjnXG4wbqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/113] net: dsa: b53: allow leaky reserved multicast
Date: Mon, 12 May 2025 19:45:09 +0200
Message-ID: <20250512172028.509221767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 5f93185a757ff38b36f849c659aeef368db15a68 ]

Allow reserved multicast to ignore VLAN membership so STP and other
management protocols work without a PVID VLAN configured when using a
vlan aware bridge.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-2-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index cfcda893f1a16..c438a5d9f6d8c 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -373,9 +373,11 @@ static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 		b53_read8(dev, B53_VLAN_PAGE, B53_VLAN_CTRL5, &vc5);
 	}
 
+	vc1 &= ~VC1_RX_MCST_FWD_EN;
+
 	if (enable) {
 		vc0 |= VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID;
-		vc1 |= VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN;
+		vc1 |= VC1_RX_MCST_UNTAG_EN;
 		vc4 &= ~VC4_ING_VID_CHECK_MASK;
 		if (enable_filtering) {
 			vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
@@ -393,7 +395,7 @@ static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 
 	} else {
 		vc0 &= ~(VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID);
-		vc1 &= ~(VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN);
+		vc1 &= ~VC1_RX_MCST_UNTAG_EN;
 		vc4 &= ~VC4_ING_VID_CHECK_MASK;
 		vc5 &= ~VC5_DROP_VTABLE_MISS;
 
-- 
2.39.5



