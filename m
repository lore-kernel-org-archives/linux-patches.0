Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEA52210CA;
	Thu, 12 Dec 2024 16:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019221; cv=none; b=X6brTNyexNxJuz2gwMxwhgi9M+2jy3ZVQPJJRzFStera9/fq4Z4nyN+olLsdFdz72YIo55+/+xoAFg8ipiv5mpQq8nIt2e3cg3Fcjb0q7UBCJl3sXmpi1N+eL8KiVn0IIgRcNP8Lfx5FVZw0i4WgCfUUXhjFkJepl24jTiDJgec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019221; c=relaxed/simple;
	bh=aR2yPSPF1ZIgQLwmxjVAPG3tlzH8seS13Nh1ZnBGFfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofbqUViIjJgGZdVoU0yCtOZfTxuDRKCdYhNOIOvcQfAoDgrKiH3GqEB5qsX3m+J8bWFYr03DWzZ0RaEBHp8meI8wlFmz2f82+KVbfLi9IW8Rn8EjpQCPhYS7QVc0jpgO9QYMpjmLi/RPn1A48rIp+zsakcL0UwvM07uRc/8a3rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdcUzrzL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdcUzrzL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EB9C4CED4;
	Thu, 12 Dec 2024 16:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019221;
	bh=aR2yPSPF1ZIgQLwmxjVAPG3tlzH8seS13Nh1ZnBGFfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdcUzrzL/WVpxs9C0NZFQonLjNLok4ryYP1vGij8GM3XWcbZkV2kc7TV0avl8HykO
	 3tG3ILriedQGmPjb0Ms75tetukVf/vGp+J/s41qgBjCuCUvYw9jNeX5pPkvsREdd2K
	 egMOoC25AZoiTa4lSqRI3FSzSHjdLQGSem8WABAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/772] libbpf: fix sym_is_subprog() logic for weak global subprogs
Date: Thu, 12 Dec 2024 15:51:35 +0100
Message-ID: <20241212144356.135143879@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 4073213488be542f563eb4b2457ab4cbcfc2b738 ]

sym_is_subprog() is incorrectly rejecting relocations against *weak*
global subprogs. Fix that by realizing that STB_WEAK is also a global
function.

While it seems like verifier doesn't support taking an address of
non-static subprog right now, it's still best to fix support for it on
libbpf side, otherwise users will get a very confusing error during BPF
skeleton generation or static linking due to misinterpreted relocation:

  libbpf: prog 'handle_tp': bad map relo against 'foo' in section '.text'
  Error: failed to open BPF object file: Relocation failed

It's clearly not a map relocation, but is treated and reported as such
without this fix.

Fixes: 53eddb5e04ac ("libbpf: Support subprog address relocation")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20241009011554.880168-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 878f05a424218..d8b5304eac8cd 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3501,7 +3501,7 @@ static bool sym_is_subprog(const Elf64_Sym *sym, int text_shndx)
 		return true;
 
 	/* global function */
-	return bind == STB_GLOBAL && type == STT_FUNC;
+	return (bind == STB_GLOBAL || bind == STB_WEAK) && type == STT_FUNC;
 }
 
 static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
-- 
2.43.0



