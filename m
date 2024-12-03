Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB0E1F75B6;
	Tue,  3 Dec 2024 15:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240915; cv=none; b=JVssb/hGoPBifog88LoUQIInARp6WGvsIelh/14gd2KWibrpNKoPuPgEfWFfmUuy+ohzJuLcoVfonWKjPkS63fwGEj5SXgfmV9p8/QSPpLI7rqedS/K5i8qencLUDvIXli7JdQ+1nSwryMkcjFBuZRFMOvNTSYrq3K2+spF0FC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240915; c=relaxed/simple;
	bh=LP4b7/JAZDVsjdGIFJsh+AJRYUjxQd7jiUjS0adELzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZeuPVnSMYczQgZBvcQQvPVNKNcx6ggArqv34QDAXXq9Blf3RPEcctkVdEwyIBGyiOWb4lrf2nOILGzxtspkBGK+zR5mjthFCThZtbbps7xxZezFvh8qvvW5msiUzRUCUw4eMUg9grfwS9TkaJWJvG2QflcO6yKd1rrp6LwOEOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TTcgNRG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TTcgNRG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291F7C4CECF;
	Tue,  3 Dec 2024 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240915;
	bh=LP4b7/JAZDVsjdGIFJsh+AJRYUjxQd7jiUjS0adELzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TTcgNRGhRYaK/JlVniZximJe9MvIxWA2nRqhw9li5bb3+FyxPVnmrtMnMuOFFOzp
	 tN5KoupNCGCqKgYWwKnDKoqtAlWJ89v1Q7OE99+Vnz1t2osF00SL3tHCRjasK1fMBd
	 8wctElNsGUviavQ32sF/yEp27uBzp27v6sQ3BSvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/826] libbpf: fix sym_is_subprog() logic for weak global subprogs
Date: Tue,  3 Dec 2024 15:39:29 +0100
Message-ID: <20241203144753.205121416@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 04389d00849f7..dde03484cc42c 100644
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



