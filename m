Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49AE1FF7D1;
	Fri,  6 Dec 2024 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497097; cv=none; b=Lr/lhOnzjcum9v9D0v8lO7hZ1UyqHeXCp/mW6wgFYBKzvn90YeobLnBkKQzC6p4J/UbY17x/v+aiRr8fL8i/Qu4vaRf6jdfy/t5tlHZuQmLPsLVCOuMo4wCGdfxCcV1DSb9WWqhOAjPl0gjF3yKklvOpS4/idlPq/9ubz8XAu64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497097; c=relaxed/simple;
	bh=eB94w1RCwxEfzjyEc7NvzGVDXKDZWmXvp+MO8TnQr0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fOzrooHBqbxntbe/yjiUHvxvcOZefpxe2v1Q4uxVgvDBEL9I+lii2IVIfWqewiNHSjc0wD5P/nLMp+TWFTpwpoWy9ivp1dfr3TPRYDZrLnL8rYSM1aGyeGFqTHgnmWwGCA81wECXluxqx3hM1+eXIZusk9T0/Xaz2cwxifV/jPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awEvMxrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awEvMxrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE758C4CED1;
	Fri,  6 Dec 2024 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497096;
	bh=eB94w1RCwxEfzjyEc7NvzGVDXKDZWmXvp+MO8TnQr0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awEvMxrdRFpr+9TljfhGRdQNd3o4icwq3+LSOeA26S8PKmrBJc8nfLJCUOgykZNo4
	 5/o8rPrKGFlmL9GbOkRmpU3VQL70Gqt9FzHfUhN12KGJdZFJOCv76aMr8WrAcTL+A2
	 R1MyyTBU8mPEoP6Y3b5S4Avm77bZGtJb1l6fuoks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/676] libbpf: fix sym_is_subprog() logic for weak global subprogs
Date: Fri,  6 Dec 2024 15:30:13 +0100
Message-ID: <20241206143700.923258686@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 834b3e6bc72c3..d39b340222d61 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3586,7 +3586,7 @@ static bool sym_is_subprog(const Elf64_Sym *sym, int text_shndx)
 		return true;
 
 	/* global function */
-	return bind == STB_GLOBAL && type == STT_FUNC;
+	return (bind == STB_GLOBAL || bind == STB_WEAK) && type == STT_FUNC;
 }
 
 static int find_extern_btf_id(const struct btf *btf, const char *ext_name)
-- 
2.43.0



