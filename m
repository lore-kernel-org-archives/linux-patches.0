Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D830B265CD3;
	Tue,  8 Apr 2025 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116358; cv=none; b=g0DH61cHZgc1ZHeLQGjQ504fnvbINEjePRYQLMGJnntpQnknZfi3nzpiWfFLdI36fXkSxWUaQZQCTcD0TqNjwMju7v3pd5QholIpNDIUBqiMdSRo42F4Pc4+UqpNcYLsFy5grTcUAN9UxgUIK0W5fkscMohARUDFBbFCnWKs2j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116358; c=relaxed/simple;
	bh=3lMr7QZc8QF9y8+Gu/teSSJxwzCLwbx+CC5L2gyJiBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4r3DMX4WCETUIualm5116OJ5MO+3EzOpDVxYKMd5CcTyjj0tij2INDCi2MsV+MzJ0qK806kq3784uX/G6XOBOnlJwQNCmR7GJBWzoWn4dVdQpPG/bHkQLK1Fap85YxHpuEDY38ev7GEAXeWZZem/MhFXGEXfbyyyHJuwpTWs9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NDGQFgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NDGQFgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DD9C4CEE5;
	Tue,  8 Apr 2025 12:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116358;
	bh=3lMr7QZc8QF9y8+Gu/teSSJxwzCLwbx+CC5L2gyJiBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NDGQFgB7RtSPWWeZP0igMjfs5d2v+aVvKwUe+vZIkstSse93txFpcS0sv0eDuEYH
	 cODbAbjjA5AG6gurgJkav+3dIQYqArHSiUxFHoCLZo4TUfdyoPGilXeT62DQIwmdaj
	 clZEjx57D0rHV4NMjk/Ikb60CYs+ffTGGO/+BEhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/423] libbpf: Fix hypothetical STT_SECTION extern NULL deref case
Date: Tue,  8 Apr 2025 12:47:17 +0200
Message-ID: <20250408104848.317583660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 777600822d8e4..179f6b31cbd6f 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -2007,7 +2007,7 @@ static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
 
 	obj->sym_map[src_sym_idx] = dst_sym_idx;
 
-	if (sym_type == STT_SECTION && dst_sym) {
+	if (sym_type == STT_SECTION && dst_sec) {
 		dst_sec->sec_sym_idx = dst_sym_idx;
 		dst_sym->st_value = 0;
 	}
-- 
2.39.5



