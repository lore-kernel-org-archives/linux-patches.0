Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66E44D9EA;
	Wed, 19 Jun 2024 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803385; cv=none; b=WVPZ0BTp2uzoRyyN2zsNTQEhdKh0s5gcFoXLfsoWgUNP1bxk/goQqErfAG9sC42yUY3BlG2+ur9tI8Lm7k1OkiQN9l/D4mZ6BQz/rMvZp3/0Vca+ibS1LqMTFRWxphZgw8DyGbClLBjqRIzlVN+1ib7bwy528b8FYl3GL3eJQ94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803385; c=relaxed/simple;
	bh=QnG95PXbEj9oOm1jbis+IlzAfk9XDBtyvYI8zXs8Xlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK8pydt/pHlB6z3RJj00dv4xWlrpPUoQxLbco7psQ/aWHncAJsqB19RsC6Pvm4D6DftnxOzZlyPOq5aKNHOicQA9+7WlZ+UpWnIjgMY6hmDfo+mTgFGCocGuCFv/BDgQ49W30KGeIVlIMtLMJDyS+xSgWXxKLjhGah8NY6Qa/so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+BFUwIT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+BFUwIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52372C2BBFC;
	Wed, 19 Jun 2024 13:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803385;
	bh=QnG95PXbEj9oOm1jbis+IlzAfk9XDBtyvYI8zXs8Xlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+BFUwITW40o/GwCkdrDTTTcKA5ilAFT6jVyraJ9R5sRA6GlBpbpaoAjD4017Fylo
	 VRIVsTD7Q1CZ7edZzZ0QePQ9GWLQsXlZzk76AVSXGzaOWt5g+3ShD1sKhsbkndDrpE
	 LeiBYpgFQWBQJ6bPEaLOfhyCHbKBScoVlL3ff15Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.9 218/281] perf auxtrace: Fix multiple use of --itrace option
Date: Wed, 19 Jun 2024 14:56:17 +0200
Message-ID: <20240619125618.350097061@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit bb69c912c4e8005cf1ee6c63782d2fc28838dee2 upstream.

If the --itrace option is used more than once, the options are
combined, but "i" and "y" (sub-)options can be corrupted because
itrace_do_parse_synth_opts() incorrectly overwrites the period type and
period with default values.

For example, with:

	--itrace=i0ns --itrace=e

The processing of "--itrace=e", resets the "i" period from 0 nanoseconds
to the default 100 microseconds.

Fix by performing the default setting of period type and period only if
"i" or "y" are present in the currently processed --itrace value.

Fixes: f6986c95af84ff2a ("perf session: Add instruction tracing options")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240315071334.3478-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/auxtrace.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1466,6 +1466,7 @@ int itrace_do_parse_synth_opts(struct it
 	char *endptr;
 	bool period_type_set = false;
 	bool period_set = false;
+	bool iy = false;
 
 	synth_opts->set = true;
 
@@ -1484,6 +1485,7 @@ int itrace_do_parse_synth_opts(struct it
 		switch (*p++) {
 		case 'i':
 		case 'y':
+			iy = true;
 			if (p[-1] == 'y')
 				synth_opts->cycles = true;
 			else
@@ -1649,7 +1651,7 @@ int itrace_do_parse_synth_opts(struct it
 		}
 	}
 out:
-	if (synth_opts->instructions || synth_opts->cycles) {
+	if (iy) {
 		if (!period_type_set)
 			synth_opts->period_type =
 					PERF_ITRACE_DEFAULT_PERIOD_TYPE;


