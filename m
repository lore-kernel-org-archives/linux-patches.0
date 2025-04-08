Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B69269AE4;
	Tue,  8 Apr 2025 11:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113265; cv=none; b=SFy5wF1QA91lhzrvUtSPMJx0OOyCXpghBF05eQuLXRr6VTZj8nYzGD3DGB5WtsRMLjpblb5suAHdcv17/r9uGEQr7DKiaJ6MnHpFZDy7b0grSRKzm+w2JhVeQVbcZcC8ctFS2xrRMt45mSmCL1wnGXUghYoWeXn+8bjgd4qpI2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113265; c=relaxed/simple;
	bh=4WWF+CUJhHLmrT/n0pio0DB6uy54GHmv0enJMwmNer8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9nBhyf8F1xbJ9dFX/ExR+9u6EbodMiwKTrTb65SCsgodnUJwnz+STx4eZ9xwA8GC//tRLg/dazx6DzqhiAFyUQBtbc3khXdeQBBRJFc+c0Pr0Gvnzofgq98eS539Z/dpJfQZ7A+pmRQJGVRHcQ97YloLBwrzpBeIVcdNfMTsN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgvWPPVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgvWPPVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337B3C4CEE5;
	Tue,  8 Apr 2025 11:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113265;
	bh=4WWF+CUJhHLmrT/n0pio0DB6uy54GHmv0enJMwmNer8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgvWPPVIFTi/k7YLufCCFh3pjI0DbS5CvLBFat6eZ8kUcjg1e3vtHxscpamBc1HiQ
	 X1Y9Xha3eX9yRSiTbusMx6CCfvprLR9TM/i7Zg0IjucBrhcLeOFi63E9eSuUQr5B70
	 EECdrrDbqjU+ZcRlG3UXi6XF44oBNvjcDDbiNLs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/268] libbpf: Fix hypothetical STT_SECTION extern NULL deref case
Date: Tue,  8 Apr 2025 12:47:59 +0200
Message-ID: <20250408104830.330568989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 736ebceea233f..a3a190d13db8a 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1974,7 +1974,7 @@ static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
 
 	obj->sym_map[src_sym_idx] = dst_sym_idx;
 
-	if (sym_type == STT_SECTION && dst_sym) {
+	if (sym_type == STT_SECTION && dst_sec) {
 		dst_sec->sec_sym_idx = dst_sym_idx;
 		dst_sym->st_value = 0;
 	}
-- 
2.39.5



