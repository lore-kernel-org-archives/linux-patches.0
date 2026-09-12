Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F50918A93F;
	Sat, 12 Sep 2026 14:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223121; cv=none; b=L83HzqMkzrSj9r0xa0fhUed1/ql6J0rrXzhNXZiavcrZVp9CuMpaLwhKlNJwCUAcoHGPnyU7GPG4Gbuae5c60ddUCJ/ULFwH3kvb37QRk2qYvtGC1wMUabjm/gI+b+ih9SO9U5iJxbKjoih7HbUpT1QckL78gpDIdmHtQmj3WZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223121; c=relaxed/simple;
	bh=0MGMQQFhJ0xWZK5QucKV7KXD46fwqGI4X+MTDOBUWIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTE+qhGl6XOMR97e3pROUO994vNkVgJCuSzIF4NN1VlOJxhaatqRUeVOdmXuhoBL888mXXjXK2mTNc9nbfYAwyU8RIs6w8efmK5prwWc0dtht8CXbzLMAA6Z+nK2k8eL9R+IDIUd67p8qPPASmJ1zqrnFuyiiTcnInfI6COZSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTUabpWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTUabpWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0E21F000FF;
	Sat, 12 Sep 2026 14:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223119;
	bh=TGYv1p7JjYVsvVoW+3cSD834FUNbYI+nsTRkUX04Whs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTUabpWy20CldwUw0Z3djup10NXJBaI783qgtYIAGkPNpsVIxyTni/tADlg6M456w
	 vAwUMpWmI7tWGbgmapJwcTdvsgrWVmtpUgI6zZ6H+8flNK7dSvRW/oYVLaH8jy9QF9
	 neG+ALzGY+Fq7a8VnfLk+3uBLTpEgwewZDHnd5ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0682/1424] perf data convert json: Fix trace_seq memory leak in process_sample_event()
Date: Sat, 12 Sep 2026 08:51:54 +0200
Message-ID: <20260912065622.573349544@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tanushree Shah <tshah@linux.ibm.com>

[ Upstream commit dcb87c88952046ef43cb5ba3a5b95eb29c362a16 ]

Unlike the in-kernel trace_seq which uses a statically allocated buffer,
the userspace traceevent library's trace_seq uses a dynamically allocated
one. Therefore, every trace_seq_init() call must be paired with a
trace_seq_destroy(), otherwise it produces a memory leak.

In process_sample_event(), a trace_seq is initialized for each field when
formatting tracepoint raw_data, but the matching trace_seq_destroy() is
never called, leaking memory for every field of every sample processed.

Add the missing trace_seq_destroy() after using the trace_seq buffer to
properly free the allocated memory.

Detected with Valgrind on a perf.data file with 2,729 tracepoint samples:
  Before: definitely lost: 55,537,664 bytes in 13,559 blocks
  After:  definitely lost: 0 bytes in 0 blocks

Fixes: 9d895e468429 ("perf data: Add tracepoint fields when converting to JSON")
Signed-off-by: Tanushree Shah <tshah@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data-convert-json.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/data-convert-json.c b/tools/perf/util/data-convert-json.c
index 5bb3c2ba95ca2..30f92656d5fba 100644
--- a/tools/perf/util/data-convert-json.c
+++ b/tools/perf/util/data-convert-json.c
@@ -242,6 +242,7 @@ static int process_sample_event(struct perf_tool *tool,
 				trace_seq_init(&s);
 				tep_print_field(&s, sample->raw_data, fields[i]);
 				output_json_key_string(out, true, 3, fields[i]->name, s.buffer);
+				trace_seq_destroy(&s);
 
 				i++;
 			}
-- 
2.53.0



