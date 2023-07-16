Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DBF8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D34C433C8;
	Sun, 16 Jul 2023 20:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539195;
	bh=1UpT1TWBV9x2CjhQDZg9Hsh676ijJdpM5Dh07HXkiek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrE/LD/sqXLUXIGVOPIFbaU9FRpnIp3oU9mQqL6BCDfXpZno/oqoOJS4piD+StDiQ
	 VXpt1UuxKpaZ/g+/rDuySKPu/rtp2zLymZCB5QCgc4fVIwiKbODYwL7xRlrVMKqtHn
	 e0cv0PYWNQR0ixUk91NTYTX4aGwZ2BRepcNp7TRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 692/800] net: dsa: tag_sja1105: fix source port decoding in vlan_filtering=0 bridge mode
Date: Sun, 16 Jul 2023 21:49:05 +0200
Message-ID: <20230716195005.196480300@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit a398b9ea0c3b791b7a0f4c6029a62cf628f97f22 ]

There was a regression introduced by the blamed commit, where pinging to
a VLAN-unaware bridge would fail with the repeated message "Couldn't
decode source port" coming from the tagging protocol driver.

When receiving packets with a bridge_vid as determined by
dsa_tag_8021q_bridge_join(), dsa_8021q_rcv() will decode:
- source_port = 0 (which isn't really valid, more like "don't know")
- switch_id = 0 (which isn't really valid, more like "don't know")
- vbid = value in range 1-7

Since the blamed patch has reversed the order of the checks, we are now
going to believe that source_port != -1 and switch_id != -1, so they're
valid, but they aren't.

The minimal solution to the problem is to only populate source_port and
switch_id with what dsa_8021q_rcv() came up with, if the vbid is zero,
i.e. the source port information is trustworthy.

Fixes: c1ae02d87689 ("net: dsa: tag_sja1105: always prefer source port information from INCL_SRCPT")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_sja1105.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 92a626a05e829..db0a6ac674708 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -573,11 +573,14 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		 * if available. This allows us to not overwrite a valid source
 		 * port and switch ID with zeroes when receiving link-local
 		 * frames from a VLAN-unaware bridged port (non-zero vbid) or a
-		 * VLAN-aware bridged port (non-zero vid).
+		 * VLAN-aware bridged port (non-zero vid). Furthermore, the
+		 * tag_8021q source port information is only of trust when the
+		 * vbid is 0 (precise port). Otherwise, tmp_source_port and
+		 * tmp_switch_id will be zeroes.
 		 */
-		if (source_port == -1)
+		if (vbid == 0 && source_port == -1)
 			source_port = tmp_source_port;
-		if (switch_id == -1)
+		if (vbid == 0 && switch_id == -1)
 			switch_id = tmp_switch_id;
 	} else if (source_port == -1 && switch_id == -1) {
 		/* Packets with no source information have no chance of
-- 
2.39.2



