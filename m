Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49041DDCE;
	Tue, 16 Jul 2024 16:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145684; cv=none; b=tIMAehkk/VQh9hOBnII4ibuua5vg7kYR3cgx8/VSo8/E0meGl2hv2MembYQR+1D63Z2n+X681U1yofDCgo+IZAzgVcSjb2ibcbPfZY6NlqdJBqo2oT1s3P1X7t04ZS79ES8JVBgCx/gmqmip6KveW+fL0kDEqzeiX9krsfgYHZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145684; c=relaxed/simple;
	bh=zbUq7AyNHpsVZ28p3NRWDYt2x/A8zevK36QxKiohzqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcVbCOknGn2Cwkbr/NBJHT+rrJW08M0CYF2oC/PFh4N9e+4Cc8GPPA1G4jyRx+KtDJYszf/ptwkoRTrfPcCe+nwnnXDrHgxIKbyVaRKjeOJLoKXccxK5S0WMSsNLBC3tEwxhEBjGZY9POVDAWCkASz+Ndig1fS+Bza5xM40pPVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuyS+srp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuyS+srp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38287C4AF0D;
	Tue, 16 Jul 2024 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145684;
	bh=zbUq7AyNHpsVZ28p3NRWDYt2x/A8zevK36QxKiohzqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JuyS+srppE5Of1WwrMPHcIbfd6HFZFEboow0UAE/KBd6dCnqFFhONTciP5lG0l6N4
	 jWX/NN4XPq57F0J3PHpv0tMMwqLViRLb4XKtnLo5UqKcN7EYPMhnAb4bW5Xf2vX0LX
	 ri6OORD4Cs6FE/t2i4IHaz3wOwLn9BbDBRQEjxqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran Kumar K <kirankumark@marvell.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 049/121] octeontx2-af: fix issue with IPv6 ext match for RSS
Date: Tue, 16 Jul 2024 17:31:51 +0200
Message-ID: <20240716152753.211288081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Kiran Kumar K <kirankumark@marvell.com>

[ Upstream commit e23ac1095b9eb8ac48f98c398d81d6ba062c9b5d ]

While performing RSS based on IPv6, extension ltype
is not being considered. This will be problem for
fragmented packets or packets with extension header.
Adding changes to match IPv6 ext header along with IPv6
ltype.

Fixes: 41a7aa7b800d ("octeontx2-af: NIX Rx flowkey configuration for RSS")
Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index f6f6d7c04e8bf..e7ef07f1f0bb9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3517,6 +3517,9 @@ static int get_flowkey_alg_idx(struct nix_hw *nix_hw, u32 flow_cfg)
 	return -ERANGE;
 }
 
+/* Mask to match ipv6(NPC_LT_LC_IP6) and ipv6 ext(NPC_LT_LC_IP6_EXT) */
+#define NPC_LT_LC_IP6_MATCH_MSK ((~(NPC_LT_LC_IP6 ^ NPC_LT_LC_IP6_EXT)) & 0xf)
+
 static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 {
 	int idx, nr_field, key_off, field_marker, keyoff_marker;
@@ -3643,7 +3646,7 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 					field->bytesm1 = 15; /* DIP,16 bytes */
 				}
 			}
-			field->ltype_mask = 0xF; /* Match only IPv6 */
+			field->ltype_mask = NPC_LT_LC_IP6_MATCH_MSK;
 			break;
 		case NIX_FLOW_KEY_TYPE_TCP:
 		case NIX_FLOW_KEY_TYPE_UDP:
-- 
2.43.0



