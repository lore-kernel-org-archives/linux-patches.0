Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027FB4EB851;
	Thu, 17 Sep 2026 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659096; cv=none; b=ffiqUUEr8wDwGGbhNX92aFOkfxgDIU6eT+qPOcHmsYkn48E/qsChJdL48jr41iJZexE0TFwtfu6ywbAcfxR3PTGTKWDxha+r6zoOuNNqWFpjt4OekKbtvKPhJbBf2SXMqNWY2LVc9B1xHnzmeb4cgowrirCwPnZJizvz/BlEzWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659096; c=relaxed/simple;
	bh=FYo7bArUqt9+BPITrfjoeyatpziYYEcfsOYoNbK6oqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVut1ssvwughnhd04sOkB/+mKJ0WISN5vHcWQwfWb4cIdXI7Ig/lJA8O213wrmFBLm3yQqRDbWjWEV2Zo1hZPJEZIMToDprzKNLYl15W2X+GklO8XEWmtssgEpvW7mojjCOfqqE76bacqfNWThCX5SELNKDk+TghlHxwjZKRs/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBqE9PJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBqE9PJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083291F00893;
	Thu, 17 Sep 2026 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659087;
	bh=mbFWzaSrh4OO0/Ql9V/pQGLJSMBvykjSxH89fi3PI3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBqE9PJlx7Ibbo+DM8uveq14WEs+iOrgd1K7iwAOGj9fH+6O6I4fj0yadluEXp3on
	 DQScfF8/bEybMpRpfmqd44fSs9fDV//2NdFyUMlgRtppa/TBGX96BD+ZthT+Sg8Sdn
	 cWDrdZrbkOtZIyZl13LG21zir3vqx3iWWC+mSN2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 139/733] objtool/klp: Fix checksums for constant pool references
Date: Thu, 17 Sep 2026 16:07:27 +0100
Message-ID: <20260917151354.497941245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit ac323c9467092479dc1e5bc138c9abbe015b0069 ]

Adding a line of code to __link_shadow_page() with a literal string
causes a false positive changed function with GCC:

  arch/x86/kvm/kvm.ko.o: changed function: kvm_tdp_mmu_map_private_pfn

While the patch only touched __link_shadow_page(), the string addition
triggered a rename of .LC64 -> .LC65 in kvm_tdp_mmu_map_private_pfn()
even though the underlying referenced constant data didn't change.

So for .LC* symbols, the suffix is arbitrary but the data isn't.  Add
the underlying data to the checksum calculation rather than the symbol
name.

Clang also uses .LC* symbols, but also uses anonymous data.  Both
compilers put this data in .rodata.cst<num> sections.

Fixes: 0d83da43b1e1 ("objtool/klp: Add --checksum option to generate per-function checksums")
Link: https://patch.msgid.link/f3a9e74ceebc6475ce94bcfe985401140857814a.1787939301.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-checksum.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/objtool/klp-checksum.c b/tools/objtool/klp-checksum.c
index b8e47f28997e9..ebe25f9c5260a 100644
--- a/tools/objtool/klp-checksum.c
+++ b/tools/objtool/klp-checksum.c
@@ -54,6 +54,19 @@ static int checksum_debug_init(struct objtool_file *file)
 	return 0;
 }
 
+/*
+ * Detect a reference to anonymous constant pool data which the compiler places
+ * in .rodata.cst<num> and which either has an .LC<num> symbol associated with
+ * it or (with Clang) no symbol at all.  These are typically initializers for
+ * local function stack data, so they're considered part of the function rather
+ * than data per se.
+ */
+static bool is_anonymous_const_data(struct symbol *sym)
+{
+	return strstarts(sym->sec->name, ".rodata.cst") &&
+	       (is_sec_sym(sym) || strstarts(sym->name, ".LC"));
+}
+
 static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 				 struct instruction *insn)
 {
@@ -129,6 +142,14 @@ static void checksum_update_insn(struct objtool_file *file, struct symbol *func,
 		goto alts;
 	}
 
+	if (is_anonymous_const_data(sym)) {
+		void *cst;
+
+		cst = sym->sec->data->d_buf + sym->offset + offset;
+		__checksum_update_insn(func, insn, cst, sym->sec->sh.sh_entsize);
+		goto alts;
+	}
+
 	if (is_sec_sym(sym)) {
 		sym = find_symbol_containing(reloc->sym->sec, offset);
 		if (!sym)
-- 
2.53.0



