Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8F943DA3C;
	Tue, 16 Jun 2026 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622922; cv=none; b=R1xEwSebP6kjw2CX9snE6ZTT9PIzAjL1onyEYUHMRwwNx8h/jtZ7G7fHbe0EPp1RqteZ/D6PZ0I9ElXPAxkbDlnFJdorkxtTcjapHXqAijgljAJd4eJ5e5aubYnlH8N532eZ2zrmoeYNzDpswqLLp89u5+sce9qRgSPTJTgTnZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622922; c=relaxed/simple;
	bh=FnRWYE8hDdS77W+Cl5+D5L6B3q/IMDL4HiZsfxrJmI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vc2EOdZBeED3t09d2Oay7JlIWXdBMTKx6RxTJjoBDOe5ynHo/lj4rtetV/O+CFz5+eqrlYW0V+lpv7K37ZJKvF6Wu5QaPi0ueIKSVDbBZpigVBbG/FOlkP3VK7kC3lB+ul2HsTs7p0AlTg08ZvIz86sEiTnbgCuie4axPV43QMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=medrpKqU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="medrpKqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BF51F000E9;
	Tue, 16 Jun 2026 15:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622921;
	bh=QKkucpbCndOq2fEKqsL0YtIvdDhr+E5lDFZxJ0Ux/Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=medrpKqUrGSEzKB2nRG8hLwJOg3c8gp1gjmyxFPhAusMEeyeUNoV8Gs5O8QyOo65+
	 n5G5Jkva+TRPIS6rCrSsERdO12d2NacNIjgrXrPzyVFG9dZN5Nz2HtIkiMR+D3J9jQ
	 YvdE+YRnd4jcmZ1+3TSWplTiqG9zhkWP+UGRN3bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jason Xing <kernelxing@tencent.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 054/378] xsk: cache csum_start/csum_offset to fix TOCTOU in xsk_skb_metadata()
Date: Tue, 16 Jun 2026 20:24:45 +0530
Message-ID: <20260616145112.808301530@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 22ba97ea9cc1f63a0d0244fae38057ed452b6ac7 ]

The TX metadata area resides in the UMEM buffer which is memory-mapped
and concurrently writable by userspace. In xsk_skb_metadata(),
csum_start and csum_offset are read from shared memory for bounds
validation, then read again for skb assignment. A malicious userspace
application can race to overwrite these values between the two reads,
bypassing the bounds check and causing out-of-bounds memory access
during checksum computation in the transmit path.

Fix this by reading csum_start and csum_offset into local variables
once, then using the local copies for both validation and assignment.

Note that other metadata fields (flags, launch_time) and the cached
csum fields may be mutually inconsistent due to concurrent userspace
writes, but this is benign: the only security-critical invariant is
that each field's validated value is the same one used, which local
caching guarantees.

Closes: https://lore.kernel.org/all/20260503200927.73EA1C2BCB4@smtp.kernel.org/
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Fixes: 48eb03dd2630 ("xsk: Add TX timestamp and TX checksum offload support")
Link: https://patch.msgid.link/20260530042630.80626-1-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index c8ef9e427c9cd5..db0fb2203af63c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -683,6 +683,7 @@ static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
 			    u32 hr)
 {
 	struct xsk_tx_metadata *meta = NULL;
+	u16 csum_start, csum_offset;
 
 	if (unlikely(pool->tx_metadata_len == 0))
 		return -EINVAL;
@@ -692,13 +693,15 @@ static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
 		return -EINVAL;
 
 	if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM) {
-		if (unlikely(meta->request.csum_start +
-			     meta->request.csum_offset +
+		csum_start = READ_ONCE(meta->request.csum_start);
+		csum_offset = READ_ONCE(meta->request.csum_offset);
+
+		if (unlikely(csum_start + csum_offset +
 			     sizeof(__sum16) > desc->len))
 			return -EINVAL;
 
-		skb->csum_start = hr + meta->request.csum_start;
-		skb->csum_offset = meta->request.csum_offset;
+		skb->csum_start = hr + csum_start;
+		skb->csum_offset = csum_offset;
 		skb->ip_summed = CHECKSUM_PARTIAL;
 
 		if (unlikely(pool->tx_sw_csum)) {
-- 
2.53.0



