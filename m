Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2EA1A239A;
	Tue, 21 Jul 2026 15:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648990; cv=none; b=msC+Ym9E93FbkBa/FfggmzI/EmZwQ9Y1lzGFnzGkd8HFIsvWqymlupOGFPuZUJ5hQ82BNNLjWP/E9GXw27UMpO4w9ZYq+gDlfOBx/L1TPy8/+PO0Pcs4ZZTQu/NtXwDj6gZ2nNudZHkViJBKzd2BhrtX9dbf/2ZxG+oy1THX7L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648990; c=relaxed/simple;
	bh=Asd515wrJr+QSmHHhbBjcXWxpWQxyDeaD4Ekt30DXUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJMoTzBhUxvKBWz/uCXtkMC+6fC7vovwRtNUZdqIE4EWVh/u10/8T0XxIMvKHwoTBTOfsOcX4DHf5rFzAhquM0WWkT9ncDlvwohTDJe0fzDCd2dnOW3kNC3zgI9FNjqd0BTCscoAL3yq9Tp3aq3HThpJJY3s067/QJy6bcj3i58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ew3NmOBQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ew3NmOBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDE31F000E9;
	Tue, 21 Jul 2026 15:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648988;
	bh=6sLK24z0valqm1c9cQMkcdWeKceqQEXzJn3Zw1smMWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ew3NmOBQP4ALbrdkU5ss+oTEUDoRAyp7tJT1qW9gvziGWBPJ5MKpTMBjX5w8SH4Gj
	 s/nxTaNYBQ7HOAJHon+Iif5I4glOJA8lDytjPpmKVL3kaCigAB1rfTss1oFuRwsuJp
	 c1bp7fZW8xS2UKyUTShT1q0N07qGruklIm2tAY1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko@sashiko.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0406/2077] libbpf: Skip endianness swap when loader generation failed
Date: Tue, 21 Jul 2026 17:01:19 +0200
Message-ID: <20260721152602.295826299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 41300d032a1b1d91a3ed996ad21905463e344beb ]

bpf_gen__prog_load() byte-swaps the program insns and the {func,line}_info
and CO-RE relo blobs in place for cross-endian targets. The blob offsets
come from add_data(), which returns 0 on failure: realloc_data_buf() either
frees and NULLs gen->data_start (realloc OOM) or returns early on an
already-latched gen->error, leaving a stale, possibly too-small buffer.

Neither bswap site checked for this. With gen->swapped_endian set and a
failed generation, "gen->data_start + off" becomes NULL + 0. Guard the
same way via !gen->error so they are skipped once generation has failed.

Fixes: 8ca3323dce43 ("libbpf: Support creating light skeleton of either endianness")
Reported-by: sashiko <sashiko@sashiko.dev>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260529162829.315921-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/gen_loader.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index e2fe841a56698b..e63a01101e2d85 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -1053,7 +1053,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen,
 		 prog_idx, prog_type, insns_off, insn_cnt, license_off);
 
 	/* convert blob insns to target endianness */
-	if (gen->swapped_endian) {
+	if (gen->swapped_endian && !gen->error) {
 		struct bpf_insn *insn = gen->data_start + insns_off;
 		int i;
 
@@ -1091,7 +1091,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen,
 		 sizeof(struct bpf_core_relo));
 
 	/* convert all info blobs to target endianness */
-	if (gen->swapped_endian)
+	if (gen->swapped_endian && !gen->error)
 		info_blob_bswap(gen, func_info, line_info, core_relos, load_attr);
 
 	libbpf_strlcpy(attr.prog_name, prog_name, sizeof(attr.prog_name));
-- 
2.53.0



