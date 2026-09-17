Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B674E5322;
	Thu, 17 Sep 2026 16:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664080; cv=none; b=eR2hF8Una3ymyWfulHo9BMM8XnEYVJ3U5Az1bRy7ZHMlLjZiSjQoNUvEo8Q5W14QQFo1JBuNq1DOnv0R7xkvPEKjiff1Zqe3JBYy1b86M7DLJYiS/nSOG3ficZIm99Pwr9KIW1K7t2bkkgH5UKPeAMXa+M90ooc2uYrkAbdo1XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664080; c=relaxed/simple;
	bh=/ZCDvxjHOS3VuCSjGP0cQQMMznjceq2rMHQdA+gTe8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqWiXc7lJ1ac52dFiS5A6de5nB5XWRIEaOptMDGALVSZqt2f/b/fOnclv9ALNc8hMoFeYOhDlraYaAMYXbHn34VQrIPHtrMJWerizLvn4CI2HTqaJblDsWoOOAQkvbWiDnwXwZH84ZrsSp0DFP1r8vk7hrtBbUhQ8dgFVsf8p9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWU0SvWc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWU0SvWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367441F000FF;
	Thu, 17 Sep 2026 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664078;
	bh=SCAlLhBFdXFffxd1Z5w1zQdkGuFdXfUWch23549wuxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWU0SvWcpJ5E9JOPXIdk9trXMdzFuqFzdUpoQttS89ZX5i/ED7LMIll4zAudDDrAW
	 Yv3F0gNX1q7aKYGbXF4GEs5VDspdTzymZFLRAPLg1pGTG+Nxvw/YzKuJEXaCtJI/XB
	 1717TsuO+TktosxX/VgXZW78oL9/m+0RaM4CYGFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Qisen <weixiansen574@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0250/1250] net: sfp: add quirk for OEM 2.5G optical modules
Date: Thu, 17 Sep 2026 16:00:45 +0100
Message-ID: <20260917151558.927280306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9683f9c2cd882..af43530ffb2c3 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -583,6 +583,8 @@ static const struct sfp_quirk sfp_quirks[] = {
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



