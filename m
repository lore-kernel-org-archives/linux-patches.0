Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37735478E57;
	Sat, 12 Sep 2026 11:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213073; cv=none; b=TemTJIHFwDmwCn+2A1nJpB2b7bEeD2SsrTFUyhJx2Z+euERDC4b3JGAvP3grM4GEWgW6CH621w2sngM6yiVm5sQ2SrTMX+6gNFgKaecfMr3oLsUbJnnmnSHV4YGbdjZtKRn9LMfnJXUEkqYkxGi7ojVMG6aoB7psKzg7RKFq6EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213073; c=relaxed/simple;
	bh=JvAZLIXPlONUYeISrnQFsa4Tv8LQlCqGUtbjMqJSF5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncmWfT7Osvjl+m9XGZfhM2GF/+ijTFjCjhX8aLjeNHjn/PKZftDgbfEH6TiRh0fZIW+GWg5hj5hlm8JMXQF2bAgCi4BTaBgxRiUnpYrB+vzHH7Khc1Ik1o3KqOollq7lU81FrWU/TjUjJH00Py1IsuIgvuAQZ+iebJyJYJ33M7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scCFAE+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scCFAE+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E511F000FF;
	Sat, 12 Sep 2026 11:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213071;
	bh=QwfVfGoLuM+F9Ar/zsM6Zp+Act80R7+Ay1XfFaNRHZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=scCFAE+foym2VYyjKo2AUugtIfEMDkS9381x6WDz0caW+ixpaC9qMskzHHutgTL6j
	 Pt3AqnYKmbrQ9/3sjLjcCjwRE27CW516o/UVGAYWVPHeR1bKkK64I8hJ3pGO8TJ1yp
	 dtWRz58rTF7U9qxrEY+MeL1TcYQOc0OkqL/QsJQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jason Xing <kernelxing@tencent.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Suraj Jitindar Singh <surajjs@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0005/1376] xsk: cache csum_start/csum_offset to fix TOCTOU in xsk_skb_metadata()
Date: Sat, 12 Sep 2026 08:40:31 +0200
Message-ID: <20260912065607.667647307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

commit 22ba97ea9cc1f63a0d0244fae38057ed452b6ac7 upstream.

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
[ 6.12: Apply fix in xsk_build_skb() since missing patch
	30c3055f9c0d ("xsk: wrap generic metadata handling onto separate
	function") added in v6.18 which moves handling to separate
	function xsk_skb_metadata(). ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index da7e11e3bfad2..76675ce70f03d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -665,6 +665,7 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 	struct xsk_tx_metadata *meta = NULL;
 	struct net_device *dev = xs->dev;
 	struct sk_buff *skb = xs->skb;
+	u16 csum_start, csum_offset;
 	bool first_frag = false;
 	int err;
 
@@ -733,15 +734,17 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 			}
 
 			if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM) {
-				if (unlikely(meta->request.csum_start +
-					     meta->request.csum_offset +
+				csum_start = READ_ONCE(meta->request.csum_start);
+				csum_offset = READ_ONCE(meta->request.csum_offset);
+
+				if (unlikely(csum_start + csum_offset +
 					     sizeof(__sum16) > len)) {
 					err = -EINVAL;
 					goto free_err;
 				}
 
-				skb->csum_start = hr + meta->request.csum_start;
-				skb->csum_offset = meta->request.csum_offset;
+				skb->csum_start = hr + csum_start;
+				skb->csum_offset = csum_offset;
 				skb->ip_summed = CHECKSUM_PARTIAL;
 
 				if (unlikely(xs->pool->tx_sw_csum)) {
-- 
2.53.0



