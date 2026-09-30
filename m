Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2BA51E43A;
	Wed, 30 Sep 2026 16:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784810; cv=none; b=Hoz6Yo0o/MG1TcCL5v8XLyIf+RGBRu3KQAyCNf9MgNcKFsRGgchyyXWAO8yRrEo2pU3A/VzxrAruoeGr9ejOwT3miG3+OBhIvHqSB34FvP1gwR8y6TEff6tSrhExVYNeyCeEmsO7oR1NPphRERCFZ1CqYAbzmZhsimHYY3xQxD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784810; c=relaxed/simple;
	bh=ziGjUyB7h0D/EDXuvqwFb7a5W9K9eAFMGqECdZjy0Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUwcEll3fqo+Lq/AXoipJs77B4edriRVk7IG2C/JmbNgS0iDkX5XV89ydKPJOFER8VAS596vAT3eOJihZZsulJZxXNSR9P8C1MPpeItGQ1zFjgBeoXKQ3i2zyzySXx5q5BdVKuAiC5T12HQgg1IOuUgan7z0OcXVqwo6xHZkNoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KseYAmiH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KseYAmiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F541F00893;
	Wed, 30 Sep 2026 16:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784802;
	bh=wzam/vqvfR4P7TfJwi+Mf5mZaYqWrs0LkXEWCvI352c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KseYAmiHFq5gsQ19sUKpgEbMvzQm59pRyDmSijubChhM1cYCUFAFQKgVs3hX0apaR
	 KOv2KUlK1oiNQDT3U2oh7BEfY5j5haa5gzt3Lt2JkF8suAFLY9wtKIOkH/6HxQmUqF
	 VSKU2lZ4bXLLnAdQ7TVlGVTIybZJ4ccq7L291G2A=
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
Subject: [PATCH 6.1 283/982] ice: pass the return value of skb_checksum_help()
Date: Wed, 30 Sep 2026 17:16:59 +0200
Message-ID: <20260930152422.878863383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6172e0daa718d..1d64966da1e8a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1784,7 +1784,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			ret = ipv6_skip_exthdr(skb, exthdr - skb->data,
 					       &l4_proto, &frag_off);
 			if (ret < 0)
-				return -1;
+				goto checksum_sw_fb;
 		}
 
 		/* define outer transport */
@@ -1803,11 +1803,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
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
@@ -1866,7 +1862,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			ipv6_skip_exthdr(skb, exthdr - skb->data, &l4_proto,
 					 &frag_off);
 	} else {
-		return -1;
+		goto checksum_sw_fb;
 	}
 
 	/* compute inner L3 header size */
@@ -1895,15 +1891,17 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
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



