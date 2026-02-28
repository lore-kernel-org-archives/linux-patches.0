Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38EF39B946
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302520; cv=none; b=FxGd0OgQqZ87p0nsVLMqRt9z55rR8Uh9u7XGQE3/SFFulnARmIBissV30RljH3RoszpwtpiEJ+ZI1Q4JflGgLGCt9mJn2XlRooJ0jBtiH+/NBB7nBvaMlJHhC+o+vsROQv9FPyzlb4BW3hqzE3HXMs0ZkpQBdHZp2mwERwY5D48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302520; c=relaxed/simple;
	bh=zo3zIFH9qrF9J0RpUtvVmckqMGpkYgj99di/zOQHI24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcN+WRNVcNwCNyUBSyHSVlmeM2yd1YFUuJkSRVdQEyOWso09y80tULPBfk7lfVY4O8qaS5nwMHoURBRgKboCmoligYTeW2Agz67d3CGKY85tlNmwa7DYOQkEnP0MnNJ1lCNqj3PjGLkC4fiHqwyI+I4JtexRWmJ2w2bN3b/J2B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhZAkmeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhZAkmeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3577AC116D0;
	Sat, 28 Feb 2026 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302520;
	bh=zo3zIFH9qrF9J0RpUtvVmckqMGpkYgj99di/zOQHI24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhZAkmeVdDX7w5fhRIWiSU9WGkIfNV251PntP+EtjS7lO/kGDtEzc3CmzmdrfTHTu
	 ZB6N2AQcIZxYzsHrOxHMSuWsTIQ3ItRfBrHsxCtW6XBsW8y/Ek/ufre1qpuQ13YqZH
	 OhKIu05uLJjKF5TiZV2iadJBXfLsd5BqAvexlTo0mv9QA3wzVnaE0wyXabu2m4rtDb
	 r4144ZNfo5BJI2ATvbzuxLQ1wKfJGT2d/ePZK51P6pvchus7O3lwBCmFl0+QmUKPE7
	 2ys4R+85mb/hcD8cGCpeCSucRp2Lau3O1HvYv5EPHcJtLyTsGxKLbT4wqvbTpFjr2w
	 EtCdMj/RDmvMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ilya Leoshkevich <iii@linux.ibm.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/164] libbpf: Fix dumping big-endian bitfields
Date: Sat, 28 Feb 2026 13:12:37 -0500
Message-ID: <20260228181505.1600663-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit c9e982b879465ca74e3593ce82808aa259265a71 ]

On big-endian arches not only bytes, but also bits are numbered in
reverse order (see e.g. S/390 ELF ABI Supplement, but this is also true
for other big-endian arches as well).

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211013160902.428340-3-iii@linux.ibm.com
Stable-dep-of: 5714ca8cba5e ("libbpf: Fix OOB read in btf_dump_get_bitfield_value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index d62b2d2e8aacb..91ab07901a1bc 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1656,29 +1656,28 @@ static int btf_dump_get_bitfield_value(struct btf_dump *d,
 				       __u64 *value)
 {
 	__u16 left_shift_bits, right_shift_bits;
-	__u8 nr_copy_bits, nr_copy_bytes;
 	const __u8 *bytes = data;
-	int sz = t->size;
+	__u8 nr_copy_bits;
 	__u64 num = 0;
 	int i;
 
 	/* Maximum supported bitfield size is 64 bits */
-	if (sz > 8) {
-		pr_warn("unexpected bitfield size %d\n", sz);
+	if (t->size > 8) {
+		pr_warn("unexpected bitfield size %d\n", t->size);
 		return -EINVAL;
 	}
 
 	/* Bitfield value retrieval is done in two steps; first relevant bytes are
 	 * stored in num, then we left/right shift num to eliminate irrelevant bits.
 	 */
-	nr_copy_bits = bit_sz + bits_offset;
-	nr_copy_bytes = t->size;
 #if __BYTE_ORDER == __LITTLE_ENDIAN
-	for (i = nr_copy_bytes - 1; i >= 0; i--)
+	for (i = t->size - 1; i >= 0; i--)
 		num = num * 256 + bytes[i];
+	nr_copy_bits = bit_sz + bits_offset;
 #elif __BYTE_ORDER == __BIG_ENDIAN
-	for (i = 0; i < nr_copy_bytes; i++)
+	for (i = 0; i < t->size; i++)
 		num = num * 256 + bytes[i];
+	nr_copy_bits = t->size * 8 - bits_offset;
 #else
 # error "Unrecognized __BYTE_ORDER__"
 #endif
-- 
2.51.0

