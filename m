Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7868364B7;
	Fri, 24 Nov 2023 18:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK2tmVaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590C5C433C7;
	Fri, 24 Nov 2023 18:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851461;
	bh=4Y+NDxKCDlfr7IDPAEhRI89O8E+Usa8Ax7AeXKcqEBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK2tmVaE7WH6INu/8FGZfrzqyGcAKDAvnSQsnhmzZukCbAtIs8dUz/fyf/Fs0fEn2
	 qcLmI979Z2WRxi7eE+4QOGONLUSbYv1sv05mjJloggb94XLhDJU/xUPZgXcQUzT8A4
	 JF40D7BG2fLsheuc+ZwW5myHTkF87T4aVCvlPGmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.5 457/491] Revert "net: r8169: Disable multicast filter for RTL8168H and RTL8107E"
Date: Fri, 24 Nov 2023 17:51:33 +0000
Message-ID: <20231124172038.346700395@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2599,9 +2599,7 @@ static void rtl_set_rx_mode(struct net_d
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


