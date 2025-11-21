Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFC41B4F0A;
	Fri, 21 Nov 2025 13:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731429; cv=none; b=BsGTiYwVSFFeHyeVLryvSpcDcQ2u5yGna8fIecLqIWvXRPH8k+6DEhX2o0JO/tz+nq6qQHHCTJBtEVmFuJXyXhpQPhuBMoqhPc1uJZfaU7mjVBwi47nxqJgIt0kEaYfTBxMASpF7LCD1wDs8l5w2kzEu7HfE40NrtfMY+8ChoGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731429; c=relaxed/simple;
	bh=yfS3EvT6Y//BB/W1zQqlDZVv+gbrHlbNwctfmbwcuIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y42SbXJecTM/ToxvhrhyGo2vJQo844FkCxfVg00kZ+1sVFAx0EAh+k5HIJNn2Op4rKPXy6JyVtJ8iOqIzMa5zKFK8ARzy+f0lQioXVt2AHzqVGDRVjRDk3rHj4BTDhLCsGG/HmoaYtg+EUFCcgAxXPeMoFXFtJDrhct77mj7m24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9c9hWSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9c9hWSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B1BC4CEF1;
	Fri, 21 Nov 2025 13:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731427;
	bh=yfS3EvT6Y//BB/W1zQqlDZVv+gbrHlbNwctfmbwcuIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9c9hWSyZobPTe9U9lnUP1jHwvVnzQEvnHv+AFmTN/GfNHGjAu8vIHJ2qMjYQ1OZq
	 pnhK64IrFsr2dzNCD3gzlNpylPqxc65+t1firiws/4iWb0f/KiooP8ID+T3pqDweVg
	 EhutXKRm9/9Rl8p+VjKtlYC4+5Vn0QNyxN4971xQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyue Wang <haiyuewa@163.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.17 205/247] gendwarfksyms: Skip files with no exports
Date: Fri, 21 Nov 2025 14:12:32 +0100
Message-ID: <20251121130202.082183496@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sami Tolvanen <samitolvanen@google.com>

commit fdf302e6bea1822a9144a0cc2e8e17527e746162 upstream.

Starting with Rust 1.91.0 (released 2025-10-30), in upstream commit
ab91a63d403b ("Ignore intrinsic calls in cross-crate-inlining cost model")
[1][2], `bindings.o` stops containing DWARF debug information because the
`Default` implementations contained `write_bytes()` calls which are now
ignored in that cost model (note that `CLIPPY=1` does not reproduce it).

This means `gendwarfksyms` complains:

      RUSTC L rust/bindings.o
    error: gendwarfksyms: process_module: dwarf_get_units failed: no debugging information?

There are several alternatives that would work here: conditionally
skipping in the cases needed (but that is subtle and brittle), forcing
DWARF generation with e.g. a dummy `static` (ugly and we may need to
do it in several crates), skipping the call to the tool in the Kbuild
command when there are no exports (fine) or teaching the tool to do so
itself (simple and clean).

Thus do the last one: don't attempt to process files if we have no symbol
versions to calculate.

  [ I used the commit log of my patch linked below since it explained the
    root issue and expanded it a bit more to summarize the alternatives.

      - Miguel ]

Cc: stable@vger.kernel.org # Needed in 6.17.y.
Reported-by: Haiyue Wang <haiyuewa@163.com>
Closes: https://lore.kernel.org/rust-for-linux/b8c1c73d-bf8b-4bf2-beb1-84ffdcd60547@163.com/
Suggested-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://lore.kernel.org/rust-for-linux/CANiq72nKC5r24VHAp9oUPR1HVPqT+=0ab9N0w6GqTF-kJOeiSw@mail.gmail.com/
Link: https://github.com/rust-lang/rust/commit/ab91a63d403b0105cacd72809cd292a72984ed99 [1]
Link: https://github.com/rust-lang/rust/pull/145910 [2]
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Haiyue Wang <haiyuewa@163.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251110131913.1789896-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gendwarfksyms/gendwarfksyms.c | 3 ++-
 scripts/gendwarfksyms/gendwarfksyms.h | 2 +-
 scripts/gendwarfksyms/symbols.c       | 4 +++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/gendwarfksyms/gendwarfksyms.c b/scripts/gendwarfksyms/gendwarfksyms.c
index 08ae61eb327e..f5203d1640ee 100644
--- a/scripts/gendwarfksyms/gendwarfksyms.c
+++ b/scripts/gendwarfksyms/gendwarfksyms.c
@@ -138,7 +138,8 @@ int main(int argc, char **argv)
 		error("no input files?");
 	}
 
-	symbol_read_exports(stdin);
+	if (!symbol_read_exports(stdin))
+		return 0;
 
 	if (symtypes_file) {
 		symfile = fopen(symtypes_file, "w");
diff --git a/scripts/gendwarfksyms/gendwarfksyms.h b/scripts/gendwarfksyms/gendwarfksyms.h
index d9c06d2cb1df..32cec8f7695a 100644
--- a/scripts/gendwarfksyms/gendwarfksyms.h
+++ b/scripts/gendwarfksyms/gendwarfksyms.h
@@ -123,7 +123,7 @@ struct symbol {
 typedef void (*symbol_callback_t)(struct symbol *, void *arg);
 
 bool is_symbol_ptr(const char *name);
-void symbol_read_exports(FILE *file);
+int symbol_read_exports(FILE *file);
 void symbol_read_symtab(int fd);
 struct symbol *symbol_get(const char *name);
 void symbol_set_ptr(struct symbol *sym, Dwarf_Die *ptr);
diff --git a/scripts/gendwarfksyms/symbols.c b/scripts/gendwarfksyms/symbols.c
index 35ed594f0749..ecddcb5ffcdf 100644
--- a/scripts/gendwarfksyms/symbols.c
+++ b/scripts/gendwarfksyms/symbols.c
@@ -128,7 +128,7 @@ static bool is_exported(const char *name)
 	return for_each(name, NULL, NULL) > 0;
 }
 
-void symbol_read_exports(FILE *file)
+int symbol_read_exports(FILE *file)
 {
 	struct symbol *sym;
 	char *line = NULL;
@@ -159,6 +159,8 @@ void symbol_read_exports(FILE *file)
 
 	free(line);
 	debug("%d exported symbols", nsym);
+
+	return nsym;
 }
 
 static void get_symbol(struct symbol *sym, void *arg)
-- 
2.52.0



