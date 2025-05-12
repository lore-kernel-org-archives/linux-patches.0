Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB8E296D0A;
	Mon, 12 May 2025 17:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071074; cv=none; b=fpqBoCmffFumXGIjYyr5Oh/9ChkqyitVSXbTaYWxjl9cgI8CIRuuJc0Hgika1ZZfON47zPcZTC8P+uOwpVqKL63jI7N65J8vDjp1RZFQoxiIvyh0H1lToKixPjG6RW8qpZ6tajFyqzac4PovOwEHnoIi1ZsuIYT0G62/N5hY25k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071074; c=relaxed/simple;
	bh=8Aj6IADtlvHUDxdCiAXUOH21L7RD/SBHPTkHddtcbrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqZXyRCwJMfVyppK3b1zoT8x2Kq3VRgAu9l3F7hNuji09m18UnehvwRZdgbRzRm0sd0QEYf0/+IdD3n+VdiF6MBx1623oECqVyM6wZTK3gVqgFjC4tUCjBiKDjD63YuWRyZ2q1sF5Fgy3tkj9F4tgj8Oltc2H0GqH5QA9BC2b3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7r4pkHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7r4pkHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BAAC4CEF0;
	Mon, 12 May 2025 17:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071074;
	bh=8Aj6IADtlvHUDxdCiAXUOH21L7RD/SBHPTkHddtcbrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7r4pkHOBGSMApmpKkum/S1JbGmh5SDELk63vRkork7Nor8NbTbj+O3P1z6r+0Erd
	 kjDbXh+WngSgSwA7yksah6NXfWAGbuV9dU3tL3xB+7AY4z0NrxAPcIWeLdNFh4NHSb
	 UzC21QPIaNluicZhCkjEOT15vkidzxjNzxCh2m4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/54] net: dsa: b53: allow leaky reserved multicast
Date: Mon, 12 May 2025 19:29:21 +0200
Message-ID: <20250512172016.023855586@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 27025ca5a7598..08f9929132e47 100644
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



