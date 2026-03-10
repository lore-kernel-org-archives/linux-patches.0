Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ED74508E9;
	Tue, 10 Mar 2026 11:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142215; cv=none; b=K6yGjYFZRhWZdMXSQO2F1P2XFgdKJwyJ6eEraC4SroGyjk7bEMGxDWnfkA/lv/AIqnMQ1jRsz25d25bONnaRULKDUNdf+feZl4Dshyct+GLCF3y5CYzGtQl6jl+MducWqT7Mlazj/DQlLDgYxYngAlCjfTMV9O13TsOJv1jdDVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142215; c=relaxed/simple;
	bh=pHGavqJpUbgltSVW4Eo1yqGN21DOqo7rvnLzC0/Bg6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBdfqqvTVZ2FN3wF6YxYULvTnCiB/THlG3y5YPK7WEJ64YVbxV1vioK3OKzJVsCX+Q10u4YZ+jKcg26nJrlZC6ZxlYqg0ncN57dOrnYTz/PZ9EnAJEidrpnSRsU8/I/RPUggYBCreLwyHVQMtmtRmvngN6fIUgJHjRxvGySNcwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FdgAQueJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FdgAQueJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A131EC2BC9E;
	Tue, 10 Mar 2026 11:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142215;
	bh=pHGavqJpUbgltSVW4Eo1yqGN21DOqo7rvnLzC0/Bg6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdgAQueJkMbLCYZi6Yr6wxJw+k6i1rHIhYJdKCuS7l4hPITLn3FuAULgYqjn55+Pw
	 5ra8hokX1h3VZmio8Dfs7I8puU+QvEP/e5BlPuocqXrFMAN7/naUhv1KTDkdoPRjUn
	 5OeuUXjHSBcQRE43+79BEaUQxXfF+VjuhKbziqDP6Ka74NC04f2xE2X5W8KRqFJHKo
	 MOGeXkQKtpZIoyvKBbEOZ0Q/Pa3I2NWQsEYv3UuScg/HGvnBj2wxIqgnC61aZdoLga
	 ZOAb2neZUANq5as0E9ytE+nHbOZKVD7mMXlBqiVI8n8MFtEycEp7XGc6fJKP1zYOUq
	 yXSqjR0aLl8PA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 305/314] xsk: introduce helper to determine rxq->frag_size
Date: Tue, 10 Mar 2026 07:19:24 -0400
Message-ID: <e19aca756e4c34552ced0237fa3950f329ac0085.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 99b6c3358e363..33e072768de9d 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -47,6 +47,11 @@ static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
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
@@ -333,6 +338,11 @@ static inline u32 xsk_pool_get_rx_frame_size(struct xsk_buff_pool *pool)
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

