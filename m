Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9F7400DF6;
	Sat, 12 Sep 2026 08:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202895; cv=none; b=CUj3VQAu87uJEe5ifBTVyUr6Yl7lHqeaY0JI95ZsxGZo8/+oqTz5iakWz0l7aSZJ5kD1q7amyIcO1EC3Mt3/OSfKXpY6+/Te/cwB0afe3UHL9mZYIWHzeqlTymrMI5iMy/nQ1vVpgNeMvsCGVBPZupvtIfCsnCvknXpuSgJkMP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202895; c=relaxed/simple;
	bh=3gUDO3vnaJMtuSsJjeWiFNAApQUjk+QPCjR8LrcOjaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYYdQrcAEBK5mreGDBnQy4cLYfEcU+VoKGfcH4cUnmPwxDwx9Ee4VmsW2LtTmlaCjGkkY6P4jzpM6KmHEFciXz81nxLCQIyqpNba08/99AEFP9IBqUnoGtEpRpd+HtTN+lZqrF2IBICHgnNFdPHM1CEy/n+lcV52uPD6wW0p0/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6lOkT3o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6lOkT3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30EC1F000FF;
	Sat, 12 Sep 2026 08:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202893;
	bh=1d1tkejMK7top05md3cQjRqwz+w7tO5dMRQQuUkgQ8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6lOkT3oAV6XD9SecWchGb06q7uTU71gkgBbKQGdb4I3K7McYTMfrSuaotBUI7Y8J
	 L1eIE2D0N9NlCuoaJCzZFGTyzH1RI1elvUKje6k0GKBP1m7YFYLrYF8cSZjTa1ImDT
	 ZZwaTISKQi69UeBM94NMyzltI1cXYcNHCuLLGJ3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1280/1815] perf python: Validate CPU and thread maps in pyrf_evsel__open
Date: Sat, 12 Sep 2026 08:50:30 +0200
Message-ID: <20260912065719.066248609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 9a142beb1eba42b986dc7016f4fc1a3bc28b8c09 ]

Add explicit Py_TYPE checks to ensure the arguments passed are
actually of the correct pyrf_thread_map and pyrf_cpu_map types.

Fixes: 877108e42b1b ("perf tools: Initial python binding")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index a04e3f9ddc475..5713e54437f0e 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1107,11 +1107,21 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 					 &pcpus, &pthreads, &group, &inherit))
 		return NULL;
 
-	if (pthreads != NULL && pthreads != Py_None)
+	if (pthreads != NULL && pthreads != Py_None) {
+		if (!PyObject_TypeCheck(pthreads, &pyrf_thread_map__type)) {
+			PyErr_SetString(PyExc_TypeError, "threads must be a thread_map");
+			return NULL;
+		}
 		threads = ((struct pyrf_thread_map *)pthreads)->threads;
+	}
 
-	if (pcpus != NULL && pcpus != Py_None)
+	if (pcpus != NULL && pcpus != Py_None) {
+		if (!PyObject_TypeCheck(pcpus, &pyrf_cpu_map__type)) {
+			PyErr_SetString(PyExc_TypeError, "cpus must be a cpu_map");
+			return NULL;
+		}
 		cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
+	}
 
 	evsel->core.attr.inherit = inherit;
 	/*
-- 
2.53.0



