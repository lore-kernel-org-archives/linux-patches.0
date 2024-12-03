Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ABB1F7070;
	Tue,  3 Dec 2024 15:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238471; cv=none; b=mFVJKEZCaQrxTKg1srRvSoLHE5jpLGC4Ohs1UcNREqTeifC5b0b81JUGY2bfyX3jIRWEtSzJf+iH5WIRj1qvWLAU7TYQa+6nLYSJ36y6Byh0ROEXkh3cCKStRHfTnlcLmikch1MttNawNP7RDcgqumm7qwNDYanH7zNaEIR24Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238471; c=relaxed/simple;
	bh=cKq/fa7Do4iFuPilynyp5ztYzt3DFWBjJ4HG6izOWt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxUnILyPYl98zid9VN/juUS4sm9hONWRQ9PV1ITckfdrg9OSz0maJUXdhaIR4vZ6qyRUN1AkLAaYuygcSTIkTTaWUgtCVvCCcFWdfgfubtwGFEraNWrGGv63bNmf3cahzKr8TFeFxSEkDPaRzIgTXn8F0twoeCArZ11wvDawMJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EA9aYMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EA9aYMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856E0C4CECF;
	Tue,  3 Dec 2024 15:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238470;
	bh=cKq/fa7Do4iFuPilynyp5ztYzt3DFWBjJ4HG6izOWt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EA9aYMfsw4hbySfgxJ6XMOnY5FjWUUq1lH71iwBby3PllnbQLeIDj9mOVjOgcp64
	 8ksWkRdR6nbTbb0j1p19OjLva90mo+TcjgWtEduy1QPBptCnd9s6BUuqVdRCtGlXSA
	 N9x/JA0EgQlK1NMuXnPFFMcft8xqitwkoIDlptsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 271/817] libbpf: fix sym_is_subprog() logic for weak global subprogs
Date: Tue,  3 Dec 2024 15:37:23 +0100
Message-ID: <20241203144006.374872071@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 22b8317b57036..98a6cc304bb21 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3985,7 +3985,7 @@ static bool sym_is_subprog(const Elf64_Sym *sym, int text_shndx)
 		return true;
 
 	/* global function */
-	return bind == STB_GLOBAL && type == STT_FUNC;
+	return (bind == STB_GLOBAL || bind == STB_WEAK) && type == STT_FUNC;
 }
 
 static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
-- 
2.43.0



