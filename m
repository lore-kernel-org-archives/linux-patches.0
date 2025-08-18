Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECC422AE7A;
	Mon, 18 Aug 2025 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525346; cv=none; b=S2einFrVppt04wGXmlIzrItS3y8VMzMYXOYP7GPLsPH3D871mntji+GVqzhmZB8SQj2F8Gst23GQ6oialeTdewcS3/91hlysVcVUqYRJsfnu+xpO3iXwk5UTrEAZFBXw1ykK+7J9IiS9NbMp3+Oucl1hvtGTG6p3DItwQ8dkpN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525346; c=relaxed/simple;
	bh=qQbOm5V2YHwRcVPsN5JoVCJlSDzdZj06fpnOqvvjSwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKxzE/psFuQ1OFA+FiXyMNUzY72PwWb+SHyiJZ/gDNWxyRERe4TMyBWGvsLBt9Q4AZ/m3N1p/fF6zN1OmDVpl3hzojVvZxA4Wy4a5w6vi2U/GuvWwUHML+3Bmu89rhAFjOOtSX30NODyvSvl7OM/ifZUIAR8QqgRtdFb9gqQsEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raZ21Nha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raZ21Nha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34096C4CEEB;
	Mon, 18 Aug 2025 13:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525346;
	bh=qQbOm5V2YHwRcVPsN5JoVCJlSDzdZj06fpnOqvvjSwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raZ21NhadysBq44k+FIRlx4ZwogDejleseB0LvkhP2OMR5aK41QZwXRYcxuNygWX4
	 QIRlec7jjbS0AqU3F2DO5meqVCAPa+K9loE94klPiCtHj8z8dfSD2CHzYv373fq+z3
	 e3blMM80oFw02x0gcdAUvZqKAJDZExWLJpHBEQJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Ping CHNG <jchng@maxlinear.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 233/570] net: pcs: xpcs: mask readl() return value to 16 bits
Date: Mon, 18 Aug 2025 14:43:40 +0200
Message-ID: <20250818124514.804531734@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Ping CHNG <jchng@maxlinear.com>

[ Upstream commit 2b0ba7b5b010455c4e43ab557860f8b1089e7424 ]

readl() returns 32-bit value but Clause 22/45 registers are 16-bit wide.
Masking with 0xFFFF avoids using garbage upper bits.

Signed-off-by: Jack Ping CHNG <jchng@maxlinear.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250716030349.3796806-1-jchng@maxlinear.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs-plat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs-plat.c b/drivers/net/pcs/pcs-xpcs-plat.c
index 629315f1e57c..9dcaf7a66113 100644
--- a/drivers/net/pcs/pcs-xpcs-plat.c
+++ b/drivers/net/pcs/pcs-xpcs-plat.c
@@ -66,7 +66,7 @@ static int xpcs_mmio_read_reg_indirect(struct dw_xpcs_plat *pxpcs,
 	switch (pxpcs->reg_width) {
 	case 4:
 		writel(page, pxpcs->reg_base + (DW_VR_CSR_VIEWPORT << 2));
-		ret = readl(pxpcs->reg_base + (ofs << 2));
+		ret = readl(pxpcs->reg_base + (ofs << 2)) & 0xffff;
 		break;
 	default:
 		writew(page, pxpcs->reg_base + (DW_VR_CSR_VIEWPORT << 1));
@@ -124,7 +124,7 @@ static int xpcs_mmio_read_reg_direct(struct dw_xpcs_plat *pxpcs,
 
 	switch (pxpcs->reg_width) {
 	case 4:
-		ret = readl(pxpcs->reg_base + (csr << 2));
+		ret = readl(pxpcs->reg_base + (csr << 2)) & 0xffff;
 		break;
 	default:
 		ret = readw(pxpcs->reg_base + (csr << 1));
-- 
2.39.5



