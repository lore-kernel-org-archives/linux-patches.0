Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A10269AE3;
	Tue,  8 Apr 2025 11:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113370; cv=none; b=DtooqIFHam79skFp7lxQ5/EBPUbjWcTmU9ZVH3EpCBNI9/ShrxIkRnesbJ2LDraxs08X9qfSg8cONhOB+Zlzc6Nqd7r8XiBGMGqYspDI8bCIQtGde2GMGvuQC7XGzKi88EwsqRQLhSsfGLuFKiCk+XJJiDeAgGg8ixlMfLXKIPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113370; c=relaxed/simple;
	bh=UHcRt/b3iB3W0aQLvXOpLOl8uXmosSK565x7DtR6ZfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4+farkT8FMKsq6BcvRrCOHV26j1+9DzSI1XdHHXphs6U+xcGZfYh3kQghqSpl50x/ozqrD0lw5CkPOsNrOwesYlHbnrJnnFxj29XBE5ZKPAoxvyT5GU5gyddWvek+OsOervZNc/7j4tTvDEairfaeYKSV0yQOoHQoanfyYA25U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDKgpuVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDKgpuVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87C7AC4CEE5;
	Tue,  8 Apr 2025 11:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113369;
	bh=UHcRt/b3iB3W0aQLvXOpLOl8uXmosSK565x7DtR6ZfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDKgpuVZ5c/5noRuhED452Ovsw7NCV9DpqPBL061Bo6nWMMgmR8sTPxrrB/1brxxW
	 hmJyqiLG9XdSPKVozVJkNI5kThPwy9Z2Wk/lfh40G74G1p+ez9llaJi00WC4mtbwTQ
	 41tX80kKlUIkpkDUl/61Z0PgRq8xf4o42f4db2vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/268] perf python: Decrement the refcount of just created event on failure
Date: Tue,  8 Apr 2025 12:49:05 +0200
Message-ID: <20250408104832.130187341@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8753c9d3670ac..47c43b9c72fe7 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1170,6 +1170,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		evsel = evlist__event2evsel(evlist, event);
 		if (!evsel) {
+			Py_DECREF(pyevent);
 			Py_INCREF(Py_None);
 			return Py_None;
 		}
@@ -1181,9 +1182,12 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
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



