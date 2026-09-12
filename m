Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65853B961A;
	Sat, 12 Sep 2026 10:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210619; cv=none; b=bEu9F0uTY8veZ7X2ZdkJZYimHefnbUU7j/rYMzF3pmd+N/s+4o43o2KpzQVyBGxJSDAIW1dBc2+/s+8N+WgIqnp2CPyt7dTCF7HoMzZGUENsiuLOHkmyLYiLHm36S6GDjPHCmgxlimwF2lrkwVZoMwQIO7qyZj38lRrkthsFeGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210619; c=relaxed/simple;
	bh=deYQRafZFk/xYWWFMKRyecamCgqNe8mEND2EItc4zU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUCUoQIevGWQ/7ZVJnKuimM+1XyEY0GD6dYb+wpgQVSNgsG0f6S/4Soe0HFHBz9XdTx8NkylVVL8M4H1sWXmPpC2QpqlBxE7qA9cqXU1o8zVsUtIrc1Jjv1deucEieHyyBLlYN0pWCo21tSKFDw/9VsGR0rbGdbHGWg0hqBBcOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTs1Uxcg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTs1Uxcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74171F000FF;
	Sat, 12 Sep 2026 10:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210618;
	bh=movxu/ZLD/UNZ/g55QtnPTBtgMma24kn09WfHmvh5Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTs1UxcgDu1CmRJURCiVL5ad2/R7bV1o4gJjz54umXBLM+XZ75eoIM0oT6+Y/i1id
	 OjVmYexRQ4oVjUDLZYNDgvg/dflsS7drZ6NQPTXa7n/weoAlnQ6ym7GJxVXwxptJUJ
	 8HqXcxdsKvJHS5ctSvf935QO7xOxvh2czi4w5W2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1056/1518] perf python: Validate CPU and thread maps in pyrf_evsel__open
Date: Sat, 12 Sep 2026 08:53:45 +0200
Message-ID: <20260912065647.339739055@linuxfoundation.org>
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
index cf7c2869adf3e..cf840804592fb 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1096,11 +1096,21 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
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



