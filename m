Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B801281AA8;
	Wed, 20 May 2026 18:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300949; cv=none; b=oH/F2ViBvJ4HDyUR9qGKDlY6uvJsV1fDGBhUSQiV8ze4yGTCPAQAqXU2Ejbkm1Y3/4kC4UCzMVuD3KmOtKGuxBIXPzVWjBraiZFj6/pD5eBUbMCzdMGbkSfRU2aXyjA77r7b+4BiePJPPYOnHyn5Qk0ItRT7w2Cm8q0wl1pzx64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300949; c=relaxed/simple;
	bh=MmK7kR9jvK0KDvsYjVfUgORB+Rm/Rc4GC9qohOmunq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXEnomhSeNpjrNazgIDbLuDYW9KmU3GdehsqDbrxByI7MoeVwOenWV7zf/IvcsloRmG39fQLoxYIlgzs571Mb2um5Hd2x12t+p16DqVSME3W+V4nJRAIG+w0gZC2D4j3exbGX5+BEjYmwvzhwhmzb7i9Fx1gmvJejy6+ed00tJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2JPy6nu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2JPy6nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B7D1F000E9;
	Wed, 20 May 2026 18:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300948;
	bh=W9ClstsVxDjzSLEl4/qUX5ZIF5u3LCTtVFOFhEbwf+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2JPy6nu7dbwu7csaGoaew1MWcPrkCd1misrD7Szva0O1r2GLlMqmZjY/gSph6z7+
	 lNiW+YBAZURK4TBH9U+TyAbrNGD6JSjpoyqQC7eod52zU8zGYp3ivCgs0so4ZjIanz
	 y3eDRJK+h9IOB6FYQpNDNaJceri8Twg7MNWQiHuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 369/666] perf tools: Fix module symbol resolution for non-zero .text sh_addr
Date: Wed, 20 May 2026 18:19:40 +0200
Message-ID: <20260520162119.239952996@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e398abfd13a09..61f931997f2ec 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1429,8 +1429,12 @@ static int dso__process_kernel_symbol(struct dso *dso, struct map *map,
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



