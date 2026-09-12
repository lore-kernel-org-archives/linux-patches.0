Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A37379982;
	Sat, 12 Sep 2026 11:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211317; cv=none; b=lhJxpPKCjJUhaABqEhIlNRpQ6rdJgDRBrz9OlLyLlEBHhKsSXy04iP/YBuefr8EQ5gZJ1PatlN3Dg7UPlX6eqFHJ+4MHiziUTUEU7lyaL4tlD7Pl/oWUhBEBR8QcSQs7YgtmeEsrqwCR7mv7eBflhBTvST6/T5XUyv9x2waTvPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211317; c=relaxed/simple;
	bh=CNA7BNIy6NPSBIUMODNkDPR+vyZb1oq5M1ex2A/S2js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEr5GMzWvvOQKP3hNqi/xSNlxKs3sx87LYrIGD6A5+fd5ZncJxUho+zL9n05AsEM3UUzcUbCb9FwKBpDy0pTDrlp845ghaHwXBX+MF4Jzr3J8UakovJgbDgeEO9Ezl7CAmGBvOjjUmeBBUUHO0MPL5+nkfsmkv5OrAcey+X6qu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9i+EUwq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9i+EUwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577931F000FF;
	Sat, 12 Sep 2026 11:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211316;
	bh=OQzeQf8NQl9uhrXxwJd+Wly0Kf+4dV3hjH6JAv1yUVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k9i+EUwq0YXnquRfVRyNWIqDeQJD3BPF1slNXRnAV1Ld8OkLKv8b9WcRQr/get1JD
	 AGfpbdSa2gvYBzWH5RnFh5NepxZNIJynMS5mr2HYUL7xax2DEnDnpiPPQ66LtqngBI
	 GkG9ZA8yWkHwkrc2WAT3lzx5eEekua4Q967giV5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Song Liu <song@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1207/1518] perf dso: Replace assert with runtime check in dso__read_symbol()
Date: Sat, 12 Sep 2026 08:56:16 +0200
Message-ID: <20260912065650.792656423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 62972e5644e48255dcc715e6ec4401882f8b37d1 ]

dso__read_symbol() asserts that len <= jited_prog_len, where len comes
from sym->end - sym->start (parsed from PERF_RECORD_KSYMBOL in
perf.data).  Both values originate from untrusted file input.

With NDEBUG (production builds), the assert is compiled out, allowing
an out-of-bounds heap read when the BPF program buffer is accessed.
Without NDEBUG, a crafted perf.data crashes perf with an assertion
failure.

Replace the assert with a runtime bounds check that returns NULL with
an appropriate error code, matching the existing error handling
pattern in this function.

Fixes: aa04707f507e ("perf dso: Support BPF programs in dso__read_symbol()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Song Liu <song@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 7df9a88c24e04..70daf4fd200e3 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1963,7 +1963,12 @@ const u8 *dso__read_symbol(struct dso *dso, const char *symfs_filename,
 			errno = SYMBOL_ANNOTATE_ERRNO__BPF_MISSING_BTF;
 			return NULL;
 		}
-		assert(len <= info_linear->info.jited_prog_len);
+		if (len > info_linear->info.jited_prog_len) {
+			pr_debug("BPF symbol length %zu exceeds jited_prog_len %u\n",
+				 len, info_linear->info.jited_prog_len);
+			errno = SYMBOL_ANNOTATE_ERRNO__BPF_MISSING_BTF;
+			return NULL;
+		}
 		*out_buf_len = len;
 		return (const u8 *)(uintptr_t)(info_linear->info.jited_prog_insns);
 #else
-- 
2.53.0



