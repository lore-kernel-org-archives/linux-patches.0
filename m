Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218634A2E2C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300876; cv=none; b=r7LUnccy6P6/R54npk63uLfPcvcA/784APIXXVvvKoeU4ib1WWoaUYCSSzzTSwEM2KykltoaOvkyLD1flLtuZRayKw9x1Wi3zXU/BY5u1xRj0U1M2Al8ZuKQ+MfmVDcXQCz8EmMvADISq0n42j/6ms4zyaOnsLyKH1NTxSHztRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300876; c=relaxed/simple;
	bh=WcA3WL1krzhv1P6/LJqXPpT/7yvCsd50V/PIVxvvauU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snUETAWgQINXL+t+NOUOnidaWGVRLeHgZM1HuIwt6Hq+f6P7bjNWXJuU2a/Sz6OCLiCZby09i6y3yMFyLweb42psU3zUPq93JWByezAC/GmYgBqIl2DysDXqBjYwBKZbrT2Tm36Rt/QbYb+CYS+2h2WiFqsUhDVOqPrrn+AgfHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bh4dR6m7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bh4dR6m7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8A8C116D0;
	Sat, 28 Feb 2026 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300876;
	bh=WcA3WL1krzhv1P6/LJqXPpT/7yvCsd50V/PIVxvvauU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bh4dR6m7iW4YgRH2DF/dzyYBNzEMu//YlFUXqfaE88ObWNmJYiSi/9JhCooyv/sPL
	 dF7r6rb3trHXZV/99zB6PmfLMc19xJDWsIYpOQKgcoco6Z0o11sIMWKkl0+RqeMvwO
	 9plp8es8KSeGEZ2+kTJedQ0pySdYoBLMiBX+ZKPwAD9RlXAB6QSXrh+0U5QAlEA1Sk
	 Fv9iQeoGTf2vresFUHUbPpdOZaywbXg9Yq0ssREfEXXS++hDBgdsCZZQPAu5dHYk0d
	 zY1iHb07O995Qq71BMGXrhPDSMFVXWwJbggiUTz5j7Jw0lYmFq2n4yXEnivY0y6YST
	 5XaDNcrNEbkQQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nicolas Schier <n.schier@avm.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Brnak <jbrnak@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Philipp Hahn <p.hahn@avm.de>,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/752] perf build: Raise minimum shellcheck version to 0.7.2
Date: Sat, 28 Feb 2026 12:35:14 -0500
Message-ID: <20260228174750.1542406-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nicolas Schier <n.schier@avm.de>

[ Upstream commit 383f8e26e2c483e25453f8c3d0839877708ac701 ]

Raise the minimum shellcheck version for perf builds to 0.7.2, so that
systems with shellcheck versions below 0.7.2 will automatically skip the
shell script checking, even if NO_SHELLCHECK is unset.

Since commit 241f21be7d0fdf3c ("perf test perftool_testsuite: Use
absolute paths"), shellcheck versions before 0.7.2 break the perf build
with several SC1090 [2] warnings due to its too strict dynamic source
handling [1], e.g.:

  In tests/shell/base_probe/test_line_semantics.sh line 20:
  . "$DIR_PATH/../common/init.sh"
    ^---------------------------^ SC1090: Can't follow non-constant source. Use a directive to specify location.

Fixes: 241f21be7d0fdf3c ("perf test perftool_testsuite: Use absolute paths")
Signed-off-by: Nicolas Schier <n.schier@avm.de>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Brnak <jbrnak@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Nicolas Schier <nsc@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Philipp Hahn <p.hahn@avm.de>
Cc: Veronika Molnarova <vmolnaro@redhat.com>
Link: https://github.com/koalaman/shellcheck/issues/1998 # [1]
Link: https://www.shellcheck.net/wiki/SC1090
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 47c906b807ef2..da7434b385d18 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -253,11 +253,12 @@ else
 endif
 
 # shellcheck is using in tools/perf/tests/Build with option -a/--check-sourced (
-# introduced in v0.4.7) and -S/--severity (introduced in v0.6.0). So make the
-# minimal shellcheck version as v0.6.0.
+# introduced in v0.4.7) and -S/--severity (introduced in v0.6.0) as well as
+# dynamic source inclusions (properly handled since v0.7.2).
+# So make the minimal shellcheck version as v0.7.2.
 ifneq ($(SHELLCHECK),)
   ifeq ($(shell expr $(shell $(SHELLCHECK) --version | grep version: | \
-        sed -e 's/.\+ \([0-9]\+\).\([0-9]\+\).\([0-9]\+\)/\1\2\3/g') \< 060), 1)
+        sed -e 's/.\+ \([0-9]\+\).\([0-9]\+\).\([0-9]\+\)/\1\2\3/g') \< 072), 1)
     SHELLCHECK :=
   else
     SHELLCHECK := $(SHELLCHECK) -s bash -a -S warning
-- 
2.51.0

