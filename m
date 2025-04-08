Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76210267F4F;
	Tue,  8 Apr 2025 11:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111700; cv=none; b=ki6lp+dsiYpuuXJ5/+3DSk66pqleUPuN2bGFppe2BtRL2SNIObSy5iJuVnlq48WsyU0OdLGSBW1SzjzSnx5LKt9eM2asxcNavk2+KEgVPpE8bPDZ/RZD2gUE1pBV/AsNjC44iKLMohMk+YYW9OjfQSGixb0lRcJAjhs2zf8nmYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111700; c=relaxed/simple;
	bh=qibAHURy7fwYi2MNonSv7E+A4cVKl1yTXQ9Ez6ZhHTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaDZViwhGPJskg8/mDZsoTRiH3x2+sSa9O3NEM62jCFOfP2QVa+JUj970qWO354Ci01ooeb9zSLSI53CZ7I6U1Q2Fs8YvKQ8VxLTWXwZ9O5SCBBiG8eP3w/5VqghEyjrT6+ByCmGoB6HNULxbULXI3Vq6jWa5UAcZhdSUEP5eVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sh8awW0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sh8awW0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AEFC4CEE5;
	Tue,  8 Apr 2025 11:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111700;
	bh=qibAHURy7fwYi2MNonSv7E+A4cVKl1yTXQ9Ez6ZhHTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sh8awW0t+yayUNR5LHWdOHt3YgiJTsV+zEFzqIW07ShtJg3aIrNcKejDammJK5bFF
	 Vw2cxAEBXd7AMWqBZz+/+DSRpBzvgjkTeEHfZkHhRHH6HAD5infT/DdpJRPRb0VjM7
	 k0nyz6o3kRtkMopOfdzDO67braTzAs26nsBar3zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 527/731] perf python: Decrement the refcount of just created event on failure
Date: Tue,  8 Apr 2025 12:47:04 +0200
Message-ID: <20250408104926.530802369@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index ae6bcd39a2001..5370fff2525f5 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -984,6 +984,7 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		evsel = evlist__event2evsel(evlist, event);
 		if (!evsel) {
+			Py_DECREF(pyevent);
 			Py_INCREF(Py_None);
 			return Py_None;
 		}
@@ -995,9 +996,12 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
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



