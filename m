Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F1B39A7FD;
	Tue, 21 Jul 2026 19:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660675; cv=none; b=FkAqdLLeBuz2acSnhezmJVad7jRUAPQ4qGAU5QSVE7XnBMbHrMKCp/GHlv2TPzVfmbyShTgoEBI38rlz24CaZwsSnSvWSbB9nBKKzuk5hv6fNPE9M7v+hNeKpFAevBO5dVV26KpmAWsVntapVTVhrGzwxg2w1brOOkNURUcY/DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660675; c=relaxed/simple;
	bh=GHp9nG39VyrAtUHvCF0Nng+aCFvHMWV8DEF3hh05kc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgEsve7FtabDPp7Eh/IMlhFsjBgU+61ZkKFD1HEafEvq0ZNuWtG9+Ese8UVqlbLACWeb6mcPWpm1u6Bcwyx+FKzBMlRpCILrXwXojrTg7plyAH/t29AaymPefyYyPvgmN3p8lL/dAzOWDOd8clXbrAYYAksacVjtc1zfMwNF4co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XinAkazi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XinAkazi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9201F000E9;
	Tue, 21 Jul 2026 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660674;
	bh=5q7bHbw2h6UkHdVrCzssFUCFC3NIoh+zn3hbgijeK1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XinAkazi0yh44Y1uV1QT4Xy5IInYIvrgeFKIxbKiK1bemnQC71obQ8LsBJ2tCgbLa
	 rDUyU7l5ht4v2+zeTZY/B1W9FxK0l6vb9W26Ssq1JnTohCR1/CNCRxmou77MkNnGZb
	 7YlkBakEnTH12AKgW6kdJh3KV/bWLkpM1wNyyJlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1070/2077] perf symbols: Validate p_filesz before use in filename__read_build_id()
Date: Tue, 21 Jul 2026 17:12:23 +0200
Message-ID: <20260721152618.059854269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f4b0a711a62cf3..0a71d146395271 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -186,6 +186,9 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 			continue;
 
 		p_filesz = elf32 ? hdrs.phdr32[i].p_filesz : hdrs.phdr64[i].p_filesz;
+		/* ssize_t can go negative with crafted ELF p_filesz values */
+		if (p_filesz <= 0)
+			continue;
 		if (p_filesz > buf_size) {
 			void *tmp;
 
-- 
2.53.0



