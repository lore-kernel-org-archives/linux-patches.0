Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F121D2784;
	Wed,  6 Nov 2024 12:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895975; cv=none; b=HSID/sKSc06Q34i6jtMT573guy6Ki3x3BbGQapbSEX5O9GVYnrienV/ywu1wyL+qzbSY5PW9DXkmjQJgJuDCTd+ZQuylGBU4OKGhDFClghcRfmCWdrOFouIyj6xJU5gybHY20iki+iNwei56cb5hLhTJgAjuWoDet9lzvCkDwns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895975; c=relaxed/simple;
	bh=T8P1nV03xQnsRRgr29o3Pvu3byEb3YZCoWDgFZrU8oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbWQSRfNGTj+OniIgXLem5Dm4K7fnO7rSAP6nejIYfP7T5EmKENBNQ2ugRqvIYe4hD9+LS21D3hhAFZ8xVJB5mtk92sGfGUMv4wdZN4bhxr8YJyuPbNRtuti2yals3gBDXYOObxHl5YlkaGpTtFg8Z7aBBWEVqRU84sAENJKAnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSMKNxBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSMKNxBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B81CC4CED4;
	Wed,  6 Nov 2024 12:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895974;
	bh=T8P1nV03xQnsRRgr29o3Pvu3byEb3YZCoWDgFZrU8oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSMKNxBsSdnHAL05QLlfYbJXAnp6+SPmmqFe1h/WuxE37SwvkGTOJFherctO51Kas
	 c7QoDiFF9ZyyiYaPCNdG67u7se3MK9NlpiZUTwQ1z6tqpedtCXDpKKnpF1GsEXoevQ
	 UnCPi7y5lIWj+upqkf07qpJLXmDsPsh3CyezoXdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 048/245] bpf: Check the validity of nr_words in bpf_iter_bits_new()
Date: Wed,  6 Nov 2024 13:01:41 +0100
Message-ID: <20241106120320.406644466@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 393397fbdcad7396639d7077c33f86169184ba99 ]

Check the validity of nr_words in bpf_iter_bits_new(). Without this
check, when multiplication overflow occurs for nr_bits (e.g., when
nr_words = 0x0400-0001, nr_bits becomes 64), stack corruption may occur
due to bpf_probe_read_kernel_common(..., nr_bytes = 0x2000-0008).

Fix it by limiting the maximum value of nr_words to 511. The value is
derived from the current implementation of BPF memory allocator. To
ensure compatibility if the BPF memory allocator's size limitation
changes in the future, use the helper bpf_mem_alloc_check_size() to
check whether nr_bytes is too larger. And return -E2BIG instead of
-ENOMEM for oversized nr_bytes.

Fixes: 4665415975b0 ("bpf: Add bits iterator")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20241030100516.3633640-4-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a4521d2606b6b..8419de44c5174 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2830,6 +2830,8 @@ struct bpf_iter_bits {
 	__u64 __opaque[2];
 } __aligned(8);
 
+#define BITS_ITER_NR_WORDS_MAX 511
+
 struct bpf_iter_bits_kern {
 	union {
 		unsigned long *bits;
@@ -2844,7 +2846,8 @@ struct bpf_iter_bits_kern {
  * @it: The new bpf_iter_bits to be created
  * @unsafe_ptr__ign: A pointer pointing to a memory area to be iterated over
  * @nr_words: The size of the specified memory area, measured in 8-byte units.
- * Due to the limitation of memalloc, it can't be greater than 512.
+ * The maximum value of @nr_words is @BITS_ITER_NR_WORDS_MAX. This limit may be
+ * further reduced by the BPF memory allocator implementation.
  *
  * This function initializes a new bpf_iter_bits structure for iterating over
  * a memory area which is specified by the @unsafe_ptr__ign and @nr_words. It
@@ -2871,6 +2874,8 @@ bpf_iter_bits_new(struct bpf_iter_bits *it, const u64 *unsafe_ptr__ign, u32 nr_w
 
 	if (!unsafe_ptr__ign || !nr_words)
 		return -EINVAL;
+	if (nr_words > BITS_ITER_NR_WORDS_MAX)
+		return -E2BIG;
 
 	/* Optimization for u64 mask */
 	if (nr_bits == 64) {
@@ -2882,6 +2887,9 @@ bpf_iter_bits_new(struct bpf_iter_bits *it, const u64 *unsafe_ptr__ign, u32 nr_w
 		return 0;
 	}
 
+	if (bpf_mem_alloc_check_size(false, nr_bytes))
+		return -E2BIG;
+
 	/* Fallback to memalloc */
 	kit->bits = bpf_mem_alloc(&bpf_global_ma, nr_bytes);
 	if (!kit->bits)
-- 
2.43.0



