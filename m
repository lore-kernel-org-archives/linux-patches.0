Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7511AAA32;
	Tue,  8 Apr 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115797; cv=none; b=Gr0KlIEzSz0IHtUjJP9nSeVOu2DmgDo05RSF9NDeHGK0ohceag7MvKMffasSLIzlrhjV4/5l0lcowIhU89EgxfW5n9ed8dAhKM7/Bn96wtMAG8dfFwBs7blE25kuGyrmfGYnThZsW0ulwKu4zo1yzdWijr7DvzqrTyr5AeQCIMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115797; c=relaxed/simple;
	bh=TVWZ+obbIsMLuQmKkcOZGSF6mXXKAk+e01ZnReUyonQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkipHaeZCyV4jNfwjHUNSJih49yn3zk7JXxS3kagxEV5uMyEoMK8n06u3M7EhFpDXQ2uNxvVSognP7+sXdyxvs1yy+smgQyDBdbTuHhFj4QRKp+KoZBEfRb3drd5bHoj66QU1bom9vQ9fVXZop0FuPffhwgKF1AqGXP9l9XhyuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRXL+XGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRXL+XGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B688C4CEE5;
	Tue,  8 Apr 2025 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115797;
	bh=TVWZ+obbIsMLuQmKkcOZGSF6mXXKAk+e01ZnReUyonQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRXL+XGKhFZJ2VyH1L3B7jwrmjGNOnurCsntTLGj9ZNjtI6dILf2tThGGjrcEIgXk
	 XXqIgtUOM87Z+tXgldVfwbEBmuMO4Rp6bSLXs+GEuX/q2KlnpchM8hRmGoc48Xh7+m
	 DtHlTfOiriTptAlXB/tzLbvez+lspGvwJdMjEJZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/204] perf python: Check if there is space to copy all the event
Date: Tue,  8 Apr 2025 12:50:37 +0200
Message-ID: <20250408104823.472545876@linuxfoundation.org>
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

[ Upstream commit 89aaeaf84231157288035b366cb6300c1c6cac64 ]

The pyrf_event__new() method copies the event obtained from the perf
ring buffer to a structure that will then be turned into a python object
for further consumption, so it copies perf_event.header.size bytes to
its 'event' member:

  $ pahole -C pyrf_event /tmp/build/perf-tools-next/python/perf.cpython-312-x86_64-linux-gnu.so
  struct pyrf_event {
  	PyObject                   ob_base;              /*     0    16 */
  	struct evsel *             evsel;                /*    16     8 */
  	struct perf_sample         sample;               /*    24   312 */

  	/* XXX last struct has 7 bytes of padding, 2 holes */

  	/* --- cacheline 5 boundary (320 bytes) was 16 bytes ago --- */
  	union perf_event           event;                /*   336  4168 */

  	/* size: 4504, cachelines: 71, members: 4 */
  	/* member types with holes: 1, total: 2 */
  	/* paddings: 1, sum paddings: 7 */
  	/* last cacheline: 24 bytes */
  };

  $

It was doing so without checking if the event just obtained has more
than that space, fix it.

This isn't a proper, final solution, as we need to support larger
events, but for the time being we at least bounds check and document it.

Fixes: 877108e42b1b9ba6 ("perf tools: Initial python binding")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250312203141.285263-7-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index efc8f88db5cff..e25c3fcaecccc 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -610,6 +610,11 @@ static PyObject *pyrf_event__new(union perf_event *event)
 	      event->header.type == PERF_RECORD_SWITCH_CPU_WIDE))
 		return NULL;
 
+	// FIXME this better be dynamic or we need to parse everything
+	// before calling perf_mmap__consume(), including tracepoint fields.
+	if (sizeof(pevent->event) < event->header.size)
+		return NULL;
+
 	ptype = pyrf_event__type[event->header.type];
 	pevent = PyObject_New(struct pyrf_event, ptype);
 	if (pevent != NULL)
-- 
2.39.5



