Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EE4269AE4;
	Tue,  8 Apr 2025 12:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114517; cv=none; b=T3LhtM92V5SvKqAVnhXK8s4xd+M7Ysp9tRkGaa+fc1bM+lD30wCF9p9S9nsOHATBZ3z74LS2VqwrdYdK9Ux+BXUErxbde2YExlYwkUr79X9XkZIlgbQthVlhZVLQ6a/K4o52xNPDoIbTadGywc1YSzM6WxmDpEUDkaXT14Fyqbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114517; c=relaxed/simple;
	bh=/1wIcgrOhl1+uQKbwIOtKygS1iK60kGCuCVQT0YOZVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGsQg/Bg2TwWSPMQBqTZW6BUqti0xXbHxDVHKfl92M2V0afzWa2FGtglA4PfyH2rxAHMKNGFdxQ2fs3+4WUxwuhGFlY9qY/t68mpvLTiZg0ufJbuGRRUaa4bXMQ1nSTrkNjdiSceH+eihmYarDjL/6bZhOaqXt4bfHFr1DQuUb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=au4oZa1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="au4oZa1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01904C4CEE5;
	Tue,  8 Apr 2025 12:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114517;
	bh=/1wIcgrOhl1+uQKbwIOtKygS1iK60kGCuCVQT0YOZVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=au4oZa1o3l9vUsRQb4b8DQoFdrF6GX+lxM4ahmJzSspL/iAK3v0zOOs48FZjnjBQq
	 hugzzKJLzNErx8X77SG5n7S5KYHRVayJKRuW73gSvDMIN4+TZusRRVF0MXaRGf3py+
	 g/JjRGFRfYYUGGJ8/jE7yWADYITfM0UMhOsH82qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 137/499] libbpf: Fix hypothetical STT_SECTION extern NULL deref case
Date: Tue,  8 Apr 2025 12:45:49 +0200
Message-ID: <20250408104854.605858625@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit e0525cd72b5979d8089fe524a071ea93fd011dc9 ]

Fix theoretical NULL dereference in linker when resolving *extern*
STT_SECTION symbol against not-yet-existing ELF section. Not sure if
it's possible in practice for valid ELF object files (this would require
embedded assembly manipulations, at which point BTF will be missing),
but fix the s/dst_sym/dst_sec/ typo guarding this condition anyways.

Fixes: faf6ed321cf6 ("libbpf: Add BPF static linker APIs")
Fixes: a46349227cd8 ("libbpf: Add linker extern resolution support for functions and global variables")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20250220002821.834400-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index e56ba6e67451d..4acb5300d95d0 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -2044,7 +2044,7 @@ static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
 
 	obj->sym_map[src_sym_idx] = dst_sym_idx;
 
-	if (sym_type == STT_SECTION && dst_sym) {
+	if (sym_type == STT_SECTION && dst_sec) {
 		dst_sec->sec_sym_idx = dst_sym_idx;
 		dst_sym->st_value = 0;
 	}
-- 
2.39.5



