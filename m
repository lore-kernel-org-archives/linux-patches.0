Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AF41BD9C9;
	Sat, 12 Sep 2026 08:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203002; cv=none; b=c74/4ESejmCDqRBZr6T2gN/Fsee9uwh3jnSnf4lOCFFcL2FZ23E2/nnKtdAzY1cRrH2ZlS8uhHIrTnZvlX3SlQ96noGSL6AVPgFIKDe+gKYb1pwWLGBJYMp4nTr/C2M5+KMdmZ1zli8phtJZ/swilHwOB3RJw9ZyHkOQaXZrTqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203002; c=relaxed/simple;
	bh=UBMlEOgLQdvg3JjipxGRv/qtHIYigH93TFj030rVCjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7/DL/7YwKzLVI9RFOIiNze69UDgFll2pXsjNIFMybZnRD5IwLMaBGEGU9odyV9xGrvI71o6ENJEALk3UhH05v44GhWhZWANMcDY8oYrtlkzB+sKxzkopwqm/29pqJt3SDwYxnPp63WNErvgmpuT2jYLAOVmJSrTVf2Rd/8e4nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogmJTrJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogmJTrJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82EA1F000FF;
	Sat, 12 Sep 2026 08:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203001;
	bh=pbLGtYhtnMjXaPtq2Aw1WiQzvkxASVoA904qbsJ6evo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogmJTrJvv4kODDOvpHKL3nKtfUtqWNfjZvIpFGDthD9sylmkkOQmTRettA0F3N1Bc
	 AG3g9GaBfQcW4eiXtLidt8cU0H5xfOKbyEQz6FPLC8hSRY+8DCbddVdRlqnePOh0iL
	 +hq5NPmGNmxin97LUWnYruiZsKl8K4AQ/RDSdSFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1282/1815] perf python: Fix count_values memory leak in pyrf_evsel__read
Date: Sat, 12 Sep 2026 08:50:32 +0200
Message-ID: <20260912065719.112128394@linuxfoundation.org>
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

[ Upstream commit cb45ede21d02cc85de18ce6b60a51a7449f4179b ]

In pyrf_evsel__read, if PyArg_ParseTuple fails, the allocated count_values
is leaked. Move the allocation of count_values after the PyArg_ParseTuple
call to prevent the memory leak.

Fixes: 739621f65702 ("perf python: Add evsel read method")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 86a3fcb5b5e83..dc1e19f5eddf3 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1199,11 +1199,6 @@ static PyObject *pyrf_evsel__read(struct pyrf_evsel *pevsel,
 
 	CHECK_INITIALIZED(evsel, "evsel");
 
-	count_values = PyObject_New(struct pyrf_counts_values,
-							       &pyrf_counts_values__type);
-	if (!count_values)
-		return NULL;
-
 	if (!PyArg_ParseTuple(args, "ii", &cpu, &thread))
 		return NULL;
 
@@ -1222,6 +1217,10 @@ static PyObject *pyrf_evsel__read(struct pyrf_evsel *pevsel,
 	if (evsel__ensure_counts(evsel))
 		return PyErr_NoMemory();
 
+	count_values = PyObject_New(struct pyrf_counts_values, &pyrf_counts_values__type);
+	if (!count_values)
+		return NULL;
+
 	/* Set up pointers to the old and newly read counter values. */
 	old_count = perf_counts(evsel->prev_raw_counts, cpu_idx, thread_idx);
 	new_count = perf_counts(evsel->counts, cpu_idx, thread_idx);
-- 
2.53.0



