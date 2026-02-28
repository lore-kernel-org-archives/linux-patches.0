Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3C2375AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301654; cv=none; b=tJpqe+FNhJ8Ifz3C68Gcn9CV3VdtflRVsaJ2K5N71DUCzhSp3dbFykKXi9bHNy5Pk2upKfMlkeYO6D0WU/49H7NBCXk9G7ER7Vd/1THfdqZ/YtRB3dPdkMlcNmfv/Y1bW502Ol/RNQPdUvJTKA5hW6VO59zEhWWO7VN9fkIeshU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301654; c=relaxed/simple;
	bh=QQUtHwxjGS+16v3Yqe9ERE5jwfQ/JEgrfzSEqaGBJ7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDHmJShS9VzSckweVR9UNwX+PElJ6vV4oJb54aZwxvAX+l162AXO67YEZ7DImIg52iJoh3mz8/LuoRQ3JheNahrKtpf0MUwGlU/a3qeMr9h/+rYn6JQkOXlkw+KyS9rrGZYhWtAsgl2n3HJ2I8NT9078rnjnC30p91+J9fyA08o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVAC9N/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVAC9N/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B7DC19425;
	Sat, 28 Feb 2026 18:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301654;
	bh=QQUtHwxjGS+16v3Yqe9ERE5jwfQ/JEgrfzSEqaGBJ7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVAC9N/7ZL8y7PPMDNV5kF/2ntJ2zWfFnGGaHb6YKMt3U+UJiFDSrhv2CWEOj8L6d
	 O13HK3XxIV0pUSsjBF00ax2EutVoXHaLTs3LuHyhM5o6CBK86Mqd125AhhDQSj+dJV
	 JkNOcQtiRYkXBUFQJ6y7UReBY366rkF4bICjbsCdleQLaHTJfhfeRn6OnpYzgPsCW9
	 2qhS94cUQtrGwB1ZAp3zD9rkAk5Xesro6Iu+CNwlgUFom/jjepW5g6ihOH+XGMeVBr
	 7Ax9sui6tqbE08KN6hoxeaDZAFhVzXK4TjjyEDCwbFA2Vv5l1f7y4uD6lzhoKRXeP3
	 lEj0BhCmMY4Kw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Varun R Mallya <varunrmallya@gmail.com>,
	Harrison Green <harrisonmichaelgreen@gmail.com>,
	Alan Maguire <alan.maguire@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/385] libbpf: Fix OOB read in btf_dump_get_bitfield_value
Date: Sat, 28 Feb 2026 12:54:33 -0500
Message-ID: <20260228180011.1568201-51-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 12306b5de3efb..a833d91886f87 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1758,9 +1758,18 @@ static int btf_dump_get_bitfield_value(struct btf_dump *d,
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

