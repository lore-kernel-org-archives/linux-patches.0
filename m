Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABE1471411;
	Tue, 21 Jul 2026 20:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664626; cv=none; b=SjcrA3gbJXqN+HY4Vbuur5OdE9EdwW1gIvyUABZMbg6wmcaF1sktS2BaBhd6zoYyLbxNwurgC8P0yneugNzkOFFm/ysiR2hGmPJK+92UlPgCNLm/FyyJi5wVeAErqMBaFC7VhUouWHywzO1IJ3w2XNkiHKunO9xl+kBKT8VbAOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664626; c=relaxed/simple;
	bh=wUgX32YmJjuz3wO4QyvalvqlrCIuPbJnzJaAZzWmTD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4aRO/awnuTkAs6+FzHL5rsImE/o5eYQpntPg4kitbENnthOw4o+cTNNAPaFRmjmgfMhbZKrJi28t/QS5pGnaCqIqHl302Apf1IjY10PvF5n1/WvnJFaduS7QvyxZhky0sawatMUZ0NzKi4YS4dcfWcbVc3qak6AFVeau1smdEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWI6ZZ87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWI6ZZ87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8721F1F000E9;
	Tue, 21 Jul 2026 20:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664625;
	bh=w6CK7n4np1VMH7HIh3M+lqqQDXnGlGX0cVHee+MNIzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWI6ZZ873d+M2W9mw+7vCEj/cYzbgRRF+dJAU9hbiEwaD14uyZA8JxAT53SPMMrc/
	 vylhEduFPE8ovmkiAJLy74ACaKpJxhH3X2PM173pns57NVdVXnaNaJYQAMiQHbUudI
	 Jwp/5uMTfPWCWhZJXvCm/QXuWgLbdJQm8mrWggio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.12 1271/1276] perf synthetic-events: Fix stale build ID in module MMAP2 records
Date: Tue, 21 Jul 2026 17:28:34 +0200
Message-ID: <20260721152514.532455973@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit 35b16a7a2c4fc458304447128b86514ce9f70f3c upstream.

perf_event__synthesize_modules() allocates a single union perf_event and
reuses it across every kernel module callback.

After the first module is processed, perf_record_mmap2__read_build_id()
sets PERF_RECORD_MISC_MMAP_BUILD_ID in header.misc and writes that
module's build ID into the event.

On subsequent iterations the callback overwrites start, len, pid, and
filename for the next module but never clears the stale build ID fields
or the MMAP_BUILD_ID flag.

When perf_record_mmap2__read_build_id() runs for the second module it
sees the flag, reads the stale build ID into a dso_id, and
__dso__improve_id() permanently poisons the DSO with the wrong build ID.

Every module after the first therefore receives the first module's build
ID in its MMAP2 record.

On a system with the sunrpc and nfsd modules loaded, this causes perf
script and perf report to show [unknown] for all module symbols.

The latent bug has existed since commit d9f2ecbc5e47fca7 ("perf dso:
Move build_id to dso_id") introduced the PERF_RECORD_MISC_MMAP_BUILD_ID
check in perf_record_mmap2__read_build_id().

Commit 53b00ff358dc75b1 ("perf record: Make --buildid-mmap the default")
then exposed it to all users by making the MMAP2-with-build-ID path the
default.  Both commits were merged in the same series.

Clear the MMAP_BUILD_ID flag and zero the build_id union before each
call to perf_record_mmap2__read_build_id() so that every module starts
with a clean slate.

Fixes: d9f2ecbc5e47fca7 ("perf dso: Move build_id to dso_id")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/synthetic-events.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -702,6 +702,11 @@ static int perf_event__synthesize_module
 
 		memcpy(event->mmap2.filename, dso__long_name(dso), dso__long_name_len(dso) + 1);
 
+		/* Clear stale build ID from previous module iteration */
+		event->mmap2.header.misc &= ~PERF_RECORD_MISC_MMAP_BUILD_ID;
+		memset(event->mmap2.build_id, 0, sizeof(event->mmap2.build_id));
+		event->mmap2.build_id_size = 0;
+
 		perf_record_mmap2__read_build_id(&event->mmap2, args->machine, false);
 	} else {
 		size = PERF_ALIGN(dso__long_name_len(dso) + 1, sizeof(u64));


