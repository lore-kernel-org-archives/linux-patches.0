Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261214EDCD1;
	Thu, 17 Sep 2026 17:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667803; cv=none; b=gQbEzaeOiXgEDjTmoyQE4vEUT7CJZ64t/e+uRmoAola9rNx14HqtVbic9ZdIScumyHaASFNUDzTw4QVagh4bd90lPnHfofZCjVytSeHRLQ4vM2byHKxjBJjeuVVUzuW8UADttnLMCPQv/TEIHPU2VZsw4Mn8+pkyR09bk78TRgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667803; c=relaxed/simple;
	bh=2PUK0QcQXfSC/YxQTFQhNoeMCJZYxO0RC8Fwx7vhvPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A01FqqipVKAB/MZe7bl6f5JHvJMb+dBgtk1TXnx+bCEvb8yE9D5JLRM1c94TJoIU2r9cAiXTNoWYVhbhjvP00zeLhX8+bEG1OqnONYQQh/bMItIj0GwdjR4vvG2h2W55lwhRUc/trgaVA69LoRk7SmEfsar/mqKXy92ko+pvpZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQn7e7f6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQn7e7f6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760FC1F000FF;
	Thu, 17 Sep 2026 17:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667802;
	bh=WlFlJ3GFEskmoHfybvN7N4XjPE1Ob5qZfeL9I90gy3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQn7e7f6TdnCOSgxLWk47/vqycyflhJ/Bo6n0P/Lm9X69OeC5Cc9yRJdM3KMDEsK0
	 UvNs8pwW9kaFW1p9q0y5fsUYGvI/bGGwshxby64PnztEhd6uFOvRF/v/vmZ1DZ8hJR
	 4jbNJ/PsdcZta7zccgmL/BPhMs7f9cLCaAHviEwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Qisen <weixiansen574@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0176/1102] net: sfp: add quirk for OEM 2.5G optical modules
Date: Thu, 17 Sep 2026 16:01:59 +0100
Message-ID: <20260917151543.976492749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Qisen <weixiansen574@163.com>

[ Upstream commit 5af067bf8a64dac896f120a98fe2ca656df92562 ]

Some OEM-branded SFP modules are incorrectly detected as
1000Base-X and fail to establish link on 2.5G-capable ports.

These modules do not properly advertise 2500Base-X capability
in their EEPROM and require forcing the correct SerDes mode.

Add sfp_quirk_2500basex for:

  - OEM SFP-2.5G-LH03-B
  - OEM SFP-2.5G-LH20-A

Both modules report:

  Vendor name: OEM
  Vendor PN: SFP-2.5G-LH03-B / SFP-2.5G-LH20-A

Tested on OpenWrt with successful 2.5G link establishment.

Signed-off-by: Wei Qisen <weixiansen574@163.com>
Link: https://patch.msgid.link/20260526055206.1750-1-weixiansen574@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 6eefe98316f53..512f817607c82 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -576,6 +576,8 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_S("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 	SFP_QUIRK_S("OEM", "SFP-2.5G-BX10-D", sfp_quirk_2500basex),
 	SFP_QUIRK_S("OEM", "SFP-2.5G-BX10-U", sfp_quirk_2500basex),
+	SFP_QUIRK_S("OEM", "SFP-2.5G-LH03-B", sfp_quirk_2500basex),
+	SFP_QUIRK_S("OEM", "SFP-2.5G-LH20-A", sfp_quirk_2500basex),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("Turris", "RTSFP-2.5G", sfp_fixup_rollball),
-- 
2.53.0



