Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E702F0C45;
	Mon, 22 Sep 2025 19:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569512; cv=none; b=lmg18b0erAHE3W61c7xag4lMlR63PoQzZeXVVnv3DRh7jKocZu+48ImknYSEUBWtWS7WEorLoxIsKYEyGW3NgVsJvcjAsOxrPhfWzxRqbmhCBUzcXR1zPE06PcfmeiUbI6mcHKeOglmNilWRHnMQSXBFf49HOFGRIgbjaeqYg08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569512; c=relaxed/simple;
	bh=VDeFFKVQL4RyuZ+AA/00+TEnjFGXinlxhNzsIP+W3b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ktd0f+jNTBULW0b+UbJZIR5p08y4IYrz990l3EKX9osjO5fDgDu0e5Nk62vUWeY5uvKojbq6M1QbD74joB2ISR3UM72DFBtOh7o7/7OkCnnCyGGtNGp0+KyypJ3IH2/KECEZUC5doebbcqwciqpu5tlhJF7UQ67Xyv9Ob/9ekL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqCLTwTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqCLTwTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372E7C113D0;
	Mon, 22 Sep 2025 19:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569511;
	bh=VDeFFKVQL4RyuZ+AA/00+TEnjFGXinlxhNzsIP+W3b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqCLTwTYiFaUq5H7pyIdfKpdWm4qV9CRFaYuF5NWfQISKZd2MQiTgTCffh42xadwx
	 4xg1O3S65siACk8/KX40EIsjvXcSgakoHQqhbhg8FqjR8vLW6RSmRpYm3NNc1fmvIv
	 rWLeyij0wcptaFRyjlj9A2WICa5huD+Z2SfQan3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wilder <wilder@us.ibm.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/61] bonding: dont set oif to bond dev when getting NS target destination
Date: Mon, 22 Sep 2025 21:29:06 +0200
Message-ID: <20250922192403.912825438@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit a8ba87f04ca9cdec06776ce92dce1395026dc3bb ]

Unlike IPv4, IPv6 routing strictly requires the source address to be valid
on the outgoing interface. If the NS target is set to a remote VLAN interface,
and the source address is also configured on a VLAN over a bond interface,
setting the oif to the bond device will fail to retrieve the correct
destination route.

Fix this by not setting the oif to the bond device when retrieving the NS
target destination. This allows the correct destination device (the VLAN
interface) to be determined, so that bond_verify_device_path can return the
proper VLAN tags for sending NS messages.

Reported-by: David Wilder <wilder@us.ibm.com>
Closes: https://lore.kernel.org/netdev/aGOKggdfjv0cApTO@fedora/
Suggested-by: Jay Vosburgh <jv@jvosburgh.net>
Tested-by: David Wilder <wilder@us.ibm.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20250916080127.430626-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 11c58b88f9ce7..69ea7db784fd7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3206,7 +3206,6 @@ static void bond_ns_send_all(struct bonding *bond, struct slave *slave)
 		/* Find out through which dev should the packet go */
 		memset(&fl6, 0, sizeof(struct flowi6));
 		fl6.daddr = targets[i];
-		fl6.flowi6_oif = bond->dev->ifindex;
 
 		dst = ip6_route_output(dev_net(bond->dev), NULL, &fl6);
 		if (dst->error) {
-- 
2.51.0



