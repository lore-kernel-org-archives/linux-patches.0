Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D1836C9E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302313; cv=none; b=eZqugYkCrbiIJNvNu5PNCvC+OosdOKEmY21jaKk9YfMcYMl27sYuXkyw3tbpPB9xabwt7IpMoZf1z2wWb6a9QTsmt7EBr/AeVw+vEABFxO8xigDKLYEWdtUTo4HEthfzXHde2wdmeOFuG2hF5O08O9YgKl2nkDVLioenPaVzFYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302313; c=relaxed/simple;
	bh=vth98mWlSXKXQojow7gUL2rNd2ob/3VRk3X4PJpxdEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQaJoERzTV//C3ROGCXsokAa39pO+zge2KZ+58tVN2/MiOCBgnL79qcIzFRXz9AVlseOPaH6HLaIiHnYUXJID1rFUDvi690wOpCmzhsMc8YYIXjPqQA6Gycyze2J3HhJV8YewhbPDlhTnhQ6sCllCbSEMswQ0lgjbV3b9+IkmWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HHDkC+Cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HHDkC+Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1384C116D0;
	Sat, 28 Feb 2026 18:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302313;
	bh=vth98mWlSXKXQojow7gUL2rNd2ob/3VRk3X4PJpxdEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHDkC+Czyttc8AxJfY1Mo0QCoIff17WJqRfQsnX9kHT3yPftUL2g+Y+5qY8Feetgw
	 iRjMbjqEHz8VT36OtwWFzjD5aOHeTlvjfKfoLnqNc9o7Zwtpp12HWG0Jt3qHZ8Txxr
	 KsHSkxFf02+yFxpD/zvcMOJKifnVZqK4BfiqPq9OPA8yp1WCPpyzgnsdBwZW4JxksQ
	 cvBbcG9DNTISJ3x688NLahxW1VLKaoVlMv69E5ccg7seCpbHNz9Jn800S5mAubfQzx
	 D50Vs7l1rvgFN2uZjLcQUWvBKDkgzHAwkCwRjY74hTQB9VNsLLYDz2OpISIL/OGRyi
	 7ZZjyHn7tcgug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Varun R Mallya <varunrmallya@gmail.com>,
	Harrison Green <harrisonmichaelgreen@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/232] libbpf: Fix OOB read in btf_dump_get_bitfield_value
Date: Sat, 28 Feb 2026 13:08:03 -0500
Message-ID: <20260228181127.1592657-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Varun R Mallya <varunrmallya@gmail.com>

[ Upstream commit 5714ca8cba5ed736f3733663c446cbee63a10a64 ]

When dumping bitfield data, btf_dump_get_bitfield_value() reads data
based on the underlying type's size (t->size). However, it does not
verify that the provided data buffer (data_sz) is large enough to
contain these bytes.

If btf_dump__dump_type_data() is called with a buffer smaller than
the type's size, this leads to an out-of-bounds read. This was
confirmed by AddressSanitizer in the linked issue.

Fix this by ensuring we do not read past the provided data_sz limit.

Fixes: a1d3cc3c5eca ("libbpf: Avoid use of __int128 in typed dump display")
Reported-by: Harrison Green <harrisonmichaelgreen@gmail.com>
Suggested-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Varun R Mallya <varunrmallya@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260106233527.163487-1-varunrmallya@gmail.com

Closes: https://github.com/libbpf/libbpf/issues/928
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 72334cc14d737..cce69301c5e3a 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1721,9 +1721,18 @@ static int btf_dump_get_bitfield_value(struct btf_dump *d,
 	__u16 left_shift_bits, right_shift_bits;
 	const __u8 *bytes = data;
 	__u8 nr_copy_bits;
+	__u8 start_bit, nr_bytes;
 	__u64 num = 0;
 	int i;
 
+	/* Calculate how many bytes cover the bitfield */
+	start_bit = bits_offset % 8;
+	nr_bytes = (start_bit + bit_sz + 7) / 8;
+
+	/* Bound check */
+	if (data + nr_bytes > d->typed_dump->data_end)
+		return -E2BIG;
+
 	/* Maximum supported bitfield size is 64 bits */
 	if (t->size > 8) {
 		pr_warn("unexpected bitfield size %d\n", t->size);
-- 
2.51.0

