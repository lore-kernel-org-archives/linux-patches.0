Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38C1267B89;
	Tue,  8 Apr 2025 11:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112825; cv=none; b=IbnynT+yA1Y8CCoYaYDVdYcte7AHNxKCvrPZap2/81DWO7klfoV8RpviuPK02Z+7FQLBzWPNC0sVoGnL4GUaUOasanLq3HVb1LwcTjeu7xX4DbWSxfTQ1A70/1gDX8bXY6iV6pRbJ7Kn/hgtoENnTRIjOOihgaKBF7Z9C+QKlN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112825; c=relaxed/simple;
	bh=xiIBBEbjTMWtNx1A/4Og4aumWQEY8JGb01wjfWUlj5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXqGLcbvRsGtfhrf/IOe+YWJ1cXkjLSCc4K2s7UuJqi8TfO4MtXIqrDHdjbawhLvoa9q6jk61zuZ/sphSU8HBEOWH/2e/qYikW0e6LUSSfRh9u4bAqh1tCUD4xHmqT4hCIg39MEpWr4eBJndDUKM0W3fntWW47lPGfjpCSMpzgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IQZqpuO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IQZqpuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8249BC4CEE5;
	Tue,  8 Apr 2025 11:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112824;
	bh=xiIBBEbjTMWtNx1A/4Og4aumWQEY8JGb01wjfWUlj5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IQZqpuOki0Vzs+axajMqks31DjTcj+wIZmN90Ofp+ZKU+OWaOByKyade4H57odIV
	 Wx23rApXNrhktVl8hC3s30S8b+Q2i359XmsXI3nB1BBm8NiMmf5weaDLfLF4jCbCBa
	 5Tsun5JtJKg+U7WDSWdNbj0RBESh5BkRS1rr/F/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/279] libbpf: Fix hypothetical STT_SECTION extern NULL deref case
Date: Tue,  8 Apr 2025 12:49:14 +0200
Message-ID: <20250408104830.946648016@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2adf55f487430..fc91814a35e8e 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1966,7 +1966,7 @@ static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
 
 	obj->sym_map[src_sym_idx] = dst_sym_idx;
 
-	if (sym_type == STT_SECTION && dst_sym) {
+	if (sym_type == STT_SECTION && dst_sec) {
 		dst_sec->sec_sym_idx = dst_sym_idx;
 		dst_sym->st_value = 0;
 	}
-- 
2.39.5



