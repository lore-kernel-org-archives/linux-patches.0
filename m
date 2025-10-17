Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F803370F7;
	Fri, 17 Oct 2025 15:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714208; cv=none; b=QR5PjoI+MNzeghxjaBsH7FTUvCBsYmkp/KoNUepilR21lOb7XyjPaNdfvIUPklKEJZkhe09UKQXRszi6GIX+SW+TWNvc+gJYW6Zf7pEDSZljOrQonSdCRqf7NRI7tePzFZsjLv2ySxqfL87gXY/zOImybPSA+8VOKsE0L4zoWgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714208; c=relaxed/simple;
	bh=R6NCgdkiEt5TcDbGKA96MtJ2gi0ornyGddmGwE5DMvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiLT1s2coumqCyQTST+0q7jnLrDCUnWTxzm4xG2z8vd4IZjg12xFbe3YKLQim51zQQ8N3GhOEDB85AISBJsVZwY6Eqi39w978O/F1H8ApBUG5JWYfb4tqM7/6CMHsaTc1tT/x6WFUTT3culSH8yYIUaWxfT2aiNDX292qMwYKdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abArV4Ky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abArV4Ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A1EC4CEF9;
	Fri, 17 Oct 2025 15:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714207;
	bh=R6NCgdkiEt5TcDbGKA96MtJ2gi0ornyGddmGwE5DMvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abArV4KyCyJnXmzu4r4VRzcLdsqxfu+RjgZz6tX+P0rU8OxkFHa4qQKvxwuxqM5R7
	 t1//fujYhMiPwpdup3GgTKYfneEdhv5WrusJkR01rXyZaQ49CS74h6zMfa3R/6nkNy
	 PPLFiUvmuokPaU0ka0MyxpPtzvcUkPeA2Y//B0Wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	James Clark <james.clark@arm.com>,
	Atish Patra <atishp@atishpatra.org>,
	Mingwei Zhang <mizhang@google.com>,
	Kajol Jain <kjain@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/277] perf tools: Add fallback for exclude_guest
Date: Fri, 17 Oct 2025 16:50:39 +0200
Message-ID: <20251017145148.321034957@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit bb6e7cb11d97ce1957894d30d13bfad3e8bfefe9 ]

Commit 7b100989b4f6bce70 ("perf evlist: Remove __evlist__add_default")
changed to parse "cycles:P" event instead of creating a new cycles
event for perf record.  But it also changed the way how modifiers are
handled so it doesn't set the exclude_guest bit by default.

It seems Apple M1 PMU requires exclude_guest set and returns EOPNOTSUPP
if not.  Let's add a fallback so that it can work with default events.

Also update perf stat hybrid tests to handle possible u or H modifiers.

Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Acked-by: Kan Liang <kan.liang@linux.intel.com>
Cc: James Clark <james.clark@arm.com>
Cc: Atish Patra <atishp@atishpatra.org>
Cc: Mingwei Zhang <mizhang@google.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/r/20241016062359.264929-2-namhyung@kernel.org
Fixes: 7b100989b4f6bce70 ("perf evlist: Remove __evlist__add_default")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 24937ee839e4 ("perf evsel: Ensure the fallback message is always written to")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c      | 18 +++++++++++++++---
 tools/perf/tests/shell/stat.sh |  2 +-
 tools/perf/util/evsel.c        | 21 +++++++++++++++++++++
 3 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 628c61397d2d3..b578930ed76a4 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -639,8 +639,7 @@ static enum counter_recovery stat_handle_error(struct evsel *counter)
 	 * (behavior changed with commit b0a873e).
 	 */
 	if (errno == EINVAL || errno == ENOSYS ||
-	    errno == ENOENT || errno == EOPNOTSUPP ||
-	    errno == ENXIO) {
+	    errno == ENOENT || errno == ENXIO) {
 		if (verbose > 0)
 			ui__warning("%s event is not supported by the kernel.\n",
 				    evsel__name(counter));
@@ -658,7 +657,7 @@ static enum counter_recovery stat_handle_error(struct evsel *counter)
 		if (verbose > 0)
 			ui__warning("%s\n", msg);
 		return COUNTER_RETRY;
-	} else if (target__has_per_thread(&target) &&
+	} else if (target__has_per_thread(&target) && errno != EOPNOTSUPP &&
 		   evsel_list->core.threads &&
 		   evsel_list->core.threads->err_thread != -1) {
 		/*
@@ -679,6 +678,19 @@ static enum counter_recovery stat_handle_error(struct evsel *counter)
 		return COUNTER_SKIP;
 	}
 
+	if (errno == EOPNOTSUPP) {
+		if (verbose > 0) {
+			ui__warning("%s event is not supported by the kernel.\n",
+				    evsel__name(counter));
+		}
+		counter->supported = false;
+		counter->errored = true;
+
+		if ((evsel__leader(counter) != counter) ||
+		    !(counter->core.leader->nr_members > 1))
+			return COUNTER_SKIP;
+	}
+
 	evsel__open_strerror(counter, &target, errno, msg, sizeof(msg));
 	ui__error("%s\n", msg);
 
diff --git a/tools/perf/tests/shell/stat.sh b/tools/perf/tests/shell/stat.sh
index c6df7eec96b98..c4bef71568970 100755
--- a/tools/perf/tests/shell/stat.sh
+++ b/tools/perf/tests/shell/stat.sh
@@ -159,7 +159,7 @@ test_hybrid() {
   fi
 
   # Run default Perf stat
-  cycles_events=$(perf stat -- true 2>&1 | grep -E "/cycles/|  cycles  " | wc -l)
+  cycles_events=$(perf stat -- true 2>&1 | grep -E "/cycles/[uH]*|  cycles[:uH]*  " -c)
 
   if [ "$pmus" -ne "$cycles_events" ]
   then
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b3de8ce559998..70c4e06da7a03 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -3255,6 +3255,27 @@ bool evsel__fallback(struct evsel *evsel, struct target *target, int err,
 		evsel->core.attr.exclude_kernel = 1;
 		evsel->core.attr.exclude_hv     = 1;
 
+		return true;
+	} else if (err == EOPNOTSUPP && !evsel->core.attr.exclude_guest &&
+		   !evsel->exclude_GH) {
+		const char *name = evsel__name(evsel);
+		char *new_name;
+		const char *sep = ":";
+
+		/* Is there already the separator in the name. */
+		if (strchr(name, '/') ||
+		    (strchr(name, ':') && !evsel->is_libpfm_event))
+			sep = "";
+
+		if (asprintf(&new_name, "%s%sH", name, sep) < 0)
+			return false;
+
+		free(evsel->name);
+		evsel->name = new_name;
+		/* Apple M1 requires exclude_guest */
+		scnprintf(msg, msgsize, "trying to fall back to excluding guest samples");
+		evsel->core.attr.exclude_guest = 1;
+
 		return true;
 	}
 
-- 
2.51.0



