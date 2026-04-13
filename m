Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28E3225A38;
	Mon, 13 Apr 2026 16:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097875; cv=none; b=XlyRXT9rGHsUduXMUvYQtaxtPxPOg5vNW/H6cHq4g8yLTmyQFXlaiw1MzOOoDJ3lxL1t2D1dFzCihMmYRzdPgIrhfEqO38B0tutGW/k9CuSVJQefBAruIv0iAXGb5nO9lmY1W+LfwMYdKXxyg//rngEz5Kn/bcLCBxt8xD1BMY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097875; c=relaxed/simple;
	bh=OC2OO2sSH15hZNbSNQwvtc/zaZRGdIvcXZyFZnaqJ2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GM/Sk9Q5wyB2CBcErqQP0AyQfIwa8VaxHRj1LCy2hw0MYdd+Ao4wsRXH9iBRCR6yU/GrftqsJbZSkcJE+C4pTkPMOojREar7LrTz0C73/op1OwHQsi/tveUhzo52SbGlndGdQOHevqivHOXTfr373JYwQUfP3hjPb+/wMIDKWi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TeUH9PlP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeUH9PlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D15C2BCB3;
	Mon, 13 Apr 2026 16:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097875;
	bh=OC2OO2sSH15hZNbSNQwvtc/zaZRGdIvcXZyFZnaqJ2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeUH9PlPg431WLj9C815Lsx4uP+W8ZiMckgtcVDVk/nVuLxGSIkxotOAMMzkH2+or
	 Iq24U+ZpI+zoUK8Ee0d+Ohl/mO2e9n+lBbP2SJSla+cSkrKVq+dKsD+BuWSQyYewp5
	 Avaxzt/r+Bgz7wQlkygDubnDtsEVp2XemloRlBgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Daniel Gomez <da.gomez@samsung.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/570] module: Fix kernel panic when a symbol st_shndx is out of bounds
Date: Mon, 13 Apr 2026 17:57:18 +0200
Message-ID: <20260413155841.999331414@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ihor Solodrai <ihor.solodrai@linux.dev>

[ Upstream commit f9d69d5e7bde2295eb7488a56f094ac8f5383b92 ]

The module loader doesn't check for bounds of the ELF section index in
simplify_symbols():

       for (i = 1; i < symsec->sh_size / sizeof(Elf_Sym); i++) {
		const char *name = info->strtab + sym[i].st_name;

		switch (sym[i].st_shndx) {
		case SHN_COMMON:

		[...]

		default:
			/* Divert to percpu allocation if a percpu var. */
			if (sym[i].st_shndx == info->index.pcpu)
				secbase = (unsigned long)mod_percpu(mod);
			else
  /** HERE --> **/		secbase = info->sechdrs[sym[i].st_shndx].sh_addr;
			sym[i].st_value += secbase;
			break;
		}
	}

A symbol with an out-of-bounds st_shndx value, for example 0xffff
(known as SHN_XINDEX or SHN_HIRESERVE), may cause a kernel panic:

  BUG: unable to handle page fault for address: ...
  RIP: 0010:simplify_symbols+0x2b2/0x480
  ...
  Kernel panic - not syncing: Fatal exception

This can happen when module ELF is legitimately using SHN_XINDEX or
when it is corrupted.

Add a bounds check in simplify_symbols() to validate that st_shndx is
within the valid range before using it.

This issue was discovered due to a bug in llvm-objcopy, see relevant
discussion for details [1].

[1] https://lore.kernel.org/linux-modules/20251224005752.201911-1-ihor.solodrai@linux.dev/

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/module.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/module.c b/kernel/module.c
index 2226b591b52e0..07fa34461fa2f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2347,6 +2347,13 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 			break;
 
 		default:
+			if (sym[i].st_shndx >= info->hdr->e_shnum) {
+				pr_err("%s: Symbol %s has an invalid section index %u (max %u)\n",
+				       mod->name, name, sym[i].st_shndx, info->hdr->e_shnum - 1);
+				ret = -ENOEXEC;
+				break;
+			}
+
 			/* Divert to percpu allocation if a percpu var. */
 			if (sym[i].st_shndx == info->index.pcpu)
 				secbase = (unsigned long)mod_percpu(mod);
-- 
2.51.0



