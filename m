Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAAF8837;
	Mon, 28 Oct 2024 06:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098115; cv=none; b=XkLhtbhT0ee5LkHGz94Pvfte6eqR8UD/fq1a/xBvJo9NSXSE0Xc+vE6oAQgiPKgH8TERAqfw3GxJ0rX//CGUrsTehQbK+MtD/sQs1rKuOZ9pR1NmkkIfA//hG7g0zRrwlmMQG5Kxh7syqrrV1D4ZKuOU++PHsEbTh7krJM47aY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098115; c=relaxed/simple;
	bh=5Qds7wpUQYLBJ3zRCyxA6zcIT6t7gcWtq06CSSDzkPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQZ8y/PSAayF402EBVRJM1c/YQuuT1be8rOSNalgTWFqK28dofmBud1/sP9EqAIxkQEdBcMCS1WTyyVDXixnzGP5fhBxmrDS7rV9sQrljhpLhNHq23Lxx6/+6o71EyUZ9kmvkujM+oN7hsJaM970lX91GXAz6/5uLd5j3C4oyOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0bklSoJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0bklSoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1147C4CEC3;
	Mon, 28 Oct 2024 06:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098115;
	bh=5Qds7wpUQYLBJ3zRCyxA6zcIT6t7gcWtq06CSSDzkPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0bklSoJnjlPIdomliYP8Nb/6oFZoGzimfUO5wrQzyeMAL7DOvpStXf71MMRcJvB+
	 kKEKRquTl/UdKuOf6c9uDFWo/1tyBj3Q2tD72S2SC1wtjZwQluKDNpnr5tOIoSd8ZT
	 9dD7CEzuG+sw0gyQ7VExIZc3jPYiqUN1awaRMvlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Dembicki <paweldembicki@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 083/261] net: dsa: vsc73xx: fix reception from VLAN-unaware bridges
Date: Mon, 28 Oct 2024 07:23:45 +0100
Message-ID: <20241028062314.112781768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 11d06f0aaef89f4cad68b92510bd9decff2d7b87 ]

Similar to the situation described for sja1105 in commit 1f9fc48fd302
("net: dsa: sja1105: fix reception from VLAN-unaware bridges"), the
vsc73xx driver uses tag_8021q and doesn't need the ds->untag_bridge_pvid
request. In fact, this option breaks packet reception.

The ds->untag_bridge_pvid option strips VLANs from packets received on
VLAN-unaware bridge ports. But those VLANs should already be stripped
by tag_vsc73xx_8021q.c as part of vsc73xx_rcv() - they are not VLANs in
VLAN-unaware mode, but DSA tags. Thus, dsa_software_vlan_untag() tries
to untag a VLAN that doesn't exist, corrupting the packet.

Fixes: 93e4649efa96 ("net: dsa: provide a software untagging function on RX for VLAN-aware bridges")
Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patch.msgid.link/20241014153041.1110364-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 212421e9d42e4..f5a1fefb76509 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -721,7 +721,6 @@ static int vsc73xx_setup(struct dsa_switch *ds)
 
 	dev_info(vsc->dev, "set up the switch\n");
 
-	ds->untag_bridge_pvid = true;
 	ds->max_num_bridges = DSA_TAG_8021Q_MAX_NUM_BRIDGES;
 
 	/* Issue RESET */
-- 
2.43.0



