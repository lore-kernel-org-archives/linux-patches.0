Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DCA38B133;
	Tue, 21 Jul 2026 18:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657450; cv=none; b=IrizFMNSkfQUvQI0sbCmJtoCpEJ5OQYb/wFehe937iaEr96hZkvMf1kmpLUlIe00TMvchYOHQ+2qnkLIvcNEbCMAmsC+C0SaBH1C752V5qFUy0GtGUifCapy9Cupw54OafGhXdaRTFfXkBbzvy5U5mrBPP9n2UaWXaocSpOCVUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657450; c=relaxed/simple;
	bh=rHvT7x1opVHyBnE4S27TdFYYkRxqOvkSer3NMjnFBNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7D6vjCmMdSXrPsAeJlbyK8F3uyf9RmwfPNt+yLe5D2tFZReWGLO36XvLLp/+qmKj7jqCClRHi1fhCjZ0XNlWl7fHgewm3bI8tj9X5eYZ8IBcfTREOBaSG97cK/yyP2dSQ0TUQEYhefOIAj7Ts5R20BpcB8cTqcoxcjHoqAq0W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKEMart0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKEMart0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADC71F000E9;
	Tue, 21 Jul 2026 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657449;
	bh=TlkDucEQHxFd7Oo0Kb88rzu7+/i+AgPCm6H86r2NSJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKEMart0wk7uj77os6Xe+5CThEllJmtSKUEpFUB7WdMtHQ4XeqiMmr922k0Oz3f2t
	 QqCTNTHnrU6SbAXLr2ugj+Db0E1q6+dwYIcVaDFOWB7A6JWvPP3zhqvaqfIo9juHZ1
	 b9enlzR/nAKsafZwUxb61RReF/dCuzR/4AByXYbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0769/1611] perf symbols: Fix bswap copy-paste error for 32-bit ELF p_filesz
Date: Tue, 21 Jul 2026 17:14:45 +0200
Message-ID: <20260721152532.682031773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 081b387c7397498c583b1ba7c2fdaf4c6da6b538 ]

filename__read_build_id() byte-swaps 32-bit ELF program headers on
cross-endian files, but line 178 passes p_offset to bswap_32() instead
of p_filesz:

  hdrs.phdr32[i].p_filesz = bswap_32(hdrs.phdr32[i].p_offset);

This clobbers p_filesz with the already-swapped p_offset value.  The
64-bit path on line 182 is correct and swaps p_filesz from p_filesz.

The consequence is that the PT_NOTE segment read uses the wrong size,
which can cause either a short read (missing the build-id) or an
oversized read (reading past the segment into adjacent data).

Fix by swapping the correct field.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: fef8f648bb47726d ("perf symbol: Fix use-after-free in filename__read_build_id")
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 6080d85047e339..39b806651b9258 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -168,7 +168,7 @@ int filename__read_build_id(const char *filename, struct build_id *bid, bool blo
 			if (elf32) {
 				hdrs.phdr32[i].p_type = bswap_32(hdrs.phdr32[i].p_type);
 				hdrs.phdr32[i].p_offset = bswap_32(hdrs.phdr32[i].p_offset);
-				hdrs.phdr32[i].p_filesz = bswap_32(hdrs.phdr32[i].p_offset);
+				hdrs.phdr32[i].p_filesz = bswap_32(hdrs.phdr32[i].p_filesz);
 			} else {
 				hdrs.phdr64[i].p_type = bswap_32(hdrs.phdr64[i].p_type);
 				hdrs.phdr64[i].p_offset = bswap_64(hdrs.phdr64[i].p_offset);
-- 
2.53.0



