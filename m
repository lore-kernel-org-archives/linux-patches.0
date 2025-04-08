Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E56C2686BC;
	Tue,  8 Apr 2025 12:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114958; cv=none; b=tqerNZ+v7dwRmDrzQS+pxg042jZUeA+gJs9pLSLeWIX4KbU+E3YbwrAYu+aSeFOo/QdQPC7zzNluXq/ypOMCiLELjVzqNCzeepfNgiHxggjSYSkV38gVTacEuh/y3NO4swQxknLZ1pNnaY721hECz4WR+zRbbj0MEX9wJJA20Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114958; c=relaxed/simple;
	bh=v3klfMIGpo/hseEGi6qA+FUYDE5wbHai4vBdhzIcJDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CvsHVmwF2PlVOKlsJxMBNl2OOpGCgqnzoFjMTmyN9uJkxKmOw0WkNuXnEnx5ZH7uBT8s5ws6ERCTC9g3ZxqxFZh8JAEYsoJOvNpG3NAFynMPdHtlPNGzYW005jrYB2w4HgHi/02AyGKafdjbRBu22z8y2XkoP4IiUG2aABc78H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smePyt3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smePyt3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4194C4CEE5;
	Tue,  8 Apr 2025 12:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114958;
	bh=v3klfMIGpo/hseEGi6qA+FUYDE5wbHai4vBdhzIcJDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smePyt3eT0a1KWr47w43tXxhQfq7Ky1zjAfMwNUqKe8dNbLYeIqIXLeYiMyFU3aKM
	 ExCAVlhMZP/N7Dn1lLT4g4haZyNYbBIOxt9GaFURCbiTMmM6kBWCypjdQ/7Bm34zDP
	 0IavzF/7ik7TBKcQvQT9bieRUN7dL/FxrQG5bCFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 258/499] perf python: Dont keep a raw_data pointer to consumed ring buffer space
Date: Tue,  8 Apr 2025 12:47:50 +0200
Message-ID: <20250408104857.645652621@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit f3fed3ae34d606819d87a63d970cc3092a5be7ab ]

When processing tracepoints the perf python binding was parsing the
event before calling perf_mmap__consume(&md->core) in
pyrf_evlist__read_on_cpu().

But part of this event parsing was to set the perf_sample->raw_data
pointer to the payload of the event, which then could be overwritten by
other event before tracepoint fields were asked for via event.prev_comm
in a python program, for instance.

This also happened with other fields, but strings were were problems
were surfacing, as there is UTF-8 validation for the potentially garbled
data.

This ended up showing up as (with some added debugging messages):

  ( field 'prev_comm' ret=0x7f7c31f65110, raw_size=68 )  ( field 'prev_pid' ret=0x7f7c23b1bed0, raw_size=68 )  ( field 'prev_prio' ret=0x7f7c239c0030, raw_size=68 )  ( field 'prev_state' ret=0x7f7c239c0250, raw_size=68 ) time 14771421785867 prev_comm= prev_pid=1919907691 prev_prio=796026219 prev_state=0x303a32313175 ==>
  ( XXX '��' len=16, raw_size=68)  ( field 'next_comm' ret=(nil), raw_size=68 ) Traceback (most recent call last):
   File "/home/acme/git/perf-tools-next/tools/perf/python/tracepoint.py", line 51, in <module>
     main()
   File "/home/acme/git/perf-tools-next/tools/perf/python/tracepoint.py", line 46, in main
     event.next_comm,
     ^^^^^^^^^^^^^^^
  AttributeError: 'perf.sample_event' object has no attribute 'next_comm'

When event.next_comm was asked for, the PyUnicode_FromString() python
API would fail and that tracepoint field wouldn't be available, stopping
the tools/perf/python/tracepoint.py test tool.

But, since we already do a copy of the whole event in pyrf_event__new,
just use it and while at it remove what was done in in e8968e654191390a
("perf python: Fix pyrf_evlist__read_on_cpu event consuming") because we
don't really need to wait for parsing the sample before declaring the
event as consumed.

This copy is questionable as is now, as it limits the maximum event +
sample_type and tracepoint payload to sizeof(union perf_event), this all
has been "working" because 'struct perf_event_mmap2', the largest entry
in 'union perf_event' is:

  $ pahole -C perf_event ~/bin/perf | grep mmap2
	struct perf_record_mmap2   mmap2;              /*     0  4168 */
  $

Fixes: bae57e3825a3dded ("perf python: Add support to resolve tracepoint fields")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250312203141.285263-6-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/python.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 88404e5c462f6..3453d150fd237 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1018,11 +1018,9 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 
 		pevent->evsel = evsel;
 
-		err = evsel__parse_sample(evsel, event, &pevent->sample);
-
-		/* Consume the even only after we parsed it out. */
 		perf_mmap__consume(&md->core);
 
+		err = evsel__parse_sample(evsel, &pevent->event, &pevent->sample);
 		if (err) {
 			Py_DECREF(pyevent);
 			return PyErr_Format(PyExc_OSError,
-- 
2.39.5



