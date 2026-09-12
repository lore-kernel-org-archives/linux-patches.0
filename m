Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEFC299920;
	Sat, 12 Sep 2026 09:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203763; cv=none; b=ORjNA2lyCO+JhEHtsh2KPonAJXfOIRck4ATQLWZIOtbQmEAxrKVv4hB8VB/AAS7AoMbxe1/Qw79f7BHNqKL/QkHsgQpqs/K3VQ48BoOhuWXGMOeZ8Cd6Zs3j4I5lNS1HRS3xlk3k5kWV3eOoLbKqvLtsGrxtbpESxxMlIx3+9oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203763; c=relaxed/simple;
	bh=He7/4KJvBpYs1gRyCXH20QZxxXg5g5U14JBvsr58QKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWfFFH4RrIOatSwx9X0fBjDmQ07aJyD+TjONyuBb5vD/kUkTNJx8LRHxxLyz66zVqSc4y959DUZfMKRQrLyaW1g0vZ/SHpgeQm0q5fYDxAlymtgbltTHuWFrZVBAMuqWcKDOE/yvziMAPYI+9jDU5nsEOFHsY26XS+9D3j0B97s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vxyRbH+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vxyRbH+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8821F000FF;
	Sat, 12 Sep 2026 09:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203762;
	bh=HBne8Py8nA9Jg+MK+szQNTdS+5rQYcymKtBh+HSdhIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vxyRbH+unPONu0YgNTZXXe70YDIF8afiWN6aE35fk1gfW8Zd3x3oDWnHXBpztIkw/
	 Ko3fnPJgboG2CnP6IEyeX7SoZkAxvXwM+r5p2bgl3sbNfYKoVvHwCCeZhVq7bbDxYT
	 hhlQuoBE8UCbA4WBMFwz3W/X8WbxKS6ifffGVWRY=
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
Subject: [PATCH 7.2 1475/1815] perf dso: Replace assert with runtime check in dso__read_symbol()
Date: Sat, 12 Sep 2026 08:53:45 +0200
Message-ID: <20260912065723.635280828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4dd64069c4348..42bfe30a3b518 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -2038,7 +2038,12 @@ const u8 *dso__read_symbol(struct dso *dso, const char *symfs_filename,
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



