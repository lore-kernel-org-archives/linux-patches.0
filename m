Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8A65101A;
	Mon, 11 Dec 2023 18:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YAnriJbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADDBC433C8;
	Mon, 11 Dec 2023 18:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319400;
	bh=u/QrsSg+cXLAGuUZgZz2Bn/h5JgKsjb7SnljGX1SdmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAnriJbG5QSnyeml8mRkto9+Kzf+BNtoKF28Ij9rooOJqeqBjoby2I8dnkmUnZj3m
	 bfbMBrdF3+ioCtZz8ms8W46qkKcqD0I0VQTICgG5uE1NpBcTcd4MP0V1TTswWAyExC
	 Kz6Ycgun1k7mgBZjYmWuvO8XJzN/ofHoliYeszmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/244] net: dsa: microchip: provide a list of valid protocols for xmit handler
Date: Mon, 11 Dec 2023 19:19:26 +0100
Message-ID: <20231211182049.069064984@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

[ Upstream commit 1499b89289bf272fd83cb296c82fb5519d0fe93f ]

Provide a list of valid protocols for which the driver will provide
it's deferred xmit handler.

When using DSA_TAG_PROTO_KSZ8795 protocol, it does not provide a
"connect" method, therefor ksz_connect() is not allocating ksz_tagger_data.

This avoids the following null pointer dereference:
 ksz_connect_tag_protocol from dsa_register_switch+0x9ac/0xee0
 dsa_register_switch from ksz_switch_register+0x65c/0x828
 ksz_switch_register from ksz_spi_probe+0x11c/0x168
 ksz_spi_probe from spi_probe+0x84/0xa8
 spi_probe from really_probe+0xc8/0x2d8

Fixes: ab32f56a4100 ("net: dsa: microchip: ptp: add packet transmission timestamping")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20231206071655.1626479-1-sean@geanix.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 42db7679c3606..286e20f340e5c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2624,10 +2624,18 @@ static int ksz_connect_tag_protocol(struct dsa_switch *ds,
 {
 	struct ksz_tagger_data *tagger_data;
 
-	tagger_data = ksz_tagger_data(ds);
-	tagger_data->xmit_work_fn = ksz_port_deferred_xmit;
-
-	return 0;
+	switch (proto) {
+	case DSA_TAG_PROTO_KSZ8795:
+		return 0;
+	case DSA_TAG_PROTO_KSZ9893:
+	case DSA_TAG_PROTO_KSZ9477:
+	case DSA_TAG_PROTO_LAN937X:
+		tagger_data = ksz_tagger_data(ds);
+		tagger_data->xmit_work_fn = ksz_port_deferred_xmit;
+		return 0;
+	default:
+		return -EPROTONOSUPPORT;
+	}
 }
 
 static int ksz_port_vlan_filtering(struct dsa_switch *ds, int port,
-- 
2.42.0



