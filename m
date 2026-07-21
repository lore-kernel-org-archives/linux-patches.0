Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BD0415F1A;
	Tue, 21 Jul 2026 19:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662741; cv=none; b=SDmTTWypbgMfR62oBI6q4+bykR3qgbsLfftXoKlLyqhU8z/j2zuzAh/VmYezkVmuJ/iCKlqDfCCx+CFB6MH8QV+js8QRGhHx3BmSuQQk1AAGyW4JaunQz90tkCwQg2oYjSLCV9D5Oki5CFVfAY7XRD/6xQvgDSQoW0f0s+l5BIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662741; c=relaxed/simple;
	bh=PkLmXGyRuEndCMr6u4aKNTSVpujmS1P4FtdKfxodvUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGx1MM/lLVGtWgQf3WP+HFmRDqbvuSdmit12kxbncO0hbqrf9qgRkpW6BwnPHFx8c5N3Ldtxmw5FqVQK+iHqcAz6xfSPSYpgsxMfb/Mq/GcueZzLkawUHegft2oq2TIZ40yaqKfH3ApPybqDUwPEU0ftcBe9vq3ydXmsRLna0rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqrKjCJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqrKjCJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C080B1F000E9;
	Tue, 21 Jul 2026 19:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662740;
	bh=mBlwbs9KajQk/8Qr6PFxzvzh6HSXPKSs5R03Utatcxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqrKjCJY4mZXTlrS8TCDi4uRQjYqSPYNfok5MlVkPnKel7ri86YY71I1Kc0dI9kdf
	 yc9T5nQrQjqcTY0y01KBFLLSDXhLkBvB9vlQVS5sx3AjW4VOVFyZQKQXURC27yh+Eg
	 KWwNQK4DnOsHozTQXkNoer7tkVyPu/N4OeHMLi8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0552/1276] perf symbols: Fix bswap copy-paste error for 32-bit ELF p_filesz
Date: Tue, 21 Jul 2026 17:16:35 +0200
Message-ID: <20260721152458.473486488@linuxfoundation.org>
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
index 12ef02bbf2eea8..68f5a2622bd8bc 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -168,7 +168,7 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
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



