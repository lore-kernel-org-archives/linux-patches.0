Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CCC151988;
	Wed,  5 Feb 2025 14:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766248; cv=none; b=j+CBtY6ikHuosscAOOLhMSUGaeyUyLXbIPZDXfVQUe7dH9eT4A+Jpn+rqB+A1nbGOcaR9G/07hT6obZzO3x5n6en7cFbeb4gWoPo+bqdWkQehAm+R/uwsBNvqdCN4GAek+zMydI7HKZGMN/Vguhna3H8AMMvxirVXvSM5ZtaJBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766248; c=relaxed/simple;
	bh=1dGhHwqr7BMQIixNVwg66GffDIiV0jX2ci7alnltxlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6FfOhF3c2AfiBMIDNky4W6g/rtiiLD9HJqwBVkNTWDSr60+ZbyK3/a7SkL9P/M9AnPwsXQTs6DaXL+dCaD6m/9oCfMgF5zWIuYlSl6efgjGT64gHhWtA7zt1D+TNBbb8rHqXyy8DKCsy3NDNsab9MgeXOIbvNvvwhuKVoQdYZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWjllTyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWjllTyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE99C4CED1;
	Wed,  5 Feb 2025 14:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766248;
	bh=1dGhHwqr7BMQIixNVwg66GffDIiV0jX2ci7alnltxlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cWjllTywfwE+dimzRfrYew9INpl3GLQ1r34quLzQOlRc6nAv8dcFeYPW6QOrTyWnr
	 Ox7qoAJATRVsbSlF7TY2dajUiTWQo+318FEWElB3K2IQvR2CpsTC4WJpmfC54HRfwY
	 CZnC74dcf9brd1Kos7dp1jYIX/sCo4iajiBHY9PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Monnet <qmo@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 256/623] libbpf: Fix segfault due to libelf functions not setting errno
Date: Wed,  5 Feb 2025 14:39:58 +0100
Message-ID: <20250205134506.025190593@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index cf71d149fe26a..e56ba6e67451d 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -566,17 +566,15 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
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
 
 	/* Linker output endianness set by first input object */
@@ -606,9 +604,8 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 	}
 
 	if (elf_getshdrstrndx(obj->elf, &obj->shstrs_sec_idx)) {
-		err = -errno;
 		pr_warn_elf("failed to get SHSTRTAB section index for %s", filename);
-		return err;
+		return -EINVAL;
 	}
 
 	scn = NULL;
@@ -618,26 +615,23 @@ static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
 
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
@@ -2680,14 +2674,14 @@ int bpf_linker__finalize(struct bpf_linker *linker)
 
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



