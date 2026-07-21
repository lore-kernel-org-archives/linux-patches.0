Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C842035C682;
	Tue, 21 Jul 2026 22:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671803; cv=none; b=dKivwv9QIsQxh2J8ld65q88kPqbgqMJuu9c4tJZI9ompC/KlN6uMXSFKHL9zi2exF8L0AgvsCGnWuzKY/nd/RSzR+bqlPNgJUPfsLO3bgFQndznexnWjIPCRRd0M4h9YGMEVgLaGoHfwZFUQS3B8h78v47pBY5b0h18Oqk4XQz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671803; c=relaxed/simple;
	bh=EaUkeKIyLxxnz0niJ0v/rLivsy/LrSzUesICMrNm1Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eLEFSsEGKM87j1TjFDfYtOFfoGl/rs7+vgvF8uTKG1t0V9jBsJ6GehpplNzCUXbXnRJvqhzuEQIqz2LWwPlHLGsX7Dk5dmwMr0DOSGoSzCrn4H3cmmDZyYHEjkFSm+bX9t16cSkNPSposhAASO9Jawq+hzLLMWmvqgtwgvNiCFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g08TwZaL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g08TwZaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6661F000E9;
	Tue, 21 Jul 2026 22:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671801;
	bh=4SC/aHRcXqaAnMWj0z+r8PwWpUevPxsAelruFDpeJMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g08TwZaLHPdC1zENK1KpcnwlN74h9VBSa7yz6I1QFkmTvFLh51iJ5NarRmDgpfjp3
	 dYU02E/mSvnfQ6Ir37DfUgdJecYGoVgZkWNWBDUFBu2wHn/nKt8zAHD+gzyanZ+7Gb
	 7ykAM0K7SzVI+sy5zoZ3HC+wybzi/KhLpJ7bigQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Wang Nan <wangnan0@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	sashiko-bot@kernel.org
Subject: [PATCH 5.15 384/843] perf header: Sanity check HEADER_EVENT_DESC attr.size before swap
Date: Tue, 21 Jul 2026 17:20:19 +0200
Message-ID: <20260721152414.676428709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 944f65c8b8231d26d4db6be67bcb641142603cb4 ]

read_event_desc() reads nre (event count), sz (attr size), and nr
(IDs per event) from the file and uses them to control allocations
and loops without validating them against the section size.

A crafted perf.data could trigger large allocations or many loop
iterations before __do_read() eventually rejects the reads.

Add bounds checks in read_event_desc():
- Reject sz smaller than PERF_ATTR_SIZE_VER0.
- Require at least one event (nre > 0).
- Check that nre events fit in the remaining section, using the
  minimum per-event footprint of sz + sizeof(u32).
- Pre-swap attr->size to native byte order, then reject values
  below PERF_ATTR_SIZE_VER0 or above sz before calling
  perf_event__attr_swap() to prevent heap out-of-bounds access.
- Handle ABI0 (attr.size == 0): substitute PERF_ATTR_SIZE_VER0,
  and on native-endian files write the value back so
  free_event_desc() does not treat the zero as its end-of-array
  sentinel (it iterates while attr.size != 0).  The swap path
  skips the write-back — perf_event__attr_swap() has its own
  ABI0 fallback that sets VER0 after swapping.
- Check that nr IDs fit in the remaining section before allocating.

Fixes: b30b61729246 ("perf tools: Fix a problem when opening old perf.data with different byte order")
Reported-by: sashiko-bot@kernel.org # Running on a local machine
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Assisted-by: Claude:claude-opus-4.6-1m
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 54 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3e18acb7193249..d5b381eead06e6 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1826,9 +1826,28 @@ static struct evsel *read_event_desc(struct feat_fd *ff)
 	if (do_read_u32(ff, &nre))
 		goto error;
 
+	/* Size of each of the nre attributes. */
 	if (do_read_u32(ff, &sz))
 		goto error;
 
+	/*
+	 * Require at least one event with an attr no smaller than the
+	 * first published struct, and reject sz values where
+	 * sz + sizeof(u32) would overflow size_t (possible on 32-bit)
+	 * or nre == UINT32_MAX where nre + 1 wraps to 0 in the calloc.
+	 *
+	 * The minimum section footprint per event is sz bytes for the
+	 * attr plus a u32 for the id count, check that nre events fit.
+	 */
+	if (!nre || sz < PERF_ATTR_SIZE_VER0 ||
+	    sz > ff->size || (size_t)sz > SIZE_MAX - sizeof(u32) ||
+	    nre == UINT32_MAX ||
+	    nre > (ff->size - ff->offset) / (sz + sizeof(u32))) {
+		pr_err("Invalid HEADER_EVENT_DESC: nre=%u sz=%u (min %d)\n",
+		       nre, sz, PERF_ATTR_SIZE_VER0);
+		goto error;
+	}
+
 	/* buffer to hold on file attr struct */
 	buf = malloc(sz);
 	if (!buf)
@@ -1844,6 +1863,9 @@ static struct evsel *read_event_desc(struct feat_fd *ff)
 		msz = sz;
 
 	for (i = 0, evsel = events; i < nre; evsel++, i++) {
+		struct perf_event_attr *attr = buf;
+		u32 attr_size;
+
 		evsel->core.idx = i;
 
 		/*
@@ -1853,6 +1875,32 @@ static struct evsel *read_event_desc(struct feat_fd *ff)
 		if (__do_read(ff, buf, sz))
 			goto error;
 
+		/* Reject before attr_swap to prevent OOB via bswap_safe() */
+		attr_size = ff->ph->needs_swap ? bswap_32(attr->size) : attr->size;
+		/* ABI0: size == 0 means the producer didn't set it */
+		if (!attr_size) {
+			attr_size = PERF_ATTR_SIZE_VER0;
+			/*
+			 * Write back so free_event_desc() doesn't
+			 * treat this event as the end-of-array sentinel
+			 * (it iterates while attr.size != 0).
+			 *
+			 * Only for native — the swap path must NOT
+			 * write native-endian VER0 here because
+			 * perf_event__attr_swap() would re-swap it
+			 * to 0x40000000, defeating bswap_safe() bounds.
+			 * perf_event__attr_swap() has its own ABI0
+			 * fallback that sets VER0 after swapping.
+			 */
+			if (!ff->ph->needs_swap)
+				attr->size = attr_size;
+		}
+		if (attr_size < PERF_ATTR_SIZE_VER0 || attr_size > sz) {
+			pr_err("Event %d attr.size (%u) invalid (min: %d, max: %u)\n",
+			       i, attr_size, PERF_ATTR_SIZE_VER0, sz);
+			goto error;
+		}
+
 		if (ff->ph->needs_swap)
 			perf_event__attr_swap(buf);
 
@@ -1874,6 +1922,12 @@ static struct evsel *read_event_desc(struct feat_fd *ff)
 		if (!nr)
 			continue;
 
+		/* Prevent oversized allocation from crafted nr */
+		if (nr > (ff->size - ff->offset) / sizeof(*id)) {
+			pr_err("Event %d: id count %u exceeds remaining section\n", i, nr);
+			goto error;
+		}
+
 		id = calloc(nr, sizeof(*id));
 		if (!id)
 			goto error;
-- 
2.53.0



