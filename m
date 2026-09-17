Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E88D4DDB3A;
	Thu, 17 Sep 2026 15:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659863; cv=none; b=S/jfZNWpubJ7ZEGADtzu3cYlPDJtcQBZVn8Ts7JuGgpSeRqVo/coDGvObEh5sHLRE4A77WL9NEY+1ZNliPSKvoXZ6rWT4ggkqhBktYhqXAH/aJktEmWXf1NYas9kOCjP/xOQpmkjM/nFuITDAHyw5nKSFaJKIcnO8qlCtlLougw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659863; c=relaxed/simple;
	bh=DIJxL/YOhRChdNdIsW2sBSmNQ1rUqhgUJWHzAdLfjFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjH8naSzDg+yCJMkmF7gBIviGnFydpED85fELFZeBIAipsuZwZizHMCcC2s6XDrwlfKM7Q7pNN5nNZ/fgyVyeDF8yxgjZT7ykDl1gVt8iPfoG5rcR4ZNlxs8AjFNaACNrtjd8vuN41x+4Kne2rdN9aetU+IRPEN9FYxZY9grdn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbNEiLnb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbNEiLnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F99F1F000FF;
	Thu, 17 Sep 2026 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659856;
	bh=41NoriK+lskw7T1+1oHHSuzSfeVm4LNlSgFY0/cjBbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbNEiLnblqPeU8vXHBIftQ9lZVu6MTopdc16FO4VtIL/a3tUWY23RjHRlcytp0czo
	 wwwnT2j5pu9HqfPNVuV2a3npg4psNCDF1yiiKvKL4foqvzCRrQcRCsFyoxtN/K55Kd
	 oAPOfIk61NOLWG6rf8seeYmYLLk4rpLF41qc4Jcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jan Havran (Advantech Czech)" <havran.jan@email.cz>,
	Daniel Golle <daniel@makrotopia.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 397/733] net: dsa: lantiq_gswip: fix GSWIP_MDIO_PHY_FCONTX_EN value
Date: Thu, 17 Sep 2026 16:11:45 +0100
Message-ID: <20260917151401.618432689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Havran (Advantech Czech) <havran.jan@email.cz>

[ Upstream commit 59fb389ad6bf50916189e56dafcd225ab977f874 ]

Per the GSW145 data sheet, the FCONTX (bits 8:7) and FCONRX (bits 6:5)
flow-control fields of the PHY_ADDR_n register both encode 00 = AUTO,
01 = EN, 10 = reserved, 11 = DIS. GSWIP_MDIO_PHY_FCONTX_EN was 0x0100,
i.e. field value 10 (the reserved encoding), instead of 0x0080 (01 = EN);
FCONRX_EN is already 0x0020 (01). Enabling tx flow control therefore wrote
the reserved value.

Set FCONTX_EN to 0x0080. The register is shared by all supported parts.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Jan Havran (Advantech Czech) <havran.jan@email.cz>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260907134818.16670-4-havran.jan@email.cz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq/lantiq_gswip.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq/lantiq_gswip.h b/drivers/net/dsa/lantiq/lantiq_gswip.h
index bc3686faad0d6..0b75be14dc109 100644
--- a/drivers/net/dsa/lantiq/lantiq_gswip.h
+++ b/drivers/net/dsa/lantiq/lantiq_gswip.h
@@ -42,7 +42,7 @@
 #define  GSWIP_MDIO_PHY_FDUP_DIS	0x0600
 #define  GSWIP_MDIO_PHY_FCONTX_MASK	0x0180
 #define  GSWIP_MDIO_PHY_FCONTX_AUTO	0x0000
-#define  GSWIP_MDIO_PHY_FCONTX_EN	0x0100
+#define  GSWIP_MDIO_PHY_FCONTX_EN	0x0080
 #define  GSWIP_MDIO_PHY_FCONTX_DIS	0x0180
 #define  GSWIP_MDIO_PHY_FCONRX_MASK	0x0060
 #define  GSWIP_MDIO_PHY_FCONRX_AUTO	0x0000
-- 
2.53.0



