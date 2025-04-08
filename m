Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF601AAA0F;
	Tue,  8 Apr 2025 11:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112833; cv=none; b=tqyJg7A4+13xo07RljRk+tLneB+8l9T9NT0jO5yqLzi+7hikLdTFlMqo0Bd6ONdm77yR1IlLDDLuAmefjSZAtrkONkitHKeWWpdYQbwdoojWzv3NOFV1gPchvWYFjshfDUSp01EmvB3ig2WOpdOVPP6Qucw5J6bbKQDrmA/l3ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112833; c=relaxed/simple;
	bh=GX7poqs+V8KaVGukVrku0kPmqvGLo61z3FZM/ZA/l1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hblV2bU1cqDNylIEJ37/Xc8tvZY3iVz+OajAPmoD00ME6c3bhXhk/PhAJIU9GaEG/VM48k1XqMKKmIukRo2tE8GAW1Ru63Jy5MyerXO+JTLugVCSmM9naFzhq98+hqvVXHKvnnf6uBUkPvEji0ixANEF2KnLCzYro2uaT9DHpOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsYXPuP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsYXPuP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F81C4CEE5;
	Tue,  8 Apr 2025 11:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112832;
	bh=GX7poqs+V8KaVGukVrku0kPmqvGLo61z3FZM/ZA/l1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsYXPuP/zIF3/V3LIbFuOpDci2Pd7NQhucUi6Rt5MxiFl56UeAyafVwdRGbFRCFBB
	 p3FfzMqpg5hh16vpNBF7RgW+nDd5c+ZPE+CcOxwCOa1p8U3CzpoyxIQSBQUwW972f2
	 Aj/wUkx/HjI0OKSooXPqoA/2nMda296zfrY/OAwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 207/279] perf python: Decrement the refcount of just created event on failure
Date: Tue,  8 Apr 2025 12:49:50 +0200
Message-ID: <20250408104831.929243265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 13d65a3cc6d7d..368a5f2c244c8 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1084,6 +1084,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		evsel = evlist__event2evsel(evlist, event);
 		if (!evsel) {
+			Py_DECREF(pyevent);
 			Py_INCREF(Py_None);
 			return Py_None;
 		}
@@ -1095,9 +1096,12 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
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



