Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C80119E7C8;
	Tue, 16 Jul 2024 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145366; cv=none; b=nxfWGITE4/imrmmbTJ8lTQSa+xjbeoevCj6PUWb9T00lZqZXPIOHyZeEDuJ8Mm20DX1tuPxlYDQFT8H9EEhqpL1z5FOsL8dIYu2yI0bxTR4tmRqpjFwCj8YWt7aRFBEo8qAogwCASdBcB05/oTpgxbl20K4wdmQwAtA2uVYfrjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145366; c=relaxed/simple;
	bh=NqbJx1NA4NSwmSKeXCnsmaxWFooRlOSp8ifSEbQueEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckBEJX5RALNghl9QsZ52jnxWVVhlcsENjlgMCPdC3UbeqRUSxHtknkSTeyWKKUrOv0nBCPQAA+XHSjf7fPBWbLneerEVWRViw75QrKx4sRjiJk0QLKxxSjeqnzO7Rh+otGHOkNPlluEZEZKv0pm5L0uUA0axo5ziaG8nkplLjrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsZCGWyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsZCGWyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47F0C116B1;
	Tue, 16 Jul 2024 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145366;
	bh=NqbJx1NA4NSwmSKeXCnsmaxWFooRlOSp8ifSEbQueEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsZCGWyrMcfgoGjUmfHEhUir9hb074a1iZYJgJoo/lyhShVhhm2wNxm9EKOE+av8a
	 8IDNLzVx2gEFK1sEOiD/U2KlILWXr1H8UcWWNGWHq2/NE5XYP6awesyxKMzyU7F6yt
	 r8khOW+dQauOa1FSs/MS2OwtMG9+pq+X6ngolr6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satheesh Paul <psatheesh@marvell.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 43/96] octeontx2-af: fix issue with IPv4 match for RSS
Date: Tue, 16 Jul 2024 17:31:54 +0200
Message-ID: <20240716152748.164394897@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Satheesh Paul <psatheesh@marvell.com>

[ Upstream commit 60795bbf047654c9f8ae88d34483233a56033578 ]

While performing RSS based on IPv4, packets with
IPv4 options are not being considered. Adding changes
to match both plain IPv4 and IPv4 with option header.

Fixes: 41a7aa7b800d ("octeontx2-af: NIX Rx flowkey configuration for RSS")
Signed-off-by: Satheesh Paul <psatheesh@marvell.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8be809aa72a95..ef526408b0bd2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3356,6 +3356,8 @@ static int get_flowkey_alg_idx(struct nix_hw *nix_hw, u32 flow_cfg)
 
 /* Mask to match ipv6(NPC_LT_LC_IP6) and ipv6 ext(NPC_LT_LC_IP6_EXT) */
 #define NPC_LT_LC_IP6_MATCH_MSK ((~(NPC_LT_LC_IP6 ^ NPC_LT_LC_IP6_EXT)) & 0xf)
+/* Mask to match both ipv4(NPC_LT_LC_IP) and ipv4 ext(NPC_LT_LC_IP_OPT) */
+#define NPC_LT_LC_IP_MATCH_MSK  ((~(NPC_LT_LC_IP ^ NPC_LT_LC_IP_OPT)) & 0xf)
 
 static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 {
@@ -3426,7 +3428,7 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 			field->hdr_offset = 9; /* offset */
 			field->bytesm1 = 0; /* 1 byte */
 			field->ltype_match = NPC_LT_LC_IP;
-			field->ltype_mask = 0xF;
+			field->ltype_mask = NPC_LT_LC_IP_MATCH_MSK;
 			break;
 		case NIX_FLOW_KEY_TYPE_IPV4:
 		case NIX_FLOW_KEY_TYPE_INNR_IPV4:
@@ -3453,8 +3455,7 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 					field->bytesm1 = 3; /* DIP, 4 bytes */
 				}
 			}
-
-			field->ltype_mask = 0xF; /* Match only IPv4 */
+			field->ltype_mask = NPC_LT_LC_IP_MATCH_MSK;
 			keyoff_marker = false;
 			break;
 		case NIX_FLOW_KEY_TYPE_IPV6:
-- 
2.43.0



