Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9620D344DB5;
	Sat, 12 Sep 2026 08:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203359; cv=none; b=WIkWgdDSMDTH+DpPWKKxoHO2RbTT/HqeKznHduI9KfUdxnOeylRPtxaPxPxLl8USg0hJhWsxqw7A4sH2xd5J/x4cK+y1cH1V/1csLRYfwoM2AcBS8FZRZ5uDGJH2t3pUgVpzOTsKy5hIZrgaLsWhd0Lo6nTvIizVdpsWhgxiPik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203359; c=relaxed/simple;
	bh=6EuUNGmmYSnj+VTwtAjL8yF18S2zPeQRA3RnalSMlYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqcsG0V3vi3ByLo33HuUYU20gRwMHmcYf6rG/+XYdch+WqE9ADpCxTSLvWKODo+aTiEG8ZW0imVRhTfNid5tY36FHSSDJD3W/fdy1DQb50UJdfZZ43Lq5zhI0ZHrhSsKkLlfToch2QQEt5JwKsXMtQP+hHP3vN16vH/NUesLWrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7GXv5te; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7GXv5te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E401F000FF;
	Sat, 12 Sep 2026 08:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203358;
	bh=EI6ZC5XeNWKE/HYdG1m714hHoZYXhHjO8jA12nzl6z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7GXv5tezFS0FmyeO1mRtB0uJ/ShOcr9NhEGoMsn3qrB6PTJsa5rQnyoyNMmZ9iQZ
	 6GCeijf/WTTkpbBOX4Mu6AOhCRFJZdVMXQHJbMBVg+asMGx9rBJgzGoCBdoBzQApQN
	 Vr0HndUSldo5ipb1Jr1GbNjZIFt9w9aBonQM07Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1392/1815] objtool/klp: Fix relocations for EXPORT_SYMBOL_FOR_MODULES() symbols
Date: Sat, 12 Sep 2026 08:52:22 +0200
Message-ID: <20260912065721.703248506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

[ Upstream commit 4cd3cfb8b54feca89a682720434092a87bfa4967 ]

EXPORT_SYMBOL_FOR_MODULES() puts a symbol in a "module:<names>"
namespace, which the module loader grants access to by matching the
importing module's name against that list.

klp_reloc_needed() only creates a klp reloc for module-owned exports; a
vmlinux export gets a normal reloc.  For a vmlinux symbol exported with
EXPORT_SYMBOL_FOR_MODULES(), using a normal reloc results in a modpost
failure in klp-build:

  ERROR: modpost: module livepatch-foo uses symbol mpol_shared_policy_lookup from namespace module:kvm, but does not import it.

And the modpost error is correct: even with that error removed, the
patch module would fail to load:

  livepatch_foo: module uses symbol (mpol_shared_policy_lookup) from namespace module:kvm, but does not import it.
  livepatch_foo: Unknown symbol mpol_shared_policy_lookup (err -22)

Treat it like an unexported symbol by using a klp reloc.

Note this only affects "module:" namespaces.  Ordinary namespaced
exports continue to work with normal relocs thanks to copy_import_ns(),
which propagates the patched object's import_ns tags to the patch
module.

Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diffing object files")
Reported-by: Joe Lawrence <joe.lawrence@redhat.com>
Link: https://lore.kernel.org/6a6608f4-0a05-4d75-8b7f-edddfac9c5d4@redhat.com
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Song Liu <song@kernel.org>
Link: https://patch.msgid.link/fe5a00818e06ec613344d41d5944de054fcd8832.1786138493.git.jpoimboe@kernel.org
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/klp-diff.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index a7cdba08b1deb..ffa83dd88d0b0 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -30,7 +30,9 @@ struct elfs {
 
 struct export {
 	struct hlist_node hash;
-	char *mod, *sym;
+	char *mod;
+	char *sym;
+	bool mod_ns;
 };
 
 bool debug, debug_correlate, debug_clone;
@@ -135,7 +137,7 @@ static int read_exports(void)
 	}
 
 	while (fgets(line, 1024, file)) {
-		char *sym, *mod, *type;
+		char *sym, *mod, *type, *namespace;
 		struct export *export;
 
 		sym = strchr(line, '\t');
@@ -162,6 +164,14 @@ static int read_exports(void)
 
 		*type++ = '\0';
 
+		namespace = strchr(type, '\t');
+		if (!namespace) {
+			ERROR("malformed Module.symvers (namespace) at line %d", line_num);
+			return -1;
+		}
+
+		*namespace++ = '\0';
+
 		if (*sym == '\0' || *mod == '\0') {
 			ERROR("malformed Module.symvers at line %d", line_num);
 			return -1;
@@ -188,6 +198,9 @@ static int read_exports(void)
 			return -1;
 		}
 
+		/* EXPORT_SYMBOL_FOR_MODULES() */
+		export->mod_ns = strstarts(namespace, "module:");
+
 		hash_add(exports, &export->hash, str_hash(sym));
 	}
 
@@ -1175,11 +1188,16 @@ static bool klp_reloc_needed(struct reloc *patched_reloc)
 	 * clusterfunk that is late module patching, the patch module is
 	 * allowed to be loaded before any modules it depends on.
 	 *
-	 * If exported by vmlinux, a normal reloc will do.
+	 * If exported by vmlinux to all modules, a normal reloc will do.
 	 */
 	export = find_export(patched_sym);
-	if (export)
-		return strcmp(export->mod, "vmlinux");
+	if (export) {
+		if (strcmp(export->mod, "vmlinux"))
+			return true;
+
+		/* EXPORT_SYMBOL_FOR_MODULES() gets a klp reloc */
+		return export->mod_ns;
+	}
 
 	if (!patched_sym->twin) {
 		/*
-- 
2.53.0



