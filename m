Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E4E2E64F;
	Fri, 24 Nov 2023 19:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zow7gQJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000E6C433C8;
	Fri, 24 Nov 2023 19:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852419;
	bh=epGhJE+ZmgWtG2JvI243lhWOIA9VbfvO6n5oWWLTVjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zow7gQJqOFFuf4O42w5Q2nHlmKOEGbPKm+chnJ59UfS8+LvNc2Em4sKFrWFKAQFuY
	 LAHTczGJuli5rbWWygqmF/l1MXClFOwqTGAQh2gzqxD/d9gfwwKmvzSOgE+rTqjwak
	 1AG0vPuv8nv9pCS7LjnTzu8u8y3dDgSVloyD2zus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 348/372] Revert "net: r8169: Disable multicast filter for RTL8168H and RTL8107E"
Date: Fri, 24 Nov 2023 17:52:15 +0000
Message-ID: <20231124172021.947945702@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit 6a26310273c323380da21eb23fcfd50e31140913 upstream.

This reverts commit efa5f1311c4998e9e6317c52bc5ee93b3a0f36df.

I couldn't reproduce the reported issue. What I did, based on a pcap
packet log provided by the reporter:
- Used same chip version (RTL8168h)
- Set MAC address to the one used on the reporters system
- Replayed the EAPOL unicast packet that, according to the reporter,
  was filtered out by the mc filter.
The packet was properly received.

Therefore the root cause of the reported issue seems to be somewhere
else. Disabling mc filtering completely for the most common chip
version is a quite big hammer. Therefore revert the change and wait
for further analysis results from the reporter.

Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2529,9 +2529,7 @@ static void rtl_set_rx_mode(struct net_d
 		rx_mode &= ~AcceptMulticast;
 	} else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
 		   dev->flags & IFF_ALLMULTI ||
-		   tp->mac_version == RTL_GIGA_MAC_VER_35 ||
-		   tp->mac_version == RTL_GIGA_MAC_VER_46 ||
-		   tp->mac_version == RTL_GIGA_MAC_VER_48) {
+		   tp->mac_version == RTL_GIGA_MAC_VER_35) {
 		/* accept all multicasts */
 	} else if (netdev_mc_empty(dev)) {
 		rx_mode &= ~AcceptMulticast;


