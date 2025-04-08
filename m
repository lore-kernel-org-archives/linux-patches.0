Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC12266583;
	Tue,  8 Apr 2025 11:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111266; cv=none; b=S9w9PqVV2PS0GdD78d0YBqps1uramK2+AWof+JfUd1wiA+KtqNfFet4Wh4tpJ39WP5eVGjokt74MO2wuZxlN9RrUzv7Kyh82Gk2BmiMMOox6iAM4qjhW5cqkGy4FAbZbhdC1YPUwpeVWkbSBZy1+Sc43nCu3xvX/J6YIuVeDclA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111266; c=relaxed/simple;
	bh=zzrwjQb9fril+1GqNpCyGI4leZpUb4z9/Bjb3e24KaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRvBHHqvRIzXt7OjBFXVGqWBCU105f6n5XKnzEwDFjnun6UeuKnzyyI3bJBI8r1CnKBi2955lWGZE52NfGGGRnL4Jxm8S1NxA96Y6kxMn2nGfU95qp5Q5zoJC36HTryVbTGPhCcw24nafqBlx3IYyaMCCnWOcDPpDcDv0bszQ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDIncQnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDIncQnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07240C4CEE5;
	Tue,  8 Apr 2025 11:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111266;
	bh=zzrwjQb9fril+1GqNpCyGI4leZpUb4z9/Bjb3e24KaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDIncQnHysMeYJOaqjqJLJbIObB2y9g7pdcUJC4ckY2czqgR4XAwyeqlN5VI4+Ug5
	 Bov2TjumwxGvd9CSDUs/0EbRJi5DA1eXHdMoCrJ0Swz8GMSd3fQxi//quNpHN9g1VS
	 c7HncYcMQiibTrLcWtq6+bkHiyC09JkjBiLlPvp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 368/731] libbpf: Fix hypothetical STT_SECTION extern NULL deref case
Date: Tue,  8 Apr 2025 12:44:25 +0200
Message-ID: <20250408104922.836266069@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index b52f71c59616f..800e0ef09c378 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -2163,7 +2163,7 @@ static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
 
 	obj->sym_map[src_sym_idx] = dst_sym_idx;
 
-	if (sym_type == STT_SECTION && dst_sym) {
+	if (sym_type == STT_SECTION && dst_sec) {
 		dst_sec->sec_sym_idx = dst_sym_idx;
 		dst_sym->st_value = 0;
 	}
-- 
2.39.5



