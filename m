Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054776;
	b=BMrnsRzxe/wEptIR0e0HQ7uOphsjevq4bE7jPluPtUdf76q+46HrbCcQwL3fv5pZNxgd
	 E/tfgOCbzHp6j3llJ3rzuhUrq8gXdSh6KimLfDLD8XELqtoC+9X+lONFyMuUf5cWeD1XE
	 ZNoZUoGgo41rFzQQBMiJaGkRQoW0d+y8t3yE6OHHi8dPWmDxr9XRGHwb1EYEHalPG5oLd
	 r+iIPur3MYwyhz5HAibY02r+T5M3r6Mol37DUP2ucqf1vvTA8mpsppUuAtdDSvWtXcUsI
	 jXCKxnUjFTvfOoj06xilD7FvXLUR1TAsrYzaNZXWCjl787pz2UxYaS1VFDlvC0Xv6Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SB9VoCoehBj0/IpPgZ3vgCjvFeKBse5fxVuetFyXZLA=;
	b=vz5ok1Vj94KyV8JYWipazPhuq+K0shCco6VU/KPoCEeXSzhiaEnTBAIBOdJlZB8axZrV
	 ZkWASPaj89Dx5zb+EwGjHk6GJj6maZo8mLXZ28DBRX6ZjaiFDw7DUxp6JDbw/QYhUZ9Op
	 akcXX/btwzV149TA8F2qZHBJPET6mhkb54Ohq/0KwddcU1sBijMmHie9ndXfW4edt1CPJ
	 AZPZAwJ/9cxuhnMoufL92loFnR/23GhPJbXGdR/R1z1U19P/hFlUqAUzVfJRFQX1NF8ky
	 UXivnppU+dkhKrwdRZAdr0bim2kvtRFJqls0Od1heTsJGgjhOj59zGNAtyGOcM9IhwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brL7WmV7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D38606A325;
	Thu, 19 Nov 2026 02:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brL7WmV7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4E81F000C4;
	Thu, 19 Nov 2026 02:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054776;
	bh=SB9VoCoehBj0/IpPgZ3vgCjvFeKBse5fxVuetFyXZLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brL7WmV7MJ8gO7UiRNaLjKPsbGrwavy6vrZ1d+QgPf1cfNDrftf+qjiVqjQauUYhe
	 WshZ4BllaX6a1SMbKRzj+FdnUYmPvbJLF6twUNnR6U336iIBG43dpjkTFnKbndEoOd
	 LEiE0iIc2QNKfk1dNDvaVHcFAqkDpy3RICgDwwMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Mark Amirkan <markdamirkan@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1395/2214] perf evsel: Validate RAW sample before byte swapping
Date: Wed, 18 Nov 2026 15:51:11 +0100
Message-ID: <20261118150107.106907069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Amirkan <markdamirkan@gmail.com>

[ Upstream commit 02f6847e1822714a4201b87e42f92b0d43e8549d ]

For an opposite-endian RAW sample, __evsel__parse_sample() passes the
input-controlled size to mem_bswap_64() before checking whether the
payload fits in the event. A truncated record can therefore make the helper
read and write past the event boundary.

A crafted perf.data file makes perf report crash with SIGSEGV. ASan
reports the out-of-bounds access. A regression test puts backed data past
the declared end and shows that it is changed before the parser returns
-EFAULT.

Move the bounds checks before mem_bswap_64(). Check the rounded length too,
because the helper accesses complete 64-bit words. Complete records are
handled as before.

Fixes: f9d8adb345d7adbb ("perf evsel: Fix swap for samples with raw data")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Symbolic
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/sample-parsing.c | 61 +++++++++++++++++++++++++++++++
 tools/perf/util/evsel.c           | 17 +++++----
 2 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/tools/perf/tests/sample-parsing.c b/tools/perf/tests/sample-parsing.c
