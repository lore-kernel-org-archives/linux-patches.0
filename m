Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7FE6FB1;
	Tue,  5 Dec 2023 03:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WavEWzml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC2BC433C7;
	Tue,  5 Dec 2023 03:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747325;
	bh=N0f77KYhWH6ZKrz2zARSOL1qw1IHqEujbAat7Gjv0ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WavEWzmldcdIKvgFopKAK7HwPRZh0UQBekkR/6fKfdvKj5hIu3jNaPHTBRo0nNfAb
	 VpGxn8Ih9gfrR2xCOND254xLFEYzmGQ4YZj3VMn9oEYHGe2e6f8N7qpRw8pUpx6ucR
	 oHS+2h+YDtd6Isp+fXsyw6/C7WFBjVA1k5N1+6xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/135] Revert "net: r8169: Disable multicast filter for RTL8168H and RTL8107E"
Date: Tue,  5 Dec 2023 12:15:30 +0900
Message-ID: <20231205031531.072676829@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6e0fe77d1019c..ab6af1f1ad5bb 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2581,9 +2581,7 @@ static void rtl_set_rx_mode(struct net_device *dev)
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
-- 
2.42.0



