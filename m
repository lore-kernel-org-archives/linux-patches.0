Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FB0471247;
	Tue, 21 Jul 2026 18:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657046; cv=none; b=pXXGkVoLEgpXGLmW1LeE8ylRm/GWNOlGawjPS4atdDU0TvtyZDNCDxnFLhJ/y+m8qaAPC8QPfNsORDGiEOYFvxVXaflg0Dw41i4EIbqW3zr63YFEakv+3MBbP8Ei94NL7v6YfBWtB6hYFZ6sQwXoUEuGtRFyT6pkOnFDgGHwHLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657046; c=relaxed/simple;
	bh=Ti3tjYu/KmoDA3/Fqz2PaJ1b1P3qyw7ymfOtmME0Bv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEX/zEjvj3GiZNo6iG8eCyYOjKb65/fYM4amWhm7ur8mirUTUvd6nSRnVxOARE7IEenHUya4lXCCxjcacqURZERre3uU91q0RO/dig4JbZjr8Q/iaRv6Tt98vqNV8nnElgT61KhUzRwRaKZuiFtcRM6pzUO6/PqB5DXLHcbQjDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8069EYN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8069EYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5481F000E9;
	Tue, 21 Jul 2026 18:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657044;
	bh=5xtMHxx34PEXevzT53PfQsB9wuoA9FIAYguQR3et/pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8069EYNu3GVzhQNBEbIEE9BKJlXVe5DMOFUYj7pnMa48MKcey3IGLgKnRindt5os
	 6UtXerLbN5aWYQ2Llv1jJidSvytHRLeOb6wzfuGm2urI0enWLIZsyJ9C7RJsK4W80V
	 p2JHoYx5mQ5vGZpqwKuoRrFdRaqd95tCZJky/hMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Hari Bathini <hbathini@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Shivani Nittor <shivani@linux.ibm.com>,
	Tanushree Shah <tanushree.shah@ibm.com>,
	Tejas Manhas <tejas.manhas1@ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0617/1611] powerpc tools perf: Initialize error code in auxtrace_record_init function
Date: Tue, 21 Jul 2026 17:12:13 +0200
Message-ID: <20260721152529.263859692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Athira Rajeev <atrajeev@linux.ibm.com>

[ Upstream commit 789d22d77879eabb042627f6627cdb62787bc142 ]

perf trace record fails some cases in powerpc

 # perf test "perf trace record and replay"
 128: perf trace record and replay                                    : FAILED!

  # perf trace record sleep 1
  # echo $?
    32

This is happening because of non-zero err value from
auxtrace_record__init() function.

 static int record__auxtrace_init(struct record *rec)
 {
        int err;

        if ((rec->opts.auxtrace_snapshot_opts || rec->opts.auxtrace_sample_opts)
            && record__threads_enabled(rec)) {
                pr_err("AUX area tracing options are not available in parallel streaming mode.\n");
                return -EINVAL;
        }

        if (!rec->itr) {
                rec->itr = auxtrace_record__init(rec->evlist, &err);
                if (err)
                        return err;
        }

Here "int err" is not initialised. The code expects "err" to be set from
auxtrace_record__init() function.

Update auxtrace_record__init() in arch/powerpc/util/auxtrace.c to clear
err value in the beginning.

- Clear err value in beginning of function. Any fail later will
set appropriate return code to err.

- Even if we haven't found any event for auxtrace, perf record
should continue for other events. NULL return
will indicate that there is no auxtrace record initialized.

- Not having "err" set here will affect monitoring of other events
also because perf record will fail seeing random value in err.

Set err to -EINVAL before invoking auxtrace_record__init() in
builtin-record.c

With the fix,

  # perf trace record sleep 1
  [ perf record: Woken up 2 times to write data ]
  [ perf record: Captured and wrote 0.033 MB perf.data (228 samples) ]

Fixes: 1dbfaf94cf66ec4b ("perf powerpc: Add basic CONFIG_AUXTRACE support for VPA pmu on powerpc")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Athira Rajeev <atrajeev@linux.ibm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Hari Bathini <hbathini@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Shivani Nittor <shivani@linux.ibm.com>
Cc: Tanushree Shah <tanushree.shah@ibm.com>
Cc: Tejas Manhas <tejas.manhas1@ibm.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/powerpc/util/auxtrace.c | 6 ++++++
 tools/perf/builtin-record.c             | 1 +
 2 files changed, 7 insertions(+)

diff --git a/tools/perf/arch/powerpc/util/auxtrace.c b/tools/perf/arch/powerpc/util/auxtrace.c
index 62c6f67f1bbe66..57f2910c0b0198 100644
--- a/tools/perf/arch/powerpc/util/auxtrace.c
+++ b/tools/perf/arch/powerpc/util/auxtrace.c
@@ -70,6 +70,12 @@ struct auxtrace_record *auxtrace_record__init(struct evlist *evlist,
 	struct evsel *pos;
 	int found = 0;
 
+	/*
+	 * Set err value to zero here. Any fail later
+	 * will set appropriate return code to err.
+	 */
+	*err = 0;
+
 	evlist__for_each_entry(evlist, pos) {
 		if (strstarts(pos->name, "vpa_dtl")) {
 			found = 1;
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b1fb87016d5aa9..2563ef66a4d946 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -867,6 +867,7 @@ static int record__auxtrace_init(struct record *rec)
 	}
 
 	if (!rec->itr) {
+		err = -EINVAL;
 		rec->itr = auxtrace_record__init(rec->evlist, &err);
 		if (err)
 			return err;
-- 
2.53.0



