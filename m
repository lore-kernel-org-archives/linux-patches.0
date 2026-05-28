Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C01223328;
	Thu, 28 May 2026 20:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000283; cv=none; b=Cl/mj9fKegfbMSNPY0tbfQjwt6fgq4tdhVd7XoG111/+nqUgpNqyl/EYsmsOHnft0BXkBLEihl994pf7iYS2mx+6U6Ay5j+tTSNPd15m9FhCrBzWld/Cl7IYWLS6NoQXWLLc39/1EcdnlbrDNgleT9Hpj62pLnbF0jnzeXo05eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000283; c=relaxed/simple;
	bh=UNj/rtlyfds3bwHldcgYs4+OL2KIzUw768zA1mBERps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIqPaImX0GOIf5ssa+NtxGclsmtev6gNNgqn70cTG/x3JNikxYvW8mEvdY5SdW/OrJFprlfi5gQSTNuYa9POGyM9tu6yHX26sMYZzZ+fkFOPpHNgqoOH2eYn4iVeOM52W8TIy84u20ygk8Jj1QUNS5GftXBO3WLhkBbBl9AmpmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAHt1dF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAHt1dF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B01E71F000E9;
	Thu, 28 May 2026 20:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000282;
	bh=hRy3bKgKqtwuMYD6ppJM7Zqf2eF+ohvPAJGaqzUnFTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAHt1dF0Nk4C0YGGA0v4ApI0gHr6pE+dLlswC+eWUrP+kHbclIQ4OpgaL4GcNkHQ8
	 r3JzlTpcV62sB/LVCkBPpeaYZUuLUOFV1N5KtyIL/zJh1LwBtvA5hiJH1mPJKhzwPd
	 x/hA524cdLD2PnVeSg0F4couKnaAnQdmgRcgEqZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 368/377] selftests: net: Fix checksums in xdp_native
Date: Thu, 28 May 2026 21:50:06 +0200
Message-ID: <20260528194649.081146121@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index c368fc045f4b4..d5134f93f7d7f 100644
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
 				     __u32 hdr_len)
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
 
@@ -483,8 +489,7 @@ static int xdp_adjst_head_shrnk_data(struct xdp_md *ctx, __u64 hdr_len,
 		return -1;
 
 	udp_csum = bpf_csum_diff((__be32 *)tmp_buff, offset, 0, 0, udp_csum);
-
-	udph->check = (__u16)csum_fold_helper(udp_csum);
+	udph->check = (__u16)csum_fold_udp_helper(udp_csum);
 
 	if (bpf_xdp_load_bytes(ctx, 0, tmp_buff, MAX_ADJST_OFFSET) < 0)
 		return -1;
@@ -541,7 +546,7 @@ static int xdp_adjst_head_grow_data(struct xdp_md *ctx, __u64 hdr_len,
 		return -1;
 
 	udp_csum = bpf_csum_diff(0, 0, (__be32 *)data_buff, offset, udp_csum);
-	udph->check = (__u16)csum_fold_helper(udp_csum);
+	udph->check = (__u16)csum_fold_udp_helper(udp_csum);
 
 	if (hdr_len > MAX_ADJST_OFFSET || hdr_len == 0)
 		return -1;
-- 
2.53.0



