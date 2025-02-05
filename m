Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C098522A;
	Wed,  5 Feb 2025 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765676; cv=none; b=UKwoU4sL1Le5l9w0eI+W2rQx/LuIjSKvLGZ/rvZEllIOc5ZWCJAE3Js57XMVM8x2XUVo9byGoE3G3/lR/PKGGv65JNnigbUt/1B3vzG064ZAwGvOfKh0sFo0nBIjNbAqYC1li9Z8WeGEm3fZOkS4LV+cg9wjHqiSD6FiWEbE8ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765676; c=relaxed/simple;
	bh=c4rUz57uZ6mBkg/5D1lfYV78nHn99ayzC/rc83dL+i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFDtuRxoFUZlF3aDKMGkjlatEnFz/sGkmjC+G5qNl2nHfQIV3pZrzDTf4iLwLk9bphp04TQhN6PUPO0c9cFl7NkJc61IZac0z70hZDOCfredBgkl2ew8rgaVj4/XP0083ZXNMi7EHR7d3w0qLMnxeDRVG+Cea3DbO/1aVESiKX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keCyoPEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keCyoPEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F31C4CED1;
	Wed,  5 Feb 2025 14:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765676;
	bh=c4rUz57uZ6mBkg/5D1lfYV78nHn99ayzC/rc83dL+i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keCyoPEgzWtRMA0T5GqQsKHbe61vLYFinlaYBtG1rX1nRaECjmoc++2+uTgPbSq/9
	 LdTncLNuth4W7gatdbwuHZ/sCMPMAZgLM+nrzwKtojCBgJkMBY6jbsj3N7ec5RK/fN
	 mMvHn0qah12kPT2olMY+1L2oV5Wjc3eSuQ9LigN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <qmo@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/590] libbpf: Fix segfault due to libelf functions not setting errno
Date: Wed,  5 Feb 2025 14:39:57 +0100
Message-ID: <20250205134504.540892946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Quentin Monnet <qmo@kernel.org>

[ Upstream commit e10500b69c3f3378f3dcfc8c2fe4cdb74fc844f5 ]

Libelf functions do not set errno on failure. Instead, it relies on its
internal _elf_errno value, that can be retrieved via elf_errno (or the
corresponding message via elf_errmsg()). From "man libelf":

    If a libelf function encounters an error it will set an internal
    error code that can be retrieved with elf_errno. Each thread
    maintains its own separate error code. The meaning of each error
    code can be determined with elf_errmsg, which returns a string
    describing the error.

As a consequence, libbpf should not return -errno when a function from
libelf fails, because an empty value will not be interpreted as an error
and won't prevent the program to stop. This is visible in
bpf_linker__add_file(), for example, where we call a succession of
functions that rely on libelf:

    err = err ?: linker_load_obj_file(linker, filename, opts, &obj);
    err = err ?: linker_append_sec_data(linker, &obj);
    err = err ?: linker_append_elf_syms(linker, &obj);
    err = err ?: linker_append_elf_relos(linker, &obj);
    err = err ?: linker_append_btf(linker, &obj);
    err = err ?: linker_append_btf_ext(linker, &obj);

If the object file that we try to process is not, in fact, a correct
object file, linker_load_obj_file() may fail with errno not being set,
and return 0. In this case we attempt to run linker_append_elf_sysms()
and may segfault.

This can happen (and was discovered) with bpftool:

    $ bpftool gen object output.o sample_ret0.bpf.c
    libbpf: failed to get ELF header for sample_ret0.bpf.c: invalid `Elf' handle
    zsh: segmentation fault (core dumped)  bpftool gen object output.o sample_ret0.bpf.c

Fix the issue by returning a non-null error code (-EINVAL) when libelf
functions fail.

Fixes: faf6ed321cf6 ("libbpf: Add BPF static linker APIs")
Signed-off-by: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241205135942.65262-1-qmo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 6985ab0f1ca9e..777600822d8e4 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -567,17 +567,15 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 	}
 	obj->elf = elf_begin(obj->fd, ELF_C_READ_MMAP, NULL);
 	if (!obj->elf) {
-		err = -errno;
 		pr_warn_elf("failed to parse ELF file '%s'", filename);
-		return err;
+		return -EINVAL;
 	}
 
 	/* Sanity check ELF file high-level properties */
 	ehdr = elf64_getehdr(obj->elf);
 	if (!ehdr) {
-		err = -errno;
 		pr_warn_elf("failed to get ELF header for %s", filename);
-		return err;
+		return -EINVAL;
 	}
 	if (ehdr->e_ident[EI_DATA] != host_endianness) {
 		err = -EOPNOTSUPP;
@@ -593,9 +591,8 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 	}
 
 	if (elf_getshdrstrndx(obj->elf, &obj->shstrs_sec_idx)) {
-		err = -errno;
 		pr_warn_elf("failed to get SHSTRTAB section index for %s", filename);
-		return err;
+		return -EINVAL;
 	}
 
 	scn = NULL;
@@ -605,26 +602,23 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 
 		shdr = elf64_getshdr(scn);
 		if (!shdr) {
-			err = -errno;
 			pr_warn_elf("failed to get section #%zu header for %s",
 				    sec_idx, filename);
-			return err;
+			return -EINVAL;
 		}
 
 		sec_name = elf_strptr(obj->elf, obj->shstrs_sec_idx, shdr->sh_name);
 		if (!sec_name) {
-			err = -errno;
 			pr_warn_elf("failed to get section #%zu name for %s",
 				    sec_idx, filename);
-			return err;
+			return -EINVAL;
 		}
 
 		data = elf_getdata(scn, 0);
 		if (!data) {
-			err = -errno;
 			pr_warn_elf("failed to get section #%zu (%s) data from %s",
 				    sec_idx, sec_name, filename);
-			return err;
+			return -EINVAL;
 		}
 
 		sec = add_src_sec(obj, sec_name);
@@ -2635,14 +2629,14 @@ int bpf_linker__finalize(struct bpf_linker *linker)
 
 	/* Finalize ELF layout */
 	if (elf_update(linker->elf, ELF_C_NULL) < 0) {
-		err = -errno;
+		err = -EINVAL;
 		pr_warn_elf("failed to finalize ELF layout");
 		return libbpf_err(err);
 	}
 
 	/* Write out final ELF contents */
 	if (elf_update(linker->elf, ELF_C_WRITE) < 0) {
-		err = -errno;
+		err = -EINVAL;
 		pr_warn_elf("failed to write ELF contents");
 		return libbpf_err(err);
 	}
-- 
2.39.5



