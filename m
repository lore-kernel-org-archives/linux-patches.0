Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0232335566;
	Thu, 28 May 2026 20:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999201; cv=none; b=RBGYA71yQTV/BrSA+YE0Aehqp/YUcN3Mg4Zi7RdrUrECComYJ70Apb7zrRNadDq5e0VX0lFfjvGJFeqfU/f6di27A+ZiicMOTzoVSsIUZC1dZUgq8mz0a9UULAzlqKePLplIgAnIKK99UtgpZcpQxcP9EfcjrtHBZHh18soWPY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999201; c=relaxed/simple;
	bh=aNnUrolHxSVt+6TgcASWWPtC5pdcZFY/t3sWwj6ptDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgXPyI4N5vl+5KI2owHGxzbzgoE3h4twGzt84AlKM+IpOp9lvaWOaaoFTTTD0jEm6EEXgoJV/yoUVEnMB6hEWO7xgFwj1UYNZqaAaN1WmNS0YhYWRe8pv2rRjvvTwCo3ELvS86EjzxY5Elu30E9sKMj8+GHJ9nc6bop1b5Hhu7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPKOoaN/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPKOoaN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F911F000E9;
	Thu, 28 May 2026 20:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999199;
	bh=vhqAHJS4kU6Wr+tZzddLNPpKSx3Kgsor/iljDAqcAn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPKOoaN/KQU0f9x5b9oTG074QWdroby669pN7PahBdQ1JSirzsutWcnBifCnjcpN4
	 o1nKMLMKKgjTjGEdPddcMtkpUeosFt29q2X79l2wx8PQ9tZnz/SRMLMtNYpyb4/fV8
	 FovrGh0ZyyZE+4IAaYe0vKcsLOU0U8MYxfhNEH+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 445/461] selftests: net: Fix checksums in xdp_native
Date: Thu, 28 May 2026 21:49:34 +0200
Message-ID: <20260528194700.415235315@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Nimrod Oren <noren@nvidia.com>

[ Upstream commit dfc077043351a81887d1e4c9ac244e9243f3cbf2 ]

Data adjustment cases failed with "Data exchange failed" when using IPv4
because the program did not update the IP and UDP checksums in the IPv4
branch. The issue was masked when both IPv4 and IPv6 were configured,
since the test harness prefers IPv6.

While here, generalize csum_fold_helper() to fold twice so it works for
any 32-bit input.

Fixes: 0b65cfcef9c5 ("selftests: drv-net: Test tail-adjustment support")
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Nimrod Oren <noren@nvidia.com>
Link: https://patch.msgid.link/20260520153928.3371765-1-noren@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/lib/xdp_native.bpf.c        | 55 ++++++++++---------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/net/lib/xdp_native.bpf.c b/tools/testing/selftests/net/lib/xdp_native.bpf.c
index 64f05229ab243..ded3f896e6224 100644
--- a/tools/testing/selftests/net/lib/xdp_native.bpf.c
+++ b/tools/testing/selftests/net/lib/xdp_native.bpf.c
@@ -268,6 +268,17 @@ static int xdp_mode_tx_handler(struct xdp_md *ctx, __u16 port)
 	return XDP_PASS;
 }
 
