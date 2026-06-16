Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F5943C05C;
	Tue, 16 Jun 2026 15:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622953; cv=none; b=YNeNnZmdfG2Y6iL7zrwQdjqy3OPXFZSQ66HWooPxcyDYS+TuaEVZq3VK0rsUnrvihBzaJj9+9cetMvtCAMHzQARTLRjur4q9KprBHlJtqGM9Xc5qsXM3qgbjttzaofgMPL1mhRTHyfAjzuVB2yhVegyiOVRb35RIGHsrHSzGGuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622953; c=relaxed/simple;
	bh=Vev5D5WxPrgoIflDjFJVE2S2TFPEBvpdzfUFpAB8XA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rz9fvuGKykd1P5WN8GYPeitmg4w9tqv7kNtlqxw2UzVTzzPW10Fhqj6xoqC7s4UzWcBNuLBkkvgLXwRuhs+8BN70A/wdkDOpzojx3HZd/eMqzNdPll6ssEJgt9HOhE3aqvE2czocHLRkLuFEjWWDERWvB9So3XZA+E6/cL/7y4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xq9MrsDX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xq9MrsDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E671F000E9;
	Tue, 16 Jun 2026 15:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622952;
	bh=/nkfXItGo3mU71rFEU2P0OmJYyx53vR2Mls3ruX5O44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xq9MrsDX3+kUOx2/S5yX6ZGc3U/i2JWZxACVaN4+u2BJRKgCInCJuFWxI0y2s71ch
	 tecnt687Zr5rdFvc8OK/hzSnGd+qNA5t0WWU8zX9dVGVjccqHKbBVaRriRhrnI3VRN
	 hYzfF32xE4asd58gNnkhTt+oNgXodrG5Sx+srQQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 060/378] net: airoha: Fix use-after-free in metadata dst teardown
Date: Tue, 16 Jun 2026 20:24:51 +0530
Message-ID: <20260616145113.143130118@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit b38cae85d1c45ff189d7ecb6ac36f41cdc3d84d0 ]

airoha_metadata_dst_free() runs metadata_dst_free() which frees the
metadata_dst with kfree() immediately, bypassing the RCU grace period.
In the RX path, skb_dst_set_noref() sets a non-refcounted pointer from
the skb to the metadata_dst. This function requires RCU read-side
protection and the dst must remain valid until all RCU readers complete.
Since metadata_dst_free() calls kfree() directly, an use-after-free can
occur if any skb still holds a noref pointer to the dst when the driver
tears it down.
Replace metadata_dst_free() with dst_release() which properly goes
through the refcount path: when the refcount drops to zero, it schedules
the actual free via call_rcu_hurry(), ensuring all RCU readers have
completed before the memory is freed.

Fixes: af3cf757d5c9 ("net: airoha: Move DSA tag in DMA descriptor")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260602-airoha-mtk-metadata-uaf-fix-v1-1-3aaa99d83351@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 13f74335928660..698a305ca694c6 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2935,7 +2935,7 @@ static void airoha_metadata_dst_free(struct airoha_gdm_port *port)
 		if (!port->dsa_meta[i])
 			continue;
 
-		metadata_dst_free(port->dsa_meta[i]);
+		dst_release(&port->dsa_meta[i]->dst);
 	}
 }
 
-- 
2.53.0



