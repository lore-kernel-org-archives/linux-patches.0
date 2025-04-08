Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5937D266EEA;
	Tue,  8 Apr 2025 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113375; cv=none; b=IQrheTzN9dNY4caNdpzakbVRclytIwEFJJzIrk5wtU5TbHiqh28JSm6JaOaypBB6XrFTXlDStYzVx9zlRe8k0cen3rfzXJtkTrI7XU3eOQWYCtBCfP0sW2AL9Hx0y/8OtBwM/ebato5007x862q8mX4n8Qlbfjd8AbXrQMzZi4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113375; c=relaxed/simple;
	bh=mRGNGM4zKCRsOIMbKKOhGLTJ5cMQI+0N/OOCzZmhuyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9aMzPBJMTHkonjx20MksuqLwI+d3J3kj2/aDF4qw+I3qje2X76YIxdUNw/1EsXW4/sz+8skGLV2clxs+oVy5yQuhXtz7uFpbkO/i/AtYvAOts9fXwlVVzrgOI2K73a+BRMrqZ5MEENoROKI9si7xK9O2Y3p1lV9zpW/Z6YSRBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ig5AVuGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ig5AVuGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA22C4CEE5;
	Tue,  8 Apr 2025 11:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113375;
	bh=mRGNGM4zKCRsOIMbKKOhGLTJ5cMQI+0N/OOCzZmhuyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ig5AVuGhcW9oLGXU0b4wuT606Nyk7nReVWk1sNtyjz4B1bO4NYKDEPfeJKJQ1hRoY
	 Kdeg5Ozq6zTkP8pYMuPzAEkBfcYQXDycA8K4Wnrh8iHlHQEQntDL4sZUWrSLkeKmK2
	 rRobjZ1cS7DKyQKnx/gerPAbWcrf59RBPM8WvPY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/268] perf python: Check if there is space to copy all the event
Date: Tue,  8 Apr 2025 12:49:07 +0200
Message-ID: <20250408104832.189239071@linuxfoundation.org>
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
index 4697bbb17c39a..06a1e09d7349c 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -671,6 +671,11 @@ static PyObject *pyrf_event__new(union perf_event *event)
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



