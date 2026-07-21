Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B370B385D67;
	Tue, 21 Jul 2026 19:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660672; cv=none; b=nv6T0+fCQOeBtQb1uGFUCnM4jRbt1Kj/11/2v4Cb0SGor/O2dmIgpbLHW1ChDLpBCVaLhlgXrTXP/Yi4cR6YD/C4zbddfbgn4gQ5L2A6WqJfagNOl7+o3dyvfX0m3JxyXJrrDLjnUyqjY96DaSsisZkbX1fM2L4EY38I+mXWLYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660672; c=relaxed/simple;
	bh=x2LxWbuUYXev4EtBbuHrayrFlnoUTjtBJb98nIcDMs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg0YpoG/iXrOVtlnYDwSnbSyCfwnpxY0RgLnd6t6BigY8MvjYBiqYboC7pKlkjD+4T46pmtpDaQznOZLgYQoboPevTQO+v01+sS0xd8u6gBy5Ck+7r64sjdWiscqs4DYZzOMbgaFCuye+I8TN61t9Dfxc+jWzRhWgthLw9TtYqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWArc4Mj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWArc4Mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56301F000E9;
	Tue, 21 Jul 2026 19:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660671;
	bh=trO0zse+L5Cex2lPBK5W2gRjWDl+DEq49nUlxnTFnP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWArc4MjEpaNhYs3YqDaP7sFPCTcOeU06pAmmLDsSYsHb1NhOJbFg0wAeD4KXk1Vj
	 csZxG9cr/Juo+d1zC5+TtCjOAknKljujqdUH0wMxF2T1O83e4KOkuWUsOpd1YUGbi4
	 9mYwNe2wM3LIDjV6CSANt3K3jBrpS5Ux4lh9tCjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1069/2077] perf symbols: Fix bswap copy-paste error for 32-bit ELF p_filesz
Date: Tue, 21 Jul 2026 17:12:22 +0200
Message-ID: <20260721152618.033635081@linuxfoundation.org>
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
index 091071d06416e2..f4b0a711a62cf3 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -175,7 +175,7 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
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