+static __always_inline __u16 csum_fold_helper(__u32 csum)
+{
+	csum = (csum & 0xffff) + (csum >> 16);
+	return ~((csum & 0xffff) + (csum >> 16));
+}
+
+static __always_inline __u16 csum_fold_udp_helper(__u32 csum)
+{
+	return csum_fold_helper(csum) ? : 0xffff;
+}
+
 static void *update_pkt(struct xdp_md *ctx, __s16 offset, __u32 *udp_csum)
 {
 	void *data_end = (void *)(long)ctx->data_end;
@@ -281,21 +292,22 @@ static void *update_pkt(struct xdp_md *ctx, __s16 offset, __u32 *udp_csum)
 
 	if (eth->h_proto == bpf_htons(ETH_P_IP)) {
 		struct iphdr *iph = data + sizeof(*eth);
-		__u16 total_len;
 
 		if (iph + 1 > (struct iphdr *)data_end)
 			return NULL;
 
-		iph->tot_len = bpf_htons(bpf_ntohs(iph->tot_len) + offset);
-
 		udph = (void *)eth + sizeof(*iph) + sizeof(*eth);
 		if (!udph || udph + 1 > (struct udphdr *)data_end)
 			return NULL;
 
-		len_new = bpf_htons(bpf_ntohs(udph->len) + offset);
+		len = iph->tot_len;
+		len_new = bpf_htons(bpf_ntohs(len) + offset);
+		iph->tot_len = len_new;
+		iph->check = csum_fold_helper(
+			bpf_csum_diff(&len, sizeof(len), &len_new,
+				      sizeof(len_new), ~((__u32)iph->check)));
 	} else if (eth->h_proto  == bpf_htons(ETH_P_IPV6)) {
 		struct ipv6hdr *ipv6h = data + sizeof(*eth);
-		__u16 payload_len;
 
 		if (ipv6h + 1 > (struct ipv6hdr *)data_end)
 			return NULL;
@@ -304,33 +316,27 @@ static void *update_pkt(struct xdp_md *ctx, __s16 offset, __u32 *udp_csum)
 		if (!udph || udph + 1 > (struct udphdr *)data_end)
 			return NULL;
 
-		*udp_csum = ~((__u32)udph->check);
-
 		len = ipv6h->payload_len;
 		len_new = bpf_htons(bpf_ntohs(len) + offset);
 		ipv6h->payload_len = len_new;
-
-		*udp_csum = bpf_csum_diff(&len, sizeof(len), &len_new,
-					  sizeof(len_new), *udp_csum);
-
-		len = udph->len;
-		len_new = bpf_htons(bpf_ntohs(udph->len) + offset);
-		*udp_csum = bpf_csum_diff(&len, sizeof(len), &len_new,
-					  sizeof(len_new), *udp_csum);
 	} else {
 		return NULL;
 	}
 
+	len = udph->len;
+	len_new = bpf_htons(bpf_ntohs(len) + offset);
+
+	*udp_csum = ~((__u32)udph->check);
+	*udp_csum = bpf_csum_diff(&len, sizeof(len), &len_new,
+				  sizeof(len_new), *udp_csum);
+	*udp_csum = bpf_csum_diff(&len, sizeof(len), &len_new,
+				  sizeof(len_new), *udp_csum);
+
 	udph->len = len_new;
 
 	return udph;
 }
 
-static __u16 csum_fold_helper(__u32 csum)
-{
-	return ~((csum & 0xffff) + (csum >> 16)) ? : 0xffff;
-}
-
 static int xdp_adjst_tail_shrnk_data(struct xdp_md *ctx, __u16 offset,
 				     unsigned long hdr_len)
 {
@@ -359,7 +365,7 @@ static int xdp_adjst_tail_shrnk_data(struct xdp_md *ctx, __u16 offset,
 		return -1;
 
 	udp_csum = bpf_csum_diff((__be32 *)tmp_buff, offset, 0, 0, udp_csum);
-	udph->check = (__u16)csum_fold_helper(udp_csum);
+	udph->check = (__u16)csum_fold_udp_helper(udp_csum);
 
 	if (bpf_xdp_adjust_tail(ctx, 0 - offset) < 0)
 		return -1;
@@ -403,7 +409,7 @@ static int xdp_adjst_tail_grow_data(struct xdp_md *ctx, __u16 offset)
 		return -1;
 
 	udp_csum = bpf_csum_diff(0, 0, (__be32 *)tmp_buff, offset, udp_csum);
-	udph->check = (__u16)csum_fold_helper(udp_csum);
+	udph->check = (__u16)csum_fold_udp_helper(udp_csum);
 
 	buff_len = bpf_xdp_get_buff_len(ctx);
 
@@ -484,8 +490,7 @@ static int xdp_adjst_head_shrnk_data(struct xdp_md *ctx, __u64 hdr_len,
 		return -1;
 
 	udp_csum = bpf_csum_diff((__be32 *)tmp_buff, offset, 0, 0, udp_csum);
-
-	udph->check = (__u16)csum_fold_helper(udp_csum);
+	udph->check = (__u16)csum_fold_udp_helper(udp_csum);
 
 	if (bpf_xdp_load_bytes(ctx, 0, tmp_buff, MAX_ADJST_OFFSET) < 0)
 		return -1;
@@ -542,7 +547,7 @@ static int xdp_adjst_head_grow_data(struct xdp_md *ctx, __u64 hdr_len,
 		return -1;
 
 	udp_csum = bpf_csum_diff(0, 0, (__be32 *)data_buff, offset, udp_csum);
-	udph->check = (__u16)csum_fold_helper(udp_csum);
+	udph->check = (__u16)csum_fold_udp_helper(udp_csum);
 
 	if (hdr_len > MAX_ADJST_OFFSET || hdr_len == 0)
 		return -1;
-- 
2.53.0



