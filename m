Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EC81AAA32;
	Tue,  8 Apr 2025 12:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115792; cv=none; b=MhI8q1sjmrWbe0keNQBb9705h5AfUBny4V0cL0W01CvJ4tzx/1k9wISdhZy3g6zi4LHZQPKtuvaWQvVI2WdBpB3inTLEtPzJjoiVOgr7uQ5yi176h7vMJFcN/1pQehrEyyjjMV5KloPm1WPbeQztj1WeaXWisxGCgDtVXlbjSIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115792; c=relaxed/simple;
	bh=wsY2/b6E4YquKT9jqVffAQCwmj2JIyffV/lK3D1a5Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfjmOcXng0ipGNJgcv07NcuxcR5Q/j5+ZxS3zrjugyX8PF2M+oH+QbrDCf5Q/eqAKPXOKRMZn7LlUQYichf3FMY9488YqJvXQ1qQE0GGGtSj0uq4sK44iyQIwXXdA45ILPnXA9zKvtwOb1bP5t01WHBslCymKiIKS5jZDYtjpZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRsvDn7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRsvDn7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23C24C4CEE5;
	Tue,  8 Apr 2025 12:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115792;
	bh=wsY2/b6E4YquKT9jqVffAQCwmj2JIyffV/lK3D1a5Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRsvDn7pUnFKgmb5ZBEvPXHVw04qJugJ9ztHib6sQ0wbTcoTqonCvs6Fe/hwiCXYq
	 e/ArYmgrd2czlx31GZGkt/CXynXr6QHKZnSxovxEorAsSxLzoKM8ftombk+H6Vwnw+
	 u8+YRo5O1N2nJ0hRPlTVYxat8yZaVKMcxzlVPjSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/204] perf python: Decrement the refcount of just created event on failure
Date: Tue,  8 Apr 2025 12:50:35 +0200
Message-ID: <20250408104823.416141709@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 3de5a2bf5b4847f7a59a184568f969f8fe05d57f ]

To avoid a leak if we have the python object but then something happens
and we need to return the operation, decrement the offset of the newly
created object.

Fixes: 377f698db12150a1 ("perf python: Add struct evsel into struct pyrf_event")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250312203141.285263-5-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 9ae5ffea91b48..894a9966599fd 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1109,6 +1109,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		evsel = evlist__event2evsel(evlist, event);
 		if (!evsel) {
+			Py_DECREF(pyevent);
 			Py_INCREF(Py_None);
 			return Py_None;
 		}
@@ -1120,9 +1121,12 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		/* Consume the even only after we parsed it out. */
 		perf_mmap__consume(&md->core);
 
-		if (err)
+		if (err) {
+			Py_DECREF(pyevent);
 			return PyErr_Format(PyExc_OSError,
 					    "perf: can't parse sample, err=%d", err);
+		}
+
 		return pyevent;
 	}
 end:
-- 
2.39.5