index b2c408b8b7820..7abc505079d60 100644
--- a/tools/perf/tests/sample-parsing.c
+++ b/tools/perf/tests/sample-parsing.c
@@ -371,6 +371,55 @@ static int test_truncated_branch_stack(void)
 	return 0;
 }
 
+static int test_truncated_swapped_raw(u16 event_size, u32 raw_size)
+{
+	struct perf_event_attr attr = {
+		.sample_type = PERF_SAMPLE_RAW,
+	};
+	struct {
+		struct perf_event_header header;
+		union {
+			u64 value;
+			u32 words[2];
+		} raw;
+		u64 canary;
+	} input = {
+		.header = {
+			.type = PERF_RECORD_SAMPLE,
+			.size = event_size,
+		},
+		/* Parsing a pre-swapped word exchanges these two u32 values. */
+		.raw.words = { 0x12345678, raw_size },
+		.canary = 0x8877665544332211ULL,
+	};
+	struct perf_sample sample;
+	struct evsel *evsel;
+	u64 raw = input.raw.value;
+	u64 canary = input.canary;
+	int err;
+
+	evsel = evsel__new(&attr);
+	if (!evsel)
+		return -1;
+
+	evsel->sample_size = __evsel__sample_size(attr.sample_type);
+	err = __evsel__parse_sample(evsel, (union perf_event *)&input,
+				    &sample, /*needs_swap=*/true);
+	perf_sample__exit(&sample);
+	evsel__put(evsel);
+
+	if (err != -EFAULT) {
+		pr_debug("truncated swapped RAW sample (size %u, raw %u) returned %d, expected -EFAULT\n",
+			 event_size, raw_size, err);
+		return -1;
+	}
+	if (input.raw.value != raw || input.canary != canary) {
+		pr_debug("truncated swapped RAW sample modified data before validation\n");
+		return -1;
+	}
+	return 0;
+}
+
 /**
  * test__sample_parsing - test sample parsing.
  *
@@ -391,6 +440,18 @@ int test__sample_parsing(struct test *test __maybe_unused, int subtest __maybe_u
 	if (err)
 		return err;
 
+	/* The declared RAW payload extends past an otherwise aligned event. */
+	err = test_truncated_swapped_raw(sizeof(struct perf_event_header) +
+					 sizeof(u64), 16);
+	if (err)
+		return err;
+
+	/* The final complete word touched by mem_bswap_64() extends past it. */
+	err = test_truncated_swapped_raw(sizeof(struct perf_event_header) +
+					 sizeof(u32) + 9, 9);
+	if (err)
+		return err;
+
 	/*
 	 * Fail the test if it has not been updated when new sample format bits
 	 * were added.  Please actually update the test rather than just change
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 365effb524b32..2e9ddd59f8d27 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2442,7 +2442,10 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
+		const __u64 *raw;
+
 		OVERFLOW_CHECK_u64(array);
+		raw = array;
 		u.val64 = *array;
 
 		/*
@@ -2458,16 +2461,14 @@ int evsel__parse_sample(struct evsel *evsel, union perf_event *event,
 		}
 		data->raw_size = u.val32[0];
 
-		/*
-		 * The raw data is aligned on 64bits including the
-		 * u32 size, so it's safe to use mem_bswap_64.
-		 */
-		if (swapped)
-			mem_bswap_64((void *) array, data->raw_size);
-
 		array = (void *)array + sizeof(u32);
-
 		OVERFLOW_CHECK(array, data->raw_size, max_size);
+		if (swapped) {
+			/* mem_bswap_64() accesses complete 64-bit words. */
+			sz = roundup((u64)data->raw_size, sizeof(u64));
+			OVERFLOW_CHECK(raw, sz, max_size);
+			mem_bswap_64((void *)raw, data->raw_size);
+		}
 		data->raw_data = (void *)array;
 		array = (void *)array + data->raw_size;
 	}
-- 
2.53.0



