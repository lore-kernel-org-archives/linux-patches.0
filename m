Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625364;
	b=YBtMGYNckXfcmJZ8Rbftb78sOf0ed/O+3LVa2PQUkyDL1MnxEeZ0H6DqfFmHM+d3Iz74
	 PQsYOXnlkiPGKfb8x5no8wGVIsUHtKMSlr9e8c97PzBnBSwuWaScthm3ab2cvh6Il/mH3
	 aJ7Vttc/d5U4+qSzXRHH7seqgdcjUJnZeAwbfCVz0LxZZia2nYpbrhLY1iZgpknsW5k32
	 zyFwLznH9mkmuMBhl+luvXj55kBO/W+BCw0rCxA0nzQOQw6adgi9hoH2uu6ENula0I7kk
	 +9zhLQf95i40Of5c/sXleUIJ2kYULWQIfZ/DcIXsnAhN57l37l22Far1FXx4OkxYEhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kjuw07BZ6duFllt0bqzJSauNSRtP09D5pcFdAW0DR44=;
	b=TgkPtLv5lNmn7H/rwPdBmXXUk+ChLra5iRLYkAPR1bigRe1UwXig5M9N/0DVU4EIFaeq
	 0/QPIV930F11MAqunZq+NCsYmmC9omma3UVfk34Pog4LsYJf5KaqEWGSnzuCx7eCaPWis
	 +iJe2RtuZzJuaVh1sPceDnR9xdFvO0WMW8a0w2duFfejTVBDSLONfkrijkKI5peOB6AM+
	 jS/bs5SqOjJgKVTaIrxclDwJ1lr/QcfY7fCwGfRimizV7zWZq33Cr9cryiKtX/MO5B78i
	 Hr64jFE3My5Rcb0cXUk2A30X7sph2qCagZcguqsI8Il/lo6miJIKmNiZrQTHNqblWNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrrsxB+C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA70606A31E;
	Wed, 25 Nov 2026 16:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lrrsxB+C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6B91F000CF;
	Wed, 25 Nov 2026 16:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625364;
	bh=Kjuw07BZ6duFllt0bqzJSauNSRtP09D5pcFdAW0DR44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrrsxB+COQSc0gVeTZO4oZzowxVetS8NhOqggQQBZOkSfXiZ+szeAcT5fAdjM657S
	 cM1vwkyoQeWp2i95QApIxK6rGxaH8FlcXMWpajO6l/oGd4A1+xom/dg20dTmP/ZuO8
	 Q5DdOHJ3e8TmLukC0pCTXGETm8flFBpbJLage5K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Remi Bernon <rbernon@codeweavers.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 492/816] perf symbol: Fix symbol loading from libbfd
Date: Wed, 25 Nov 2026 15:34:00 +0100
Message-ID: <20261125143900.580205584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit f814d9e6cdbef6413a72d6dd6d5e4e79e815cf44 ]

The dso__load() should return a positive number (number of symbols
loaded) when it succeded to load symbols.  But dso__load_bfd_symbols()
only returns 0 and it's hard to check if it actually loaded symbols or
not.  Let's return the value of dso__has_symbol() and check it in
dso__load() so that it can return 1 for success.

Closes: https://lore.kernel.org/r/sashiko-outbox-162540@kernel.org
Fixes: eac9a4342e5447ca ("perf symbols: Try reading the symbol table with libbfd")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Remi Bernon <rbernon@codeweavers.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: Applied the dso__load_bfd_symbols() return-value change in symbol.c, because the libbfd code hasn't been split out into its own file here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/pe-file-parsing.c | 2 +-
 tools/perf/util/symbol.c           | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/pe-file-parsing.c b/tools/perf/tests/pe-file-parsing.c
index fff58b220c07b..69060aa1a62a1 100644
--- a/tools/perf/tests/pe-file-parsing.c
+++ b/tools/perf/tests/pe-file-parsing.c
@@ -59,7 +59,7 @@ static int run_dir(const char *d)
 	TEST_ASSERT_VAL("Failed to get dso", dso);
 
 	ret = dso__load_bfd_symbols(dso, debugfile);
-	TEST_ASSERT_VAL("Failed to load symbols", ret == 0);
+	TEST_ASSERT_VAL("Failed to load symbols", ret > 0);
 
 	dso__sort_by_name(dso);
 	sym = dso__find_symbol_by_name(dso, "main", &idx);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 99ee76bc6c513..ef4594088684a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1694,7 +1694,7 @@ int dso__load_bfd_symbols(struct dso *dso, const char *debugfile)
 	symbols__fixup_duplicate(dso__symbols(dso));
 	dso__set_adjust_symbols(dso, true);
 
-	err = 0;
+	err = dso__has_symbols(dso);
 out_free:
 	free(symbols);
 out_close:
@@ -1914,8 +1914,8 @@ int dso__load(struct dso *dso, struct map *map)
 		if (nsexit)
 			nsinfo__mountns_enter(dso__nsinfo(dso), &nsc);
 
-		if (bfdrc == 0) {
-			ret = 0;
+		if (bfdrc > 0) {
+			ret = 1;
 			break;
 		}
 
-- 
2.53.0



