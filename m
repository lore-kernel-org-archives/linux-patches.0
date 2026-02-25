Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FF7251795;
	Wed, 25 Feb 2026 01:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982889; cv=none; b=G9+eXIXH7PCPbpVvYfs7lzA93D5JyRkKqiZlgn0POdz/w4H+Nmis7+OSqbi4UFQB46JkcK67NnR9cXUyheLfnEW7keB829v2FVj3Cly5hZmp1BfCkPtNAg6UF6YovrZGqDyWknkGE0cTRWer/VJlvOgiUyJKwVdP2SLGc2wJx4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982889; c=relaxed/simple;
	bh=zwQtGPNVUKT+eCGnB4CTARAs3wk7to3A3ndTx3eiZds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyBALUcU+C95a8j6UH69IhY6C20IR3P0pb05xo3uhYQvzJzgb/mCtpFOfu/mf3DQ67eyZAFOYPPVi0izUCJqLtWbfhiNB50z9QokqrrAjfeKKeVwKKvBoaBX8JyMIU2Fn690MUW9gxZKR3vOfgpGmYZ/qGBkvhg2PerSBgfpenM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E1HyzNPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E1HyzNPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC929C116D0;
	Wed, 25 Feb 2026 01:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982888;
	bh=zwQtGPNVUKT+eCGnB4CTARAs3wk7to3A3ndTx3eiZds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1HyzNPiTxEQECf1Jhd0YgEWPh8ZfEn1axz+5ejNFoEVz4WltcjBNDkn/wHPAo0tM
	 onLSwaboZDofVwWMG3U/I66jBl1RXX9aOuGA2t/7fVo/b1/UWKMbmM7z7WeiFGcz7w
	 d0iUXip5aUFUTg74H8X/KSSPo9sNa9K72S3yL/a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harrison Green <harrisonmichaelgreen@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Varun R Mallya <varunrmallya@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 074/781] libbpf: Fix OOB read in btf_dump_get_bitfield_value
Date: Tue, 24 Feb 2026 17:13:03 -0800
Message-ID: <20260225012401.518821302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 6388392f49a0b..53c6624161d79 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1762,9 +1762,18 @@ static int btf_dump_get_bitfield_value(struct btf_dump *d,
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



