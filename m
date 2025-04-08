Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08614224234;
	Tue,  8 Apr 2025 11:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110180; cv=none; b=lkxHunef5GJlBHV34HFVzC2417Vgx5S2YtUnXPUGKbz0BZg/zXYin+JXnJAp5UATVBGJXeIM6uYmxKGm270zZlDzeWGL6840K4+eXFI1sRDtzM/EYm7Dou3eCXhBafadSicrBx1nVPqHE7Eeoc6R//j5EmRpZaAQsPzfwJ7GX+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110180; c=relaxed/simple;
	bh=U6aqT2MSTR8/aDNAzIgKE/rzsPV6Nq5mGiB9aCE+LDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtFL2XfodRNAWoOQrLZD3FcvjiaUJBBd3NRz5z9TJeOoIN32tjm1IDMAWbc0sv0jT6YL1s+tUlwldOhAOMfds9rCJ+OGNQGlrb1ZWNrXJI0A4RMydHwV2hVJnK9b0B5rBq/cI4BsoOZrsH2N3n35pTsK9AoSj9gRYWIqSQo3oPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxh9gsG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxh9gsG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E42C4CEE5;
	Tue,  8 Apr 2025 11:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110179;
	bh=U6aqT2MSTR8/aDNAzIgKE/rzsPV6Nq5mGiB9aCE+LDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxh9gsG3TywAB4o73JjWtKdtinzAZefXyXo6zzQ/4NJQM4ctC078oeeEeaZMh8YIy
	 NNU6wtlWUSVoCRDFHox0rpDT3AjpcDVrH2YUwjBZDb9GLusdcag9MDU00RVpAo6uEU
	 j41nASdkMP8EsTCTFbsVGGHyxDhM+C0BcRrLO14w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/227] perf python: Decrement the refcount of just created event on failure
Date: Tue,  8 Apr 2025 12:49:08 +0200
Message-ID: <20250408104825.415439265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 51679d8d40b1b..ab3a444b4b868 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1057,6 +1057,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		evsel = perf_evlist__event2evsel(evlist, event);
 		if (!evsel) {
+			Py_DECREF(pyevent);
 			Py_INCREF(Py_None);
 			return Py_None;
 		}
@@ -1068,9 +1069,12 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
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



