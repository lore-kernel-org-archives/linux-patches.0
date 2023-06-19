Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA623C23
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E5BC433C0;
	Mon, 19 Jun 2023 10:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171175;
	bh=WPIb16hqrlz61l0FQA8ADKcKMCDqMZD1I8OUcKmMBzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeFzhQb5veau3G/OHXQANCcMkEfWxSHwf90k2dB90mLOETwO+zVvh2sTa64OM1934
	 Gn99PF3l9KDyKcH0GIaIVmc2oesejc5jaJtmDwvLeAaXjuaRLd1I9rbGKLqDFWVUw/
	 jvJOVryAGYHzAfH7w3JgJyohcDg5IhpKUD/FxUsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 174/187] net: dsa: felix: fix taprio guard band overflow at 10Mbps with jumbo frames
Date: Mon, 19 Jun 2023 12:29:52 +0200
Message-ID: <20230619102206.094132849@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
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

[ Upstream commit 6ac7a27a8b07588497ed53dfd885df9c72bc67e0 ]

The DEV_MAC_MAXLEN_CFG register contains a 16-bit value - up to 65535.
Plus 2 * VLAN_HLEN (4), that is up to 65543.

The picos_per_byte variable is the largest when "speed" is lowest -
SPEED_10 = 10. In that case it is (1000000L * 8) / 10 = 800000.

Their product - 52434400000 - exceeds 32 bits, which is a problem,
because apparently, a multiplication between two 32-bit factors is
evaluated as 32-bit before being assigned to a 64-bit variable.
In fact it's a problem for any MTU value larger than 5368.

Cast one of the factors of the multiplication to u64 to force the
multiplication to take place on 64 bits.

Issue found by Coverity.

Fixes: 55a515b1f5a9 ("net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230613170907.2413559-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index dddb28984bdfc..841c5ebc1afaa 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1263,7 +1263,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 	/* Consider the standard Ethernet overhead of 8 octets preamble+SFD,
 	 * 4 octets FCS, 12 octets IFG.
 	 */
-	needed_bit_time_ps = (maxlen + 24) * picos_per_byte;
+	needed_bit_time_ps = (u64)(maxlen + 24) * picos_per_byte;
 
 	dev_dbg(ocelot->dev,
 		"port %d: max frame size %d needs %llu ps at speed %d\n",
-- 
2.39.2



