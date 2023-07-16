Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3E18F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020D9C433C7;
	Sun, 16 Jul 2023 20:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540849;
	bh=4L/lGcZDP99+yKAZMmMt57khA5Xzuwl0k7JPJBt3Exg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkZbmlMrdzz2XftooBE5xUXHDDTxZw/is6HPj2Fr1ML40aKr2RvULGtqBweBDncdv
	 3BwOWHZSaH7dM9SIOt9RMMKM0ZcfjV8ANTn3LMDKkcztBjP/2apiXETa0BAk9PBO64
	 ANEWl1xLRq2huC/y5CbSSSZR4SAwcv6b8nQw/qO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 509/591] net: dsa: tag_sja1105: fix MAC DA patching from meta frames
Date: Sun, 16 Jul 2023 21:50:48 +0200
Message-ID: <20230716194937.055286343@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 1dcf6efd5f0c1f4496b3ef7ec5a7db104a53b38c ]

The SJA1105 manual says that at offset 4 into the meta frame payload we
have "MAC destination byte 2" and at offset 5 we have "MAC destination
byte 1". These are counted from the LSB, so byte 1 is h_dest[ETH_HLEN-2]
aka h_dest[4] and byte 2 is h_dest[ETH_HLEN-3] aka h_dest[3].

The sja1105_meta_unpack() function decodes these the other way around,
so a frame with MAC DA 01:80:c2:11:22:33 is received by the network
stack as having 01:80:c2:22:11:33.

Fixes: e53e18a6fe4d ("net: dsa: sja1105: Receive and decode meta frames")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_sja1105.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 6e3699d859dbd..d3f27cd5fe244 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -113,8 +113,8 @@ static void sja1105_meta_unpack(const struct sk_buff *skb,
 	 * a unified unpacking command for both device series.
 	 */
 	packing(buf,     &meta->tstamp,     31, 0, 4, UNPACK, 0);
-	packing(buf + 4, &meta->dmac_byte_4, 7, 0, 1, UNPACK, 0);
-	packing(buf + 5, &meta->dmac_byte_3, 7, 0, 1, UNPACK, 0);
+	packing(buf + 4, &meta->dmac_byte_3, 7, 0, 1, UNPACK, 0);
+	packing(buf + 5, &meta->dmac_byte_4, 7, 0, 1, UNPACK, 0);
 	packing(buf + 6, &meta->source_port, 7, 0, 1, UNPACK, 0);
 	packing(buf + 7, &meta->switch_id,   7, 0, 1, UNPACK, 0);
 }
-- 
2.39.2



