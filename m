Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D86421EE4;
	Tue, 31 Mar 2026 16:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976297; cv=none; b=XU6zKwg6uuPEjsX7iUtO73rOOh3Wr5rM2oDlINggnP0r+jyRYqhbadz0GPSAILFQIJnsikLCJujs2qUsu0Jmv0cRkSFTRywWUpAJ/L7f4FZP5i/F8yC+EOO6hl5fPUvToquLLE1YI71D8K1zON+6ghAIJHUb2sozvInrXz9SUlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976297; c=relaxed/simple;
	bh=iS1Pgej5NtIQi0iE9ulUkXshKQ5rXQhaz1ptDgLsScg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAtI0CPoULEiYeoIZUBnSGn3Vv4kDHtoTAZEq95K/uzTflOwpHvxsbtaMQXUjmt9smiI7zRMKlp9DCjYUuMkEyOYz3o47jjT1jhTjxgZfQ2qXXqK/yYWk4Z0lTSSr1YCQ67uTsq7BFzdWfWcpqn9LvV5C4Glby8Bibs/XMsTJtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AHRGzpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AHRGzpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD43C19423;
	Tue, 31 Mar 2026 16:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976297;
	bh=iS1Pgej5NtIQi0iE9ulUkXshKQ5rXQhaz1ptDgLsScg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AHRGzpi+K4sy8L1UElQ3qG8Ote6/oBCV7VI55E8vUuglw83JbP7G6MBamYDxvJ3h
	 sq5BBaQQTL9jvBdvGRi9YNxK/Y5CEjhu7EYtlsAMQyPkGzZ+lqSehfnGkCf5fosU90
	 JTxvC/flF5RlsvV+FaVzSszzHrUd8WCn2kbJmx5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Daniel Gomez <da.gomez@samsung.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/309] module: Fix kernel panic when a symbol st_shndx is out of bounds
Date: Tue, 31 Mar 2026 18:19:02 +0200
Message-ID: <20260331161754.921633538@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/module/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/module/main.c b/kernel/module/main.c
index a2c798d06e3f5..66d4efbddfffe 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -1568,6 +1568,13 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
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



