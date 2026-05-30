Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D273AEB5C;
	Sat, 30 May 2026 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160832; cv=none; b=tjcoSrvX7YXCTB825l3GHi3ZO9GfUyL2lHeyZimAgfEtI4H1lHi7eX+G88IqGbEAj87nqVwr4VN02w/WodQRRmVLUjU7lTTryiG/OHiBeKjY6lqMQn7hcB084BzKiOPumGlc2eZezdIjUyYLXXzaRV4cfQIMxf6N8cl6i8Yy1xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160832; c=relaxed/simple;
	bh=biFCRMYqVMsMgahVvwzCp1EO7I4zX32Ulolw2RtN+t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8ial6q+V/uVc96V+Ftr+JGowr7BVo8Ip9NzJTEJS0eUGuU83eK05t7+4TI4DZj/q2/b45sS6F6eLb7B/zkcwoHITgcNz1gxwtC3w0UUnxfr0B3T8WOAON3cdozD5rHXsxqm618505H81YH3JzuIz49PJtIABtlx7UQYugqIlbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uc9sRizo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uc9sRizo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453DA1F00893;
	Sat, 30 May 2026 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160830;
	bh=Z8I5oZYAt5uz1BsE3AJXBmaSZrtrto4oL+dlfMIccV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uc9sRizo4fLnBzlPRtyGDvRtic8euyePtrSeB8uEHFJfuO6ziMvvuNh+b38qtTcJv
	 wGsPx+49airSISpvVW12Qlzqm1WnzQ3XKhYhK2gTtRk2qgp4CZNd9QljZh3f2k3MDl
	 UyBewMksMuUVXCubL3RbrnTbart+40rKGKs61N5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadfed@meta.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 448/969] bpf: Add CHECKSUM_COMPLETE to bpf test progs
Date: Sat, 30 May 2026 17:59:32 +0200
Message-ID: <20260530160312.646740296@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Fedorenko <vadfed@meta.com>

[ Upstream commit a3cfe84cca28f205761a0450016593b0d728165e ]

Add special flag to validate that TC BPF program properly updates
checksum information in skb.

Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240606145851.229116-1-vadfed@meta.com
Stable-dep-of: 972787479ee7 ("bpf: test_run: Fix the null pointer dereference issue in bpf_lwt_xmit_push_encap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       |  2 ++
 net/bpf/test_run.c             | 28 +++++++++++++++++++++++++++-
 tools/include/uapi/linux/bpf.h |  2 ++
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 216d1f0009791..600b10c50fdd9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1286,6 +1286,8 @@ enum {
 #define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
 /* If set, XDP frames will be transmitted after processing */
 #define BPF_F_TEST_XDP_LIVE_FRAMES	(1U << 1)
+/* If set, apply CHECKSUM_COMPLETE to skb and validate the checksum */
+#define BPF_F_TEST_SKB_CHECKSUM_COMPLETE	(1U << 2)
 
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 9cbdfb9fd6743..2b8daf1cb6885 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1099,7 +1099,8 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	void *data;
 	int ret;
 
-	if (kattr->test.flags || kattr->test.cpu || kattr->test.batch_size)
+	if ((kattr->test.flags & ~BPF_F_TEST_SKB_CHECKSUM_COMPLETE) ||
+	    kattr->test.cpu || kattr->test.batch_size)
 		return -EINVAL;
 
 	if (size < ETH_HLEN)
@@ -1150,6 +1151,7 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
 	__skb_put(skb, size);
+
 	if (ctx && ctx->ifindex > 1) {
 		dev = dev_get_by_index(net, ctx->ifindex);
 		if (!dev) {
@@ -1185,9 +1187,19 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		__skb_push(skb, hh_len);
 	if (is_direct_pkt_access)
 		bpf_compute_data_pointers(skb);
+
 	ret = convert___skb_to_skb(skb, ctx);
 	if (ret)
 		goto out;
+
+	if (kattr->test.flags & BPF_F_TEST_SKB_CHECKSUM_COMPLETE) {
+		const int off = skb_network_offset(skb);
+		int len = skb->len - off;
+
+		skb->csum = skb_checksum(skb, off, len, 0);
+		skb->ip_summed = CHECKSUM_COMPLETE;
+	}
+
 	ret = bpf_test_run(prog, skb, repeat, &retval, &duration, false);
 	if (ret)
 		goto out;
@@ -1202,6 +1214,20 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		}
 		memset(__skb_push(skb, hh_len), 0, hh_len);
 	}
+
+	if (kattr->test.flags & BPF_F_TEST_SKB_CHECKSUM_COMPLETE) {
+		const int off = skb_network_offset(skb);
+		int len = skb->len - off;
+		__wsum csum;
+
+		csum = skb_checksum(skb, off, len, 0);
+
+		if (csum_fold(skb->csum) != csum_fold(csum)) {
+			ret = -EBADMSG;
+			goto out;
+		}
+	}
+
 	convert_skb_to___skb(skb, ctx);
 
 	size = skb->len;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 39818b6e0293c..cbdc5299f6bf7 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1286,6 +1286,8 @@ enum {
 #define BPF_F_TEST_RUN_ON_CPU	(1U << 0)
 /* If set, XDP frames will be transmitted after processing */
 #define BPF_F_TEST_XDP_LIVE_FRAMES	(1U << 1)
+/* If set, apply CHECKSUM_COMPLETE to skb and validate the checksum */
+#define BPF_F_TEST_SKB_CHECKSUM_COMPLETE	(1U << 2)
 
 /* type for BPF_ENABLE_STATS */
 enum bpf_stats_type {
-- 
2.53.0



