Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DD851FCC2;
	Wed, 30 Sep 2026 18:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791211; cv=none; b=bLECeOfNBFg3x60XKl87BaW5x3EAMZMc9l5PKGdbbjO463JTC0BClNIDLoAug2KTSLtMMreDhIWDpUARU/Sc2OLY01KOM6aBjRgqPk/LpEJgWfjECpsiMxZcWfox9amAplNzG3e60Bti1KB9/GXkvEQXf615s+9aT2V4AgQQTx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791211; c=relaxed/simple;
	bh=VzFCWUT/uf0hC8nN8Net0KdNimkbzmVqCL6LnzUaWPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unB6TxCeDSSQTOZ1jO5zGjar07GO2/6M3X2B5AbZQzzh1aZFTHczvyDaTgSwonx0bgcHQbtslQVqp3ed5T6F4M70uwGRLuOMCGvdOEfMf3aOjWTNFjWbrAG1ARe9CAL5trNsj70zEZyyVeAO0/CCq/M3LM0RxexZD2xUDzR4YP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrbmS/G4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrbmS/G4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F69E1F00898;
	Wed, 30 Sep 2026 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791209;
	bh=vfIclaqK4sjIiujDnFxTbfmY1Bl4soCy73JSTUtaEZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrbmS/G4wQrHkfaDay0Hx+uQGgExjT6l9VKmKbAfG+HlZP4rg2XI+2YN7hyDY2UeU
	 ManMf1PacbOfhjMoGbXO+hHlT5JhKiazDqSCRnIPuPiWLuG8uLUgCiGqszvGT6+Vft
	 9TGghcaPvJgXeHdobLOWwJGWmdHhMZKDH8S9BAk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 5.15 220/752] ice: pass the return value of skb_checksum_help()
Date: Wed, 30 Sep 2026 17:21:30 +0200
Message-ID: <20260930152403.014816417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 2d19302f628853742c4828381abbd668c1315598 ]

skb_checksum_help() can fail. Pass its return value back to the caller.

Commonize this software path in goto.

Instead of just returning error try calculating software checksum first.
There is a check for TSO in checksum_sw_fb.

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-4-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index b09d89cdb001f..9de222ab02090 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1709,7 +1709,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			ret = ipv6_skip_exthdr(skb, exthdr - skb->data,
 					       &l4_proto, &frag_off);
 			if (ret < 0)
-				return -1;
+				goto checksum_sw_fb;
 		}
 
 		/* define outer transport */
@@ -1728,11 +1728,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			l4.hdr = skb_inner_network_header(skb);
 			break;
 		default:
-			if (first->tx_flags & ICE_TX_FLAGS_TSO)
-				return -1;
-
-			skb_checksum_help(skb);
-			return 0;
+			goto checksum_sw_fb;
 		}
 
 		/* compute outer L3 header size */
@@ -1791,7 +1787,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			ipv6_skip_exthdr(skb, exthdr - skb->data, &l4_proto,
 					 &frag_off);
 	} else {
-		return -1;
+		goto checksum_sw_fb;
 	}
 
 	/* compute inner L3 header size */
@@ -1820,15 +1816,17 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 		break;
 
 	default:
-		if (first->tx_flags & ICE_TX_FLAGS_TSO)
-			return -1;
-		skb_checksum_help(skb);
-		return 0;
+		goto checksum_sw_fb;
 	}
 
 	off->td_cmd |= cmd;
 	off->td_offset |= offset;
 	return 1;
+
+checksum_sw_fb:
+	if (first->tx_flags & ICE_TX_FLAGS_TSO)
+		return -1;
+	return skb_checksum_help(skb);
 }
 
 /**
-- 
2.53.0



