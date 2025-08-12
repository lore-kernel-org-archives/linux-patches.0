Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8DD2CA9;
	Tue, 12 Aug 2025 18:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024563; cv=none; b=aWvRsrckxVzln6gs8PfuNxlyTXId99SPPZb9toHdJZz8/0ytTbdGzKMGvmGPkMUTlrdDewlLipbqCJpcvJ2y7QdgeBaWhlCChY8sY6GPY6Qj5ujPTM1bUhWgoiE2FFnq+iekbOEfMJggjyEnypml488llmAffw7msFMKqhrwszY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024563; c=relaxed/simple;
	bh=jkPTHBJjyPFOv1n3oec1VNhoRqjDPj0ZLlipupO87Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ozhz8DWnFemFmsRM37U36Wv81QRHK6iMZU86ycj09JXvYvi8Ixnur8V0AdHhlZ/jLTvVnSBjxZKce4C/QmPPOJt6fcPF7nrnJ0K9RIqu14IEavFek7wAcILPUhLph0VqDz9faMfeAv6taGzPkW4O8ac+rjIzdyV5vkMeTxJnyjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+BUO24d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+BUO24d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A16C4CEF0;
	Tue, 12 Aug 2025 18:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024563;
	bh=jkPTHBJjyPFOv1n3oec1VNhoRqjDPj0ZLlipupO87Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+BUO24dG1Uv7827amV/5057bM9fShSDESwkgmjz5T/WdTXIJI23cbgtQn727vn3I
	 11e5nuwOJ467/V6kzB3RDaB/GQAUSQyEkzISS7NTpYGekEO7/UzpLPeDBeIL3Z3N5u
	 MJZJiXLZ0Jqp/XRjOovld63ZFUUwzZr7NSZfmTKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 383/627] perf python: Fix thread check in pyrf_evsel__read
Date: Tue, 12 Aug 2025 19:31:18 +0200
Message-ID: <20250812173433.865322427@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 64ec9b997f3a9462901a404ad60f452f76dd2d6e ]

The CPU index is incorrectly checked rather than the thread index.

Fixes: 739621f65702 ("perf python: Add evsel read method")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250710235126.1086011-11-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 321c333877fa..eb560e3f9e35 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -909,7 +909,7 @@ static PyObject *pyrf_evsel__read(struct pyrf_evsel *pevsel,
 		return NULL;
 	}
 	thread_idx = perf_thread_map__idx(evsel->core.threads, thread);
-	if (cpu_idx < 0) {
+	if (thread_idx < 0) {
 		PyErr_Format(PyExc_TypeError, "Thread %d is not part of evsel's threads",
 			     thread);
 		return NULL;
-- 
2.39.5



