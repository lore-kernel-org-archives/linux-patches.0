Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8571C8FCF;
	Tue, 27 Aug 2024 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772462; cv=none; b=l58DoPsIFsyuAyqkNlq7QqrWPFygIHRV0mWZ1v6rX+y9xPcBQJyuASfFka8/UnqgvrxbUf5n5oYKFt0dPbLk+eYBplyfu36pcJ5nfNr0pBPKNYy1cPKx2iOz4AdZwuk9PLYweWta0Xbw+jq/MJOrwjTt/2yiW6OrvOeXGbRuerQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772462; c=relaxed/simple;
	bh=nx6UUy4fP+XfUQwc0LG7Pj7s5iw3vLG9ZnsUwdmbdt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBKflX/VGf60zYpAeX7hv+wSW7nmYmjTUhlwVnJiCFaXznolN3vLn0g0U3C1gKHeBQyd+vmVCLuejvVnBuaDK2Rz1b9aTbmoST2r5xtuDnxvAuDH53ltzj/DIIIAq67DUbJF2YLtOXJFCFimbkPkd9cKmjLcxuO0s45jzPQjLps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HCg8FcV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HCg8FcV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E37CC61040;
	Tue, 27 Aug 2024 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772462;
	bh=nx6UUy4fP+XfUQwc0LG7Pj7s5iw3vLG9ZnsUwdmbdt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HCg8FcV3w1pr7CxwIQgXCjxkZuDsvjAo/kv9Qx36tQtUx/rrl8qGChOhzv90nt9BG
	 ylTBbEqm3Wu0xZinOPfj4lt5ueUzfK7KqG8dSoSXF4uRlJQ8Ex/8F3Kml4vo+zC1Ob
	 E8x5OGv+I+b1hBlh9cQMreUu03/pQ61pK06nKUFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 222/321] net: dsa: tag_ocelot: do not rely on skb_mac_header() for VLAN xmit
Date: Tue, 27 Aug 2024 16:38:50 +0200
Message-ID: <20240827143846.682524476@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit eabb1494c9f20362ae53a9991481a1523be4f4b7 ]

skb_mac_header() will no longer be available in the TX path when
reverting commit 6d1ccff62780 ("net: reset mac header in
dev_start_xmit()"). As preparation for that, let's use
skb_vlan_eth_hdr() to get to the VLAN header instead, which assumes it's
located at skb->data (assumption which holds true here).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 67c3ca2c5cfe ("net: mscc: ocelot: use ocelot_xmit_get_vlan_info() also for FDMA and register injection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_ocelot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 0d81f172b7a6e..afca3cdf190a0 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -22,7 +22,7 @@ static void ocelot_xmit_get_vlan_info(struct sk_buff *skb, struct dsa_port *dp,
 		return;
 	}
 
-	hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
+	hdr = skb_vlan_eth_hdr(skb);
 	br_vlan_get_proto(br, &proto);
 
 	if (ntohs(hdr->h_vlan_proto) == proto) {
-- 
2.43.0



