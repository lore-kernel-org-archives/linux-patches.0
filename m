Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A892F6932;
	Fri, 17 Oct 2025 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713585; cv=none; b=S+Xkh9Vf8AJGsS+DmiRkdWG1VS6xrpzvsEBq0fZPJMUe8w4pCqALQYjow1gRoTuTtUurXrSKJQMA2ECtU8gKNi3GPbohG382fANWo8Nb0QxVCbRFihMhCWppZbtOWLbD+CVlnF0CH3hG2pjj8hvergbR8++kTeGPKjVViNkXCzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713585; c=relaxed/simple;
	bh=b4Y2sPiiJ2YG847m2UIHrShijfwWU8HVrEI2Ov/paUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGePixJu84ZXcg9CicTfC4nVYwUHoAA+EkIONNFCFEpFxb1ErSyFADAmQBYPN6rbUzULLDD+yNJ9q3kqriqR4U8fxr0QweBMDFfUxqdOPu2tChbs8pbMsq+3CnzwQ/kaAahmPua88rjlMS+mqP0XBzdUN4f2pXhbOnqaudRhiyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPujA2PY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPujA2PY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B58C4CEE7;
	Fri, 17 Oct 2025 15:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713585;
	bh=b4Y2sPiiJ2YG847m2UIHrShijfwWU8HVrEI2Ov/paUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPujA2PYvezfvjmDwYx3QOkTlbbw9p5kMqEAJ7godANk7kfGOvrsY2DDCVTZXwCP3
	 C26w4tFq6LEtyCE4ov+/6W6eB34SO+Rl4rgYT59aWpvlPHKGSnZijGN9qNRzPHR5tT
	 ycnhLV6mA1gPTb2hEiAI2eCWapmTDPEM6X95tmvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamas Zsoldos <tamas.zsoldos@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/201] perf session: Fix handling when buffer exceeds 2 GiB
Date: Fri, 17 Oct 2025 16:51:17 +0200
Message-ID: <20251017145135.331571381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit c17dda8013495d8132c976cbf349be9949d0fbd1 ]

If a user specifies an AUX buffer larger than 2 GiB, the returned size
may exceed 0x80000000. Since the err variable is defined as a signed
32-bit integer, such a value overflows and becomes negative.

As a result, the perf record command reports an error:

  0x146e8 [0x30]: failed to process type: 71 [Unknown error 183711232]

Change the type of the err variable to a signed 64-bit integer to
accommodate large buffer sizes correctly.

Fixes: d5652d865ea734a1 ("perf session: Add ability to skip 4GiB or more")
Reported-by: Tamas Zsoldos <tamas.zsoldos@arm.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20250808-perf_fix_big_buffer_size-v1-1-45f45444a9a4@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/session.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 277b2cbd51861..e4d57e7df7ae1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1662,7 +1662,7 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 	struct perf_tool *tool = session->tool;
 	struct perf_sample sample = { .time = 0, };
 	int fd = perf_data__fd(session->data);
-	int err;
+	s64 err;
 
 	if (event->header.type != PERF_RECORD_COMPRESSED ||
 	    tool->compressed == perf_session__process_compressed_event_stub)
-- 
2.51.0



