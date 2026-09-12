Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9A9343893;
	Sat, 12 Sep 2026 09:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206726; cv=none; b=dfwdaRCQ85xARv5TtfSELCvB+NQbKcSwE1+G1Fl2jLhJ5lGl3DcbSkKrjXx2+GjNqWNAvC/FrwLmj+qUHISxuR1gDTHR70TA4DFdlFJY0JkFl+2UC0VRXlRwFgSF3qztmnxuPcRYm7qU0w4Px4LlE4yr7VvEqk2vOVMa0z7O3V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206726; c=relaxed/simple;
	bh=eLkyhpN4DTddqc6RMnTCEas9p9AoehPVnbEURJifjVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUyags+y4XMUFoZ2vQw1oRiGPfz99KjWS7jr70LO4AI5/9cEOtfflaD2db0y8jco5DgNx1B7KsMI16Wqm/TFwww1g4flj2KvIys8UND6Y7V0wiqTqLgVk6gamGn32Xzh4UuhK9n+q5KX7fjL3E3Q1uUqnKlfmDJ16SJJMuG9Ggo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIVH7xf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIVH7xf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59DC1F000FF;
	Sat, 12 Sep 2026 09:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206725;
	bh=dHoFxe2v6bgZG9pfYUF4YKnAvgY5gCSIGSDzO1xtn2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIVH7xf5DX6NgWOxlXOa/cwibH4cUSrphNbIhLPq2DC3KZDTJlCWpV7Gb4LR4rvtf
	 RZ71NYqGyXjM6kUDHxO3c35AnFC+eGkooJrPdFDD+W9Pm6Mg388J58QyPGLebj2pXJ
	 qUTAbtAtGS4OosBFjBxHhntco7hJHjnYSWwMQl5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0265/1518] perf data convert json: Fix trace_seq memory leak in process_sample_event()
Date: Sat, 12 Sep 2026 08:40:34 +0200
Message-ID: <20260912065629.482634376@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9dc1e184cf3c9..9c96d84df900a 100644
--- a/tools/perf/util/data-convert-json.c
+++ b/tools/perf/util/data-convert-json.c
@@ -242,6 +242,7 @@ static int process_sample_event(const struct perf_tool *tool,
 				trace_seq_init(&s);
 				tep_print_field(&s, sample->raw_data, fields[i]);
 				output_json_key_string(out, true, 3, fields[i]->name, s.buffer);
+				trace_seq_destroy(&s);
 
 				i++;
 			}
-- 
2.53.0



