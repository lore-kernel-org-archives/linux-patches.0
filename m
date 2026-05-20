Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869973EAC83;
	Wed, 20 May 2026 17:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298707; cv=none; b=Q0yUtnyfmB9KZT93td3ksTnVA1PFUNyvFhPiAHUN/Bj6oRcasNVr8dDzFkoc3SgFc8vreDWs/C9INHTnmlSEOzmdYOLgo03H9AUI1NmVO7ev45FQKAwNlURP4s+YdFo2HM7f4NG5SaAnUcutGHscPcJVOdRyLl2SyVi8oI7JHPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298707; c=relaxed/simple;
	bh=wFDXRMUw2lgUWols9qyrAed8O5Wsh7TsyFNSva5Au/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAo4afTLIS9K526EjyJoyPRKYP55JQwfxmTr94K1KPxiR4a2gwIJw/pso4/kbJprbnjNQLQHKWlqNEHGN1lOrsu9pls4oT7ADvGl88jZv63/QWFNRG4R/M2yIFmA3WmcAjavdJgbnM/iU5Q7bURWNjnnVFL2cYjLifZR85F+RQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5Q77QKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5Q77QKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8CE1F000E9;
	Wed, 20 May 2026 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298706;
	bh=WjDKAceowVOAGiLffgfdlRTM+QJcaq6z2Ud/j4ktnMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5Q77QKIYGy3nABkBYiGnoW8Pha7Ubz1gtm0Eh9eBCW1IwQsE75QXuu77nncfXLaz
	 U1XY+HsuYJL5uYgXOK0TXg88JVCJdnadTnsTBaN2cggMNKtK3pD5NKGIX9i39b14vh
	 EX4lxmZ7uN8rAzE4btcdbSprSw/jH9Si5Mzx1FlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 512/957] perf tools: Fix module symbol resolution for non-zero .text sh_addr
Date: Wed, 20 May 2026 18:16:35 +0200
Message-ID: <20260520162145.640355114@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 9a82bfde4775b7a87cd1a7e791f46f83ae442848 ]

When perf resolves symbols from kernel module ELF files (ET_REL),
it converts symbol addresses to file offsets so that sample IPs
can be matched to the correct symbol. The conversion adjusts each
symbol's st_value:

  sym->st_value -= shdr->sh_addr - shdr->sh_offset;

For vmlinux (ET_EXEC), st_value is a virtual address and sh_addr
is the section's virtual base, so subtracting sh_addr and adding
sh_offset correctly yields a file offset.

For kernel modules (ET_REL), st_value is a section-relative
offset. The module loader ignores sh_addr entirely and places
symbols at module_base + st_value. Converting to file offset
requires only adding sh_offset; subtracting sh_addr introduces an
error equal to sh_addr bytes.

When .text has sh_addr == 0 -- the historical norm for simple
modules -- both formulas produce the same result and the bug is
latent. As modules gain more metadata sections before .text (.note,
.static_call.text, etc.), the linker assigns .text a non-zero
sh_addr, exposing the defect. For example, nfsd.ko on this kernel
has sh_addr=0xa80, kvm-intel.ko has sh_addr=0x1e90.

The effect is that all .text symbols in affected modules
shift by sh_addr bytes relative to sample IPs, causing perf
report to attribute samples to incorrect, nearby symbols. This
was observed as 13% of LLC-load-miss samples misattributed
to nfsd_file_get_dio_attrs when the actual hot function was
nfsd_cache_lookup, approximately 0xa80 bytes away in the symbol
table.

Use the existing dso__rel() flag (already set for ET_REL modules)
to select the correct adjustment: add sh_offset for ET_REL,
subtract (sh_addr - sh_offset) for ET_EXEC/ET_DYN.

Fixes: 0131c4ec794a ("perf tools: Make it possible to read object code from kernel modules")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 9d62386464680..9602cc51dcc65 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1353,8 +1353,12 @@ static int dso__process_kernel_symbol(struct dso *dso, struct map *map,
 	char dso_name[PATH_MAX];
 
 	/* Adjust symbol to map to file offset */
-	if (adjust_kernel_syms)
-		sym->st_value -= shdr->sh_addr - shdr->sh_offset;
+	if (adjust_kernel_syms) {
+		if (dso__rel(dso))
+			sym->st_value += shdr->sh_offset;
+		else
+			sym->st_value -= shdr->sh_addr - shdr->sh_offset;
+	}
 
 	if (strcmp(section_name, (dso__short_name(curr_dso) + dso__short_name_len(dso))) == 0)
 		return 0;
-- 
2.53.0



