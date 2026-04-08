Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3343A3D6694;
	Wed,  8 Apr 2026 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672915; cv=none; b=dIFQMf6cQOtoYXvRmuCE+5NpVFjTaVI/5O4kUCYxtCm9fT3SF0f0cYOIl+C2tOV992AVG1TH/IQWmGIt7z2aBCDsHPZ97LIyt7hweu0utkV45qIIlTWRuwBn4GX1SU+/jQIAp8ISWsHM79lIG9W7J2+ditRNwcu7DNo3CVPB6eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672915; c=relaxed/simple;
	bh=YIMUXrUoZ6sOEMN5N6gbXPf4pi4DLKWcPQQmM2SCIyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GBxa3NVwzRnvDYJ3ak/O/qZIqMCx7AhRbgIn5CR/Q8ResmNui8YbHiszGXLTu9VKYbov6e2U+Wz/fc/aefay9muzNa2SbXinP3fQrqHUMlk+uAAGDpdSNoIRDcd0oRA6ONkQ0uIovqUpoiUZ+0OzwYznk/vjPm2xazGIEl5xwvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1wdi/R6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1wdi/R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7EBC19421;
	Wed,  8 Apr 2026 18:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672914;
	bh=YIMUXrUoZ6sOEMN5N6gbXPf4pi4DLKWcPQQmM2SCIyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1wdi/R6ztFkK/xp3RYhspRM0Wbay5XHzkQ2PtQMvH2We3dhxoP2EPs0wnWtoRdi3
	 3xY5D+MKeVck8HBffIu9CFzfOgA3jbU3/PVe9sFVSdAlY2niGBHlhrp4ioEZOlFWNr
	 O2RQaZgCNsgr+97/eWl6iNO6rJjGD08JlYMJOyvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/277] net: mana: Fix RX skb truesize accounting
Date: Wed,  8 Apr 2026 20:00:14 +0200
Message-ID: <20260408175934.940387021@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 50d4437a518fd..8e72cb6ccbc18 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -660,6 +660,13 @@ static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
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



