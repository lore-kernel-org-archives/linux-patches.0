Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBA7389DEC;
	Tue, 10 Mar 2026 11:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141294; cv=none; b=djaQ/vAToMSKHuDg0/OyKobpsoc+yQ1r5E8oTTr/ksr5tRbL67SAAKPLiBRPmvd9CrLaPZjpNwTyitCudED+ap58hHR3oRYWDREqj+Uwy9IzqGSejeW+FfzljwERLA4h4Zaydutd+s9Y80pKVslJEiKaMruoGRXtDeMG++jADxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141294; c=relaxed/simple;
	bh=b77evelmrioGAea7LJxU/VVceNUhyBhSI9PkT/YkNFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l01NqocioYqzLPTdFZ8AdgZzcFGq5ygTwFwh9DHvJH9eUpztcfgG0RuCrC5XH1IDqSSfRNtS3vS3Fc8EmW7pDNLwghWZmLcMaqTl5Es5yKm0ZAjboFJb8VTQTi2hdG8D0MiSIo3B+67uQOsCmeA5Lm6pqG/DxfROvzIM/9tTmtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLxt0D0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLxt0D0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8352DC2BCAF;
	Tue, 10 Mar 2026 11:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141294;
	bh=b77evelmrioGAea7LJxU/VVceNUhyBhSI9PkT/YkNFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLxt0D0wCpmGwGYrnZFbDrIwlIjYWHYotb9GcTaj8nEfXv0jls5aAiAJ1aCnpfIrA
	 T64nDUw4zHhXtSuYL9XUij5N4kjh/2P92taWmt1rt/Xvv6DxyjALmqPCRqACXHDzy/
	 swiHMc0bOd7Sa9VzvBkRe/YvBhsqYTtsoKxZKuw3RymsyPZbFBZJcpGncdIFUXtfW6
	 tTrT/3IAqu37EspYXAydoIOa9XNFPOFJsEHi9TJqCoVyCvwb9O+s1mjnWjz6lImrsz
	 3C6xP6wH7AWJdPOd8SDcYvJL1oa3ZX9SCC0+EYqLl098dL6YvkO2feEwMG861fn49e
	 7JqJvTrqebSbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 298/311] xsk: introduce helper to determine rxq->frag_size
Date: Tue, 10 Mar 2026 07:05:45 -0400
Message-ID: <abc997be2cf54492d535869cde7a9edd5726531b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index aefc368449d59..6b9ebae2dc952 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -51,6 +51,11 @@ static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
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
@@ -337,6 +342,11 @@ static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
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

