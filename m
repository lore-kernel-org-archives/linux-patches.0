Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C75F3EAC6F;
	Tue, 17 Mar 2026 16:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766134; cv=none; b=i3YIIwcv6zmHEo6qf9xgo5IGsOJMHFIUgNGJppVaB5mzVPbPT43qtmKuiAc7aKVlbQQKWbL5F0R7eOMhEnLLJoWl9GEgL46J2TYh+GpXg8IzwfIPHlW10fsZIcC1GduTbsXxQFdDtCTiRzaKCEijK9CZzXkwqXm8Y0ewWKeneeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766134; c=relaxed/simple;
	bh=8QsoubrzlAusww7SawyMtD48SZkyckKcya9yPWiJyHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaBYgtxB+YUOFr8l8sOG4TGsnU29uR94tbXyHIHp8y7Yyz63t89pxmVUwdYBJwybgBtMRuT8fTr6Hekx5I99E/vcPw/jZu6ARbXAYXAuFpvcCy7DSmBonsf0CJSE8k0QFF31RNe9TXZPS8aYGNRoUhYyNWs6Vx/IWKlatSyVjWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpDazdZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpDazdZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CF9C4CEF7;
	Tue, 17 Mar 2026 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766134;
	bh=8QsoubrzlAusww7SawyMtD48SZkyckKcya9yPWiJyHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpDazdZfrVIYwBLKTsvlEKQpjTmfmu+ocM5oTghfT6CZA1EnCZ73g6vl/fgt6ICyE
	 /h4AFB4BVkyKqgpmjuXhnz7PgGhrgXE65COWVmJyWFK/hpbM/lHFOebUIpyhU4Endq
	 5iGIOq4NkoT40pZ+MAnfZYRxuwFove3iA2iQFqqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 178/378] objtool/klp: Fix detection of corrupt static branch/call entries
Date: Tue, 17 Mar 2026 17:32:15 +0100
Message-ID: <20260317163013.555962511@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit f9fb44b0ecefc1f218db56661ed66d4e8d67317d ]

Patching a function which references a static key living in a kernel
module is unsupported due to ordering issues inherent to late module
patching:

  1) Load a livepatch module which has a __jump_table entry which needs
     a klp reloc to reference static key K which lives in module M.

  2) The __jump_table klp reloc does *not* get resolved because module M
     is not yet loaded.

  3) jump_label_add_module() corrupts memory (or causes a panic) when
     dereferencing the uninitialized pointer to key K.

validate_special_section_klp_reloc() intends to prevent that from ever
happening by catching it at build time.  However, it incorrectly assumes
the special section entry's reloc symbol references have already been
converted from section symbols to object symbols, causing the validation
to miss corruption in extracted static branch/call table entries.

Make sure the references have been properly converted before doing the
validation.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Reported-by: Song Liu <song@kernel.org>
Reviewed-and-tested-by: Song Liu <song@kernel.org>
Link: https://patch.msgid.link/124ad747b751df0df1725eff89de8332e3fb26d6.1770759954.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index 9f1f4011eb9cd..d94632e809558 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -1364,6 +1364,9 @@ static int validate_special_section_klp_reloc(struct elfs *e, struct symbol *sym
 		const char *sym_modname;
 		struct export *export;
 
+		if (convert_reloc_sym(e->patched, reloc))
+			continue;
+
 		/* Static branch/call keys are always STT_OBJECT */
 		if (reloc->sym->type != STT_OBJECT) {
 
-- 
2.51.0



