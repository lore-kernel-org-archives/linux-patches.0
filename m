Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0E04749D4;
	Sat, 12 Sep 2026 11:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210841; cv=none; b=i7m47mCX/dvZlw+nvXDRnVWzlRry/pwdkJzD6QR4Fy1GWAag55lTbtYL439D9wTY9yiDHq4i9HOKQ5Tmf25BCdL9TwGrS0DTigP+HFhmZ7OsyMM0OdA/opQOrLyAtjO+OuqFzMsoBrJhS0/mN9ITE5DAIpA48C5aW7sBfpXAuIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210841; c=relaxed/simple;
	bh=FziE6qPEEFO5i/8Pmae7ZJ0hOS1RkCMj9FC4Vw6jId4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtKpGGw0NLsKJ9M2AvEmQemPFswOioEOr2rQtXEC6ouhpvlCyZpu51uIS7Wz8khQmluU8xfZh6mBFl8vjMrUdwJiZuMw46y96NgYaVEfmL7eqRb0Ry7Ez/4HvGkndpzaaynW45zFeAF5LKW03hqPC7baH9N/K51FwM5Wxww1S+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+kH4GWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+kH4GWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D898B1F000FF;
	Sat, 12 Sep 2026 11:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210840;
	bh=pz2SNO3X6gyWWbGAXxoaLrIl6OQ/RHVwNYWdlvZ14kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y+kH4GWrmhXQwfaqbMPtWCGQGs5Z1HEB3GLTZoHO5I1orSwpw0/cZoP3gS8jPhlzS
	 2GplNzm+I7XXx1Wfa81LiBKpMKNlpYLZCgx9YrTsDGJC6pU8Fo+zqeoHAtTWUew/fo
	 +RL9pQD+DgQuZUDos5A6bR6X7z6P8D6453w+Sq/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alice Rogers <alice.mei.rogers@gmail.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@linux.dev>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1055/1518] perf python: Handle Py_None for thread and cpu maps
Date: Sat, 12 Sep 2026 08:53:44 +0200
Message-ID: <20260912065647.317111461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 054d1c7717b95d9089cd3b80e9e85fe1f2ea0471 ]

The python stubs allow passing None for threads and cpus to the
perf.parse_events() and perf.parse_metrics() bindings. However, PyArg_ParseTuple
parses None into a Py_None object, which is not a NULL pointer.
Because the C code lacked an explicit check for Py_None, it would cast
Py_None to a pyrf_thread_map/pyrf_cpu_map struct pointer and dereference it,
causing a memory corruption crash.

Fix this pre-existing issue by explicitly checking for Py_None alongside NULL
in pyrf__parse_events, pyrf__parse_metrics, and pyrf_evsel__open.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alice Rogers <alice.mei.rogers@gmail.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 9a142beb1eba ("perf python: Validate CPU and thread maps in pyrf_evsel__open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 4a66ce4e8dd76..cf7c2869adf3e 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1096,10 +1096,10 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 					 &pcpus, &pthreads, &group, &inherit))
 		return NULL;
 
-	if (pthreads != NULL)
+	if (pthreads != NULL && pthreads != Py_None)
 		threads = ((struct pyrf_thread_map *)pthreads)->threads;
 
-	if (pcpus != NULL)
+	if (pcpus != NULL && pcpus != Py_None)
 		cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
 
 	evsel->core.attr.inherit = inherit;
@@ -2056,8 +2056,10 @@ static PyObject *pyrf__parse_events(PyObject *self, PyObject *args)
 	if (!PyArg_ParseTuple(args, "s|OO", &input, &pcpus, &pthreads))
 		return NULL;
 
-	threads = pthreads ? ((struct pyrf_thread_map *)pthreads)->threads : NULL;
-	cpus = pcpus ? ((struct pyrf_cpu_map *)pcpus)->cpus : NULL;
+	threads = (pthreads && pthreads != Py_None) ?
+			((struct pyrf_thread_map *)pthreads)->threads : NULL;
+	cpus = (pcpus && pcpus != Py_None) ?
+			((struct pyrf_cpu_map *)pcpus)->cpus : NULL;
 
 	parse_events_error__init(&err);
 	evlist__init(&evlist, cpus, threads);
@@ -2084,8 +2086,10 @@ static PyObject *pyrf__parse_metrics(PyObject *self, PyObject *args)
 	if (!PyArg_ParseTuple(args, "s|OO", &input, &pcpus, &pthreads))
 		return NULL;
 
-	threads = pthreads ? ((struct pyrf_thread_map *)pthreads)->threads : NULL;
-	cpus = pcpus ? ((struct pyrf_cpu_map *)pcpus)->cpus : NULL;
+	threads = (pthreads && pthreads != Py_None) ?
+			((struct pyrf_thread_map *)pthreads)->threads : NULL;
+	cpus = (pcpus && pcpus != Py_None) ?
+			((struct pyrf_cpu_map *)pcpus)->cpus : NULL;
 
 	evlist__init(&evlist, cpus, threads);
 	ret = metricgroup__parse_groups(&evlist, /*pmu=*/"all", input,
-- 
2.53.0



