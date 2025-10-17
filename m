Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7FA3BB5A;
	Fri, 17 Oct 2025 15:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714504; cv=none; b=GTpP4jC02knJdBNGxSnOahv5YKggen52Q95IrzCJXHAtPspW4Z+/zDFdmOkC7+JqusthJu+KiYJRr5FBHd9RqTWZwacl8DhZQT8Um9CuA7MwRKuKP5QUGycOsFGm6MDELiF/GA+/OkLfXubMrqOYfwCnadByBVppwQwAhFWOQTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714504; c=relaxed/simple;
	bh=C2hHx08eUavXEE/C1Y62sF3NgzBVJzvIfjDGlAZre6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GokHr0FUz1TnhVcyL24qajijABjdJfpD6wWl3v/BM/rsDN9GzI0hTCUHUnCW5IvImB5qnbFBehb9cb2e6+NFmgJ3zA6kWsYwdBRJb6RoP8GW3Nj0eeJjBNTr05skYTeAY5nmuwSQ0h/r40HrtBQZ1QrfczskguE8q+/i/mVJ7/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtdPHYtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtdPHYtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1DAC4CEE7;
	Fri, 17 Oct 2025 15:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714504;
	bh=C2hHx08eUavXEE/C1Y62sF3NgzBVJzvIfjDGlAZre6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtdPHYtE1FV1Glc/+nktI4U7LhJPhCgF1VFp9ZsNrfSvK2CsZKe48bVnNvUBBnh3w
	 LhbbrlTckARI9VFhUtOk8ufJU4n0YNm0xcnK3bBFCuosOkngrm4gdYAVymjKX+1PmN
	 p45I9dGUSdW9L4KOo8PcXYm1uWA3gEG+As/BC1gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.12 167/277] xsk: Harden userspace-supplied xdp_desc validation
Date: Fri, 17 Oct 2025 16:52:54 +0200
Message-ID: <20251017145153.225231604@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

commit 07ca98f906a403637fc5e513a872a50ef1247f3b upstream.

Turned out certain clearly invalid values passed in xdp_desc from
userspace can pass xp_{,un}aligned_validate_desc() and then lead
to UBs or just invalid frames to be queued for xmit.

desc->len close to ``U32_MAX`` with a non-zero pool->tx_metadata_len
can cause positive integer overflow and wraparound, the same way low
enough desc->addr with a non-zero pool->tx_metadata_len can cause
negative integer overflow. Both scenarios can then pass the
validation successfully.
This doesn't happen with valid XSk applications, but can be used
to perform attacks.

Always promote desc->len to ``u64`` first to exclude positive
overflows of it. Use explicit check_{add,sub}_overflow() when
validating desc->addr (which is ``u64`` already).

bloat-o-meter reports a little growth of the code size:

add/remove: 0/0 grow/shrink: 2/1 up/down: 60/-16 (44)
Function                                     old     new   delta
xskq_cons_peek_desc                          299     330     +31
xsk_tx_peek_release_desc_batch               973    1002     +29
xsk_generic_xmit                            3148    3132     -16

but hopefully this doesn't hurt the performance much.

Fixes: 341ac980eab9 ("xsk: Support tx_metadata_len")
Cc: stable@vger.kernel.org # 6.8+
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20251008165659.4141318-1-aleksander.lobakin@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk_queue.h |   45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -143,14 +143,24 @@ static inline bool xp_unused_options_set
 static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
 					    struct xdp_desc *desc)
 {
-	u64 addr = desc->addr - pool->tx_metadata_len;
-	u64 len = desc->len + pool->tx_metadata_len;
-	u64 offset = addr & (pool->chunk_size - 1);
+	u64 len = desc->len;
+	u64 addr, offset;
 
-	if (!desc->len)
+	if (!len)
 		return false;
 
-	if (offset + len > pool->chunk_size)
+	/* Can overflow if desc->addr < pool->tx_metadata_len */
+	if (check_sub_overflow(desc->addr, pool->tx_metadata_len, &addr))
+		return false;
+
+	offset = addr & (pool->chunk_size - 1);
+
+	/*
+	 * Can't overflow: @offset is guaranteed to be < ``U32_MAX``
+	 * (pool->chunk_size is ``u32``), @len is guaranteed
+	 * to be <= ``U32_MAX``.
+	 */
+	if (offset + len + pool->tx_metadata_len > pool->chunk_size)
 		return false;
 
 	if (addr >= pool->addrs_cnt)
@@ -158,27 +168,42 @@ static inline bool xp_aligned_validate_d
 
 	if (xp_unused_options_set(desc->options))
 		return false;
+
 	return true;
 }
 
 static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
 					      struct xdp_desc *desc)
 {
-	u64 addr = xp_unaligned_add_offset_to_addr(desc->addr) - pool->tx_metadata_len;
-	u64 len = desc->len + pool->tx_metadata_len;
+	u64 len = desc->len;
+	u64 addr, end;
 
-	if (!desc->len)
+	if (!len)
 		return false;
 
+	/* Can't overflow: @len is guaranteed to be <= ``U32_MAX`` */
+	len += pool->tx_metadata_len;
 	if (len > pool->chunk_size)
 		return false;
 
-	if (addr >= pool->addrs_cnt || addr + len > pool->addrs_cnt ||
-	    xp_desc_crosses_non_contig_pg(pool, addr, len))
+	/* Can overflow if desc->addr is close to 0 */
+	if (check_sub_overflow(xp_unaligned_add_offset_to_addr(desc->addr),
+			       pool->tx_metadata_len, &addr))
+		return false;
+
+	if (addr >= pool->addrs_cnt)
+		return false;
+
+	/* Can overflow if pool->addrs_cnt is high enough */
+	if (check_add_overflow(addr, len, &end) || end > pool->addrs_cnt)
+		return false;
+
+	if (xp_desc_crosses_non_contig_pg(pool, addr, len))
 		return false;
 
 	if (xp_unused_options_set(desc->options))
 		return false;
+
 	return true;
 }
 


