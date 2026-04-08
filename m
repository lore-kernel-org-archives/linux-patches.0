Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE6634AB06;
	Wed,  8 Apr 2026 18:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674291; cv=none; b=a06Jg0gVLoryP6X1GRyFRqcRUCXtdeJ31MeZlMaAVOgwc+yNN2pIY3RILsX9jG9JQDaihKhpesXjkvQ6/TvmlSEcypDvma2yYYom79n2lQtPePI08fTW++ux4IrAl23O7Zm6h1X2bE08wH4OFTlSLWCfREpBV8hVh4E5RXVVgfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674291; c=relaxed/simple;
	bh=gBECUvZGpH17hoiy0Ep153Y0ZjxVNWIa/JDEbG/febY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KE7D1ZV9qTuGO2RfZ0kXcc5r/WzDuJMqcXhluoF+Vdf6iG7sju3GvP1SLEXZxu5r9AXbegnWM/Q5CiL+wnTXdpXdqHYTIgcl3Pvt8f/hTdbKVsnjn4daKff7CeRba3lSev2Osbt+YQD9caaYOXv25f4PzPFISSDMxXt9I64y9gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcxrddYI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcxrddYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E336EC19421;
	Wed,  8 Apr 2026 18:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674291;
	bh=gBECUvZGpH17hoiy0Ep153Y0ZjxVNWIa/JDEbG/febY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcxrddYI4qtI3JVx/oAc2+Rp7aQtb9MWM+KPyfP8/7VM4dMLRFwF8LjwEGrzGYTX3
	 E7HEzKfoLobd/ZbKTGQ9uT2aq1mGVqWXCTMUJXG7R6vHycholEYyG2uZUvPPa1v0Ir
	 TBGb2pNllvSXo5Htc/lAnmbL9ZCxA9q1LvkJBj4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 041/311] net: mana: Fix RX skb truesize accounting
Date: Wed,  8 Apr 2026 20:00:41 +0200
Message-ID: <20260408175940.948649155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit f73896b4197ed53cf0894657c899265ef7c86b7a ]

MANA passes rxq->alloc_size to napi_build_skb() for all RX buffers.
It is correct for fragment-backed RX buffers, where alloc_size matches
the actual backing allocation used for each packet buffer. However, in
the non-fragment RX path mana allocates a full page, or a higher-order
page, per RX buffer. In that case alloc_size only reflects the usable
packet area and not the actual backing memory.

This causes napi_build_skb() to underestimate the skb backing allocation
in the single-buffer RX path, so skb->truesize is derived from a value
smaller than the real RX buffer allocation.

Fix this by updating alloc_size in the non-fragment RX path to the
actual backing allocation size before it is passed to napi_build_skb().

Fixes: 730ff06d3f5c ("net: mana: Use page pool fragments for RX buffers instead of full pages to improve memory efficiency.")
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/acLUhLpLum6qrD/N@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 14f44b71daded..215ce3443adea 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -737,6 +737,13 @@ static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
 		}
 
 		*frag_count = 1;
+
+		/* In the single-buffer path, napi_build_skb() must see the
+		 * actual backing allocation size so skb->truesize reflects
+		 * the full page (or higher-order page), not just the usable
+		 * packet area.
+		 */
+		*alloc_size = PAGE_SIZE << get_order(*alloc_size);
 		return;
 	}
 
-- 
2.53.0



