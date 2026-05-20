Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B4D3F9F25;
	Wed, 20 May 2026 18:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302405; cv=none; b=NnnlUWSIpkRpZ7bCdVYzr5K89Z7/Lb6f65+O3ADFrr9Yci/hAcZZUY2wD13yZwCsJjP41l9BrQQnyv4IIsj0z2h5dQ0ZlQrkq5bSKKWWGaMhIl+yt+3Mh/YjBrK9mcgOUh+lsYc+Mc7FG5c5NvsDUucaJrHEAeK2+3jMM8yOyp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302405; c=relaxed/simple;
	bh=KqhE7GwdsijGDr3d07CaAr1K/TGvcyCBVipeg6cSQ1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJGSNEXQ+6EbOQmqkzryhnuvupRy1HRiSIp6xQNQQLibXxTX0TWqkIfcbfwEqh8SY+GgMKtgPR/MSjH5OAquC6vgoi2YBW2Bbl6dygoUgoywKjcYid21Rmqn+CttjnIt3z1u2oy7doDyo1vM48NvuxOtwDmErCF3WlaTCoqgjLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kU7dsXAv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kU7dsXAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99CA31F000E9;
	Wed, 20 May 2026 18:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302404;
	bh=Lq90IA04Bl8KUTjFfAYg5Fiu/2j7jNyZ6lZ2qmg4Kbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kU7dsXAv8sJwQKqVFVDxRs/LnzCVcKkS4CQ9kn0JdM6AlGEPW5Ij/zuOWfQaZnWU0
	 ZAIw7OahmgQ460LubGnNkoYUzcitsDhgsbnBeRaL801puP8X5IbywWFI4K26eC0LJH
	 yNu6ckzAmQhpqWLs1k7M4MVlS0TUbYyddISjvkaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/508] perf tools: Fix module symbol resolution for non-zero .text sh_addr
Date: Wed, 20 May 2026 18:21:15 +0200
Message-ID: <20260520162104.108780851@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 95e99c332d7e3..af610cb00a987 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1375,8 +1375,12 @@ static int dso__process_kernel_symbol(struct dso *dso, struct map *map,
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
 
 	if (strcmp(section_name, (curr_dso->short_name + dso->short_name_len)) == 0)
 		return 0;
-- 
2.53.0



