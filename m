Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926BE26A1A0;
	Tue,  8 Apr 2025 12:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114961; cv=none; b=PpI4suxQwpxQdEw+8GAH233zIPgzNRM8a1N0GcAyvrdBFRdwmWFdrA67MtSlb9hZP1zDGvOMXuRbb1wflLv7lBCPm8u2+MGsYvsJKqZnS96n3ly5jvDqMHntNJK3bE670/SxCtUN2WCSdXxk27hTAh7pbDSysta5kOITmcEXVLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114961; c=relaxed/simple;
	bh=8XMZReQYNx8dATsrY7EqnIsl199ixr2LKMf/eMdbFR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qA1cNW9TC+s3xUvnknh8Q0hs0XeYd8mNO5F9XfrgtgnuYnwG3HUDI6UM3KdJ/0JjWFFX2Ee7QgGR91qajkTqrNdKMt+9LWuGclyoahUnJawUACVaoQiiD1i+G8UlWqpMFdWYrxktqEImPydPsfhdEp9hyX6gxEf4OxYdOgkRkwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mg9EptXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mg9EptXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89285C4CEE5;
	Tue,  8 Apr 2025 12:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114961;
	bh=8XMZReQYNx8dATsrY7EqnIsl199ixr2LKMf/eMdbFR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mg9EptXDYlEEAM5u8xZLx6sMA3GJnxNv5IaEPjtBzhpw7Mo2MpeDbWm55S1wnEFks
	 4CGvC0T5+EeFqEuVkWjh9LhnBFdiO2VHlJj+fi/SEQitblbipGfC0J7X0h0vpAlu1y
	 KNFvMghbdT+HU0UM8IHXwr9LVm0P0FfI8ekad8zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 259/499] perf python: Check if there is space to copy all the event
Date: Tue,  8 Apr 2025 12:47:51 +0200
Message-ID: <20250408104857.672055085@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 3453d150fd237..56b174d8ed9c0 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -512,6 +512,11 @@ static PyObject *pyrf_event__new(union perf_event *event)
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



