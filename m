Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAA5DDC5;
	Mon, 23 Mar 2026 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278038; cv=none; b=Meqm+worQVB/XrmCo1Lng/JADqgI98uqesTfsTOfEvevwYKjQwmKg95BHqhKtezyEfiVrplBuszkLq24+i6FkUObIgxF6ICKX1hYe4tbfodf/EvE0J2Bn8msEk0YLu8kcP125nbt51lTSPa7pD4zswj7tdWQ44auytkWS9Im8k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278038; c=relaxed/simple;
	bh=6KL2A92kyu6E97S2bTd6HbpwO0KpHIeQ1DUB82xpPNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiIGx8035K1ti4PB39nWZ4RLZ9HtWxNUSEsiSocB9XEfWSTSBPUo9rCbmkkhiBPcinom1yGX58Orygk1HvKaYuZBhgytrZdxvJb2OfFllI/uLU3lamsjgAygbcQZAhBas+v1i6H1nJUKx0QcEcCf5bM68OtvGn6Qm08+RqoFIlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btZEx8pG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btZEx8pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EECC4CEF7;
	Mon, 23 Mar 2026 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278038;
	bh=6KL2A92kyu6E97S2bTd6HbpwO0KpHIeQ1DUB82xpPNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btZEx8pGW2ANzgH5czb3flz5eW42n5OYRamzhgJojwnOk6er2Oq1KSNlNz1cM709q
	 CZ/Npp5JUCn/qjFXLgVo6OoUXoEnZ8XQwyZamLQjKwJPV5nJ+79dZ80nibhxa9G+eW
	 dW13rjoCkaq9rMDYD/PrEqPJlzXJmukrdFdZpLq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/567] xsk: introduce helper to determine rxq->frag_size
Date: Mon, 23 Mar 2026 14:41:39 +0100
Message-ID: <20260323134538.273178581@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 16394d80539937d348dd3b9ea32415c54e67a81b ]

rxq->frag_size is basically a step between consecutive strictly aligned
frames. In ZC mode, chunk size fits exactly, but if chunks are unaligned,
there is no safe way to determine accessible space to grow tailroom.

Report frag_size to be zero, if chunks are unaligned, chunk_size otherwise.

Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20260305111253.2317394-3-larysa.zaremba@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 91339ffd2f2a8..7dc08a4646242 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -41,6 +41,11 @@ static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
 	return xsk_pool_get_chunk_size(pool) - xsk_pool_get_headroom(pool);
 }
 
+static inline u32 xsk_pool_get_rx_frag_step(struct xsk_buff_pool *pool)
+{
+	return pool->unaligned ? 0 : xsk_pool_get_chunk_size(pool);
+}
+
 static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
 					 struct xdp_rxq_info *rxq)
 {
@@ -263,6 +268,11 @@ static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
 	return 0;
 }
 
+static inline u32 xsk_pool_get_rx_frag_step(struct xsk_buff_pool *pool)
+{
+	return 0;
+}
+
 static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
 					 struct xdp_rxq_info *rxq)
 {
-- 
2.51.0



