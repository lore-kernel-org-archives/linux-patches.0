Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB2718657
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SmWiiSoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCB1C433C7;
	Wed, 15 Nov 2023 20:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081185;
	bh=Ejt3raMm6zCySwgInNeUd02CHrkGCjM0eaHvIHKAIm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SmWiiSoU+VjrNePY1V3whuw+lci+3e9yLp4U7I7CCGB4+iOk/SRdBiU7sggmsB2Ul
	 Nv5hxsOhrc1qr1SQxzFhFJ3kYME+TLR19W5UoycP/I4jFo0RUkSQRsz85/rd+veotT
	 j8QKrkeZvX/Fauhrwm06B6Sp9IFbZDjJ1QqLHbhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Thompson <ptf@google.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 77/88] net: r8169: Disable multicast filter for RTL8168H and RTL8107E
Date: Wed, 15 Nov 2023 15:36:29 -0500
Message-ID: <20231115191430.701744889@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Thompson <ptf@google.com>

[ Upstream commit efa5f1311c4998e9e6317c52bc5ee93b3a0f36df ]

RTL8168H and RTL8107E ethernet adapters erroneously filter unicast
eapol packets unless allmulti is enabled. These devices correspond to
RTL_GIGA_MAC_VER_46 and VER_48. Add an exception for VER_46 and VER_48
in the same way that VER_35 has an exception.

Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
Signed-off-by: Patrick Thompson <ptf@google.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/20231030205031.177855-1-ptf@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2a59087364808..69d01b68cf6b7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4626,7 +4626,9 @@ static void rtl_set_rx_mode(struct net_device *dev)
 		rx_mode |= AcceptAllPhys;
 	} else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
 		   dev->flags & IFF_ALLMULTI ||
-		   tp->mac_version == RTL_GIGA_MAC_VER_35) {
+		   tp->mac_version == RTL_GIGA_MAC_VER_35 ||
+		   tp->mac_version == RTL_GIGA_MAC_VER_46 ||
+		   tp->mac_version == RTL_GIGA_MAC_VER_48) {
 		/* accept all multicasts */
 	} else if (netdev_mc_empty(dev)) {
 		rx_mode &= ~AcceptMulticast;
-- 
2.42.0



