Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2513DD51A;
	Sat, 12 Sep 2026 12:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214613; cv=none; b=R87E5/GQqYlB2F1Jtl2HmHVOgMoolRlrizZ51a6HlzzKGAmH6H7Zgu83tQGwVBrmZ6tkK49S9JiUYYqqgTGfSNl7ARWvqQ6B0hgVB1H+rcVpqkDg7M+s84Bb0XcDFRlFzqgUXMaYEY9yIvYRSl93Z7McPwpGZ/BTafZki3QkfzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214613; c=relaxed/simple;
	bh=f3ZedF4vXJKmSEcLpdjHuh7DUE53KEL2gAv8/06SzRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUVvjvuI0c6rdedojAu8pTo2SU/SYjmo6CneD2WIc6Z6M7XxoSJ5CDBqOFS7kzmmi1wn0ce48FWaIBxTmtrEKEEVPLpdiCw84AR/INBTZ88BeOYyFx+e8Pr5ImWKz9VnkGw2qZETSY0PVQJVEdeikm9CuhaTJvs5uT6tBWx0lyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPdte13C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPdte13C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9981F000FF;
	Sat, 12 Sep 2026 12:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214612;
	bh=rrKU/QA7de5z3HJ5w2EeHceusJWABPTI37pJXsIQsEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPdte13C715ep1ZJlQiX1dszvElhM2lYB8TSoYxDk29iPUYvYZ76uwOmn1g33EJHy
	 pr5ULbBwCqXgZJYf4Rh4RhQU4LWda8v2epIa6NgmEniqEtKKwZCBnE3b/4XADVrI4j
	 S8BMubIBvEO8tq/1y4nh0GN9glsHfZRug1U5ZYN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0361/1376] perf test brstack: Speed up running test by using tr -s instead of xargs
Date: Sat, 12 Sep 2026 08:46:27 +0200
Message-ID: <20260912065615.596728931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: James Clark <james.clark@arm.com>

[ Upstream commit 3178155d292b2b5f0b9f59b3777dc52e029652ba ]

The brstack test runs quite slowly in software models. Part of the reason
is "xargs -n1" is quite inefficient in replacing spaces with newlines.

While that's not noticeable on normal machines, it is on software models.

Use "tr -s ' ' '\n'" instead which can do the same transformation, but is
much faster. For comparison on an M1 Macbook Pro:

  $ time seq -s ' ' 10000 | xargs -n1 > /dev/null

  real    0m2.729s
  user    0m2.009s
  sys     0m0.914s
  $ time seq -s ' ' 10000 | tr -s ' ' '\n' | grep '.' > /dev/null

  real    0m0.002s
  user    0m0.001s
  sys     0m0.001s

The "grep '.'" is also needed to remove any remaining blank lines.

Signed-off-by: James Clark <james.clark@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241213231312.2640687-2-robh@kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
[robh: Drop changing loop iterations on arm64. Squash blank line fix and redo commit msg]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 344d3aec164d ("perf tests: Fix flakiness in branch stack sampling tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_brstack.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/shell/test_brstack.sh b/tools/perf/tests/shell/test_brstack.sh
index 5f14d0cb013f8..e01df7581393e 100755
--- a/tools/perf/tests/shell/test_brstack.sh
+++ b/tools/perf/tests/shell/test_brstack.sh
@@ -30,7 +30,7 @@ test_user_branches() {
 	echo "Testing user branch stack sampling"
 
 	perf record -o $TMPDIR/perf.data --branch-filter any,save_type,u -- ${TESTPROG} > /dev/null 2>&1
-	perf script -i $TMPDIR/perf.data --fields brstacksym | xargs -n1 > $TMPDIR/perf.script
+	perf script -i $TMPDIR/perf.data --fields brstacksym | tr -s ' ' '\n' > $TMPDIR/perf.script
 
 	# example of branch entries:
 	# 	brstack_foo+0x14/brstack_bar+0x40/P/-/-/0/CALL
@@ -59,7 +59,7 @@ test_filter() {
 	echo "Testing branch stack filtering permutation ($test_filter_filter,$test_filter_expect)"
 
 	perf record -o $TMPDIR/perf.data --branch-filter $test_filter_filter,save_type,u -- ${TESTPROG} > /dev/null 2>&1
-	perf script -i $TMPDIR/perf.data --fields brstack | xargs -n1 > $TMPDIR/perf.script
+	perf script -i $TMPDIR/perf.data --fields brstack | tr -s ' ' '\n' | grep '.' > $TMPDIR/perf.script
 
 	# fail if we find any branch type that doesn't match any of the expected ones
 	# also consider UNKNOWN branch types (-)
-- 
2.53.0



