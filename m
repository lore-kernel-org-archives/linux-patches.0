Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD866377EDC;
	Fri,  4 Sep 2026 05:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501038; cv=none; b=MRPWj2g7Dlz+tKkp7EInzAUqyyEpgc2qbevsUiT6GK8YK6oa3kWlYZC/oo50mau4clYvJSSAJRYWIhMfu//rX2AWPFbAyAihaROgC9nlyb2LP86gmGrc+6V2vhQik+yMfUXuS2SCjouCJyMWiCsgNNf9P470WUqzalYQ0wdwqtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501038; c=relaxed/simple;
	bh=ugHSUGosk2CyXUiJifjfVmJKHRskBTfWuZNfQ/MO+0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FmL3O0Srw6/qetjv0P5VZnQCE4C71cy7m7XX8Io8ypJX9RnfORbQP4Xqt9s/XCF0PrtfB5UhxegBYHYHPMYvmWJK/qSQFV3d1Km932x+VMt/qKk88n8X926HHhhRhpFPd0DSuJXQzp0DG1E0rj4mwvRnv2qb9ifMqo5fl8GFkt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCe4Q2Qg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCe4Q2Qg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446751F00A3E;
	Fri,  4 Sep 2026 05:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501036;
	bh=DSNwGjw2IpcKIWSmNofoYwtO1aZ+wQIn7GByziZCd8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uCe4Q2QgdQVhfRYYigR2wyzGBBXD0AfL/wR+DRWjAZJ2Pw5aPapoU5SBtN6iPu2+T
	 rTGd+v2RXAdtTNYggGcjh0wSZFFZ5vSEfJs3Djs18mvN6HrpEZe6X9ioPCFH5+bRhs
	 41uUhOt5WOyoL9vNeOjlcb1+vBzOf0cK4tjpla3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thi=C3=A9baud=20Weksteen?= <tweek@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Petr Pavlu <petr.pavlu@suse.com>
Subject: [PATCH 6.18 269/552] module: validate string table section types
Date: Fri,  4 Sep 2026 06:57:06 +0200
Message-ID: <20260904045756.073322686@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thiébaud Weksteen <tweek@google.com>

commit 9a5ff45689329835f874cefe5174e577d141d423 upstream.

In elf_validity_cache_sechdrs, section sizes and offsets are validated,
unless the section type is SHT_NULL or SHT_NOBITS.

Later, elf_validity_cache_secstrings and elf_validity_cache_index_str
access the section name table (.shstrtab) and symbol string table
(.strtab) headers without first ensuring that their types are
SHT_STRTAB. If a section type is SHT_NULL or SHT_NOBITS, sh_offset has
not been validated and may reference out-of-bounds memory when
dereferenced in elf_validity_cache_secstrings or
elf_validity_cache_strtab.

Validate that both string section headers are of type SHT_STRTAB before
caching them.

Cc: stable@vger.kernel.org
Signed-off-by: Thiébaud Weksteen <tweek@google.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/main.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1958,6 +1958,7 @@ static int elf_validity_cache_sechdrs(st
  * Specifically checks:
  *
  * * Section name table index is inbounds of section headers
+ * * Section name table type is SHT_STRTAB
  * * Section name table is not empty
  * * Section name table is NUL terminated
  * * All section name offsets are inbounds of the section
@@ -1985,6 +1986,11 @@ static int elf_validity_cache_secstrings
 
 	strhdr = &info->sechdrs[info->hdr->e_shstrndx];
 
+	if (strhdr->sh_type != SHT_STRTAB) {
+		pr_err("Invalid ELF section name table type: %u\n", strhdr->sh_type);
+		return -ENOEXEC;
+	}
+
 	/*
 	 * The section name table must be NUL-terminated, as required
 	 * by the spec. This makes strcmp and pr_* calls that access
@@ -2151,7 +2157,7 @@ static int elf_validity_cache_index_sym(
  *        Must have &load_info->index.sym populated.
  *
  * Looks at the symbol table's associated string table, makes sure it is
- * in-bounds, and caches it.
+ * in-bounds and of type SHT_STRTAB, and caches it.
  *
  * Return: %0 if valid, %-ENOEXEC on failure.
  */
@@ -2165,6 +2171,12 @@ static int elf_validity_cache_index_str(
 		return -ENOEXEC;
 	}
 
+	if (info->sechdrs[str_idx].sh_type != SHT_STRTAB) {
+		pr_err("Invalid ELF symbol string table type: %u\n",
+		       info->sechdrs[str_idx].sh_type);
+		return -ENOEXEC;
+	}
+
 	info->index.str = str_idx;
 	return 0;
 }


