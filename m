Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23794F68A7;
	Wed, 30 Sep 2026 15:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782808; cv=none; b=Ae7CCf9kGRFpQmoDAixJggK+IlL/zPKYUZ2Sw/IMcSd7BjEcelJNdHb/zvL5yvSdFoxy5KEsfdJBHLuGqWlI3y0cGA8D0ub08N6sQU8MOSa89g2GfxSvWx3VqFx6Dn/CYImThiIi/rynqV8D/yIxU4tDk4GuwgNLtjpI/luLs3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782808; c=relaxed/simple;
	bh=v3qKhVq91mSaaT+rz4/kUPVrORHj/IkSIW4IrNuniB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7zqswM/i4tciKOtGTO2zJeTekazUL/JQjBgNrOKNYinGBDQOVrLQly2uqMlUUPRw4+msLZQjI+4Kp2lhqhO26uOO0ZGgNElIHIIYR9enQ6gKLgLH4KxCr4JLgiasTJxGjFZb9rFKmGaOxumbRY0SutJZuIP2yxPw6bCSfpH7Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3npgKVY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3npgKVY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35D01F000FF;
	Wed, 30 Sep 2026 15:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782803;
	bh=UJyEvpSGBnWTmaiIDHu1rZKnDqFzzeX6W+3cijuecOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u3npgKVYOplEO38PQUIby290o8yGM70NGv9r8hR0pQSYlkzRtRaQU996xhlhRQKkp
	 VsaOZ0l+QEC0Qm97kx2vfDEpeLdnMe0uYbEKQF8rNZBVztA1QGMksj5O3YvMGK8k3+
	 tzXgTwl/AhNN2bzNWa6SQyp0cQC1i0PLcLSq5TLE=
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
Subject: [PATCH 5.10 176/595] ice: pass the return value of skb_checksum_help()
Date: Wed, 30 Sep 2026 17:21:09 +0200
Message-ID: <20260930152351.525966592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7734264d570db..0d5568a36cdd9 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1932,7 +1932,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			ret = ipv6_skip_exthdr(skb, exthdr - skb->data,
 					       &l4_proto, &frag_off);
 			if (ret < 0)
-				return -1;
+				goto checksum_sw_fb;
 		}
 
 		/* define outer transport */
@@ -1951,11 +1951,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
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
@@ -2014,7 +2010,7 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
 			ipv6_skip_exthdr(skb, exthdr - skb->data, &l4_proto,
 					 &frag_off);
 	} else {
-		return -1;
+		goto checksum_sw_fb;
 	}
 
 	/* compute inner L3 header size */
@@ -2043,15 +2039,17 @@ int ice_tx_csum(struct ice_tx_buf *first, struct ice_tx_offload_params *off)
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



