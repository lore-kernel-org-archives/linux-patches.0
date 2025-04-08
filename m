Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0141126773A;
	Tue,  8 Apr 2025 12:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114060; cv=none; b=nRZGxOc5BaM0xEwW4Go86ubrPSA0+cVl4BEj1sy30JRQ18G2BA5+fCwDMtaGrkbOlFkDJi50cNI9UO9qAPlR2i1UB3UFjYGkC6HAoH40qhrGr58O8rqJEzr10uYWW42EYZ4wH6fRi8lYMHM5c+ZyCd3w4NWCeyBlkqdw2mZ/nf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114060; c=relaxed/simple;
	bh=4LteofqB+JgJKiivTjwTYGvzwOaJoI++3v94qR7Dc0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CY8Xc54mPwix5bcPyHdS65GWVXQUAEwV0QPlh8UL04etnZIiKevh536l9FSttBu7qMSszSX8tN8k4gSNYU2wfLXSTU3iK/gBKGHzCCv44mYSyy33qa22NcYBQLJbBpDKwQf1SczIrXF/3OYqPlQb4Zn/885TnTb4sZhFU/Kd2ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0GTxpj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0GTxpj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4CBC4CEE5;
	Tue,  8 Apr 2025 12:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114059;
	bh=4LteofqB+JgJKiivTjwTYGvzwOaJoI++3v94qR7Dc0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0GTxpj/lY5Ysp80Q6ckp8J/w8K2BtBZUn3HgWsWIIAusGl/QyJYIEk+yxammeO3K
	 y46knB7QjW+g6VqLpUo10Ah/TJ+detfup+6E86kQ/e6UDsaeIBGTQLbYScNh5QGHQO
	 rfPlBl5NTbSxwxuE1GP+YLbF65P+XsdKX/o4VkPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/154] perf python: Decrement the refcount of just created event on failure
Date: Tue,  8 Apr 2025 12:51:03 +0200
Message-ID: <20250408104819.225863132@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2ff87ad8d7e88..594c738e4930f 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1036,6 +1036,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		evsel = perf_evlist__event2evsel(evlist, event);
 		if (!evsel) {
+			Py_DECREF(pyevent);
 			Py_INCREF(Py_None);
 			return Py_None;
 		}
@@ -1047,9 +1048,12 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		/* Consume the even only after we parsed it out. */
 		perf_mmap__consume(md);
 
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



