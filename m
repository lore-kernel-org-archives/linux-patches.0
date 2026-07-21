Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FF835DA40;
	Tue, 21 Jul 2026 19:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662770; cv=none; b=AStejUSZWh906j/ma79vfSVJklGtTra3Bf1beiN+lPHvxRTA6i7hGOGix2S5gAOGlIP61aliR9t/lSX0lWv9pNdTIcHcSpDGHBPQg79lDrNzWVMFiTA1dp4R5us65i5HJqM8dCD1RezYNACXxWaryqiqSu8uRHRgF7svnHYeWd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662770; c=relaxed/simple;
	bh=SEakxacbF5IxvTaUf5PCEVYVmTHIbih40XsbWLbDwh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptB7Wh2JC+tB14kCDDRKRsaRhJv5w7bbvQquXVda/4RVkE4FNewEsKAePAyTD0UCUNSj9hJRP8cC3F8Xkmc5lbiaPDVP+s52J8V/XmJff7NRD6/LwFD5rmEXsPL/heBXPcVN77m3rvb4jJZMfkxHQK6UfjXjrcKRfijzciLiI3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmrJ9E+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmrJ9E+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFEA1F00A3A;
	Tue, 21 Jul 2026 19:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662769;
	bh=cPy4bAsslYGAlmoJQTYwRwdKowvZaWnW3DD0V7BDCJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmrJ9E+OzwgJIQ/exT5kgMD6iS0+XT8OcAKgE31CPwgcJOfxZqRWfLUzBDddicG67
	 BWY7QE1Dj2G0Kw2LHoUssS0wJN0pvpO3d55AFltWsHam0chWQZu83eyqfO6cG3+gxp
	 aSFyjrM2ex3+zsXL2lYsDBc3PkcwdpcLzZ4HMs8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0553/1276] perf symbols: Validate p_filesz before use in filename__read_build_id()
Date: Tue, 21 Jul 2026 17:16:36 +0200
Message-ID: <20260721152458.495037234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 2a3716544359d4312c81b0fa909a13301186da17 ]

filename__read_build_id() stores ELF p_filesz in a ssize_t variable.
A crafted 32-bit ELF with p_filesz = 0xFFFFFFFF produces ssize_t value
-1.  The comparison `p_filesz > buf_size` evaluates false because signed
-1 is less than any non-negative buf_size, so the realloc is skipped and
buf remains NULL.

The subsequent read(fd, NULL, -1) returns -1, which equals p_filesz,
passing the error check.  read_build_id() then dereferences the NULL
buffer.

Add an explicit check for p_filesz <= 0 before using the value,
catching both zero-length and sign-wrapped negative sizes from crafted
ELF files.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: ba0b7081f7a521d7 ("perf symbol-minimal: Fix ehdr reading in filename__read_build_id")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 68f5a2622bd8bc..f6bef8fcc75f97 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -179,6 +179,9 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 			continue;
 
 		p_filesz = elf32 ? hdrs.phdr32[i].p_filesz : hdrs.phdr64[i].p_filesz;
+		/* ssize_t can go negative with crafted ELF p_filesz values */
+		if (p_filesz <= 0)
+			continue;
 		if (p_filesz > buf_size) {
 			void *tmp;
 
-- 
2.53.0



