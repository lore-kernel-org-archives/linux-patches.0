Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EBB20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C93C433C9;
	Fri, 21 Jul 2023 19:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966411;
	bh=lxZHhkf1VF2Au62W0WohlTjYjmYhHmr97MDg52ZdFm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkXsgYEV5+XmQ+AHnrAjfgcfzY54O13ZBOdVg3r2mN5BUxEMdHpS+HSe61W79g9P2
	 DHzBe/X4B1Ow4Fagi+4Nca/ZSNxXDj2iW4reFY8Rhe9u+IyRwnapTofj7SQzSqsnvG
	 rpwdrs0is2usLcKw7ghDhlpW9eHuv6LA5QPdpWB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 334/532] net: dsa: tag_sja1105: fix MAC DA patching from meta frames
Date: Fri, 21 Jul 2023 18:03:58 +0200
Message-ID: <20230721160632.540493325@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index d43feadd5fa6b..a163f535697e1 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -100,8 +100,8 @@ static void sja1105_meta_unpack(const struct sk_buff *skb,
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



