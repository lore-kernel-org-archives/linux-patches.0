Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B6A330B00;
	Fri, 17 Oct 2025 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716279; cv=none; b=r4dfcBD6bh8JnajnuuoPZyv8K+dUab6/b1cse5Rqo9mrtnJSp/m9W7ch1NVEH+Q+mNDWLDX8eTJ4DnxLH1KgNQforIOlaHIm+fqbExjdXB5O3K8KMKbFvqBrrBSTJMbefxbNOs1KQwGn5tWtpYK3jsj3Rt+snZB6B4YqIHSBkl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716279; c=relaxed/simple;
	bh=JwaJnOjz3YB1d8pKMSM+xskGH2su/2jIQp8tnyOvctg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mhtforYiw/36mEoSIXCVKkHKYdQl3o1VO6shd5fwvhyKt+kt6nbz4bqL/vNLH9juaGxV/WYfNgugcrqHZUYs0IM5FgJHponcR2E2TBDgUrtlkKQV6qoH8yhKAFZpZeqqiKtikYlO8g8QQLVpn+yKxAqJVSyUub+kgvPoGETQT3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E58bbQ7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E58bbQ7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5A8C4CEE7;
	Fri, 17 Oct 2025 15:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716278;
	bh=JwaJnOjz3YB1d8pKMSM+xskGH2su/2jIQp8tnyOvctg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E58bbQ7YhtkcXvZlJnYAyUBW0fY59liOjloLgoMLZno5MmCK7HWN1S8aEQwoSj9P9
	 w3MAa/xZiMyQLnwDEoavY54Ze5tkNCo5SqRPQNVy2cSjIWm5cBzO5mO5gJ4QWGBS/m
	 xtUWTTSsw0acjrFoHW7zu9GuF5tUPFxw4B9CkD6s=
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
Subject: [PATCH 5.15 135/276] perf session: Fix handling when buffer exceeds 2 GiB
Date: Fri, 17 Oct 2025 16:53:48 +0200
Message-ID: <20251017145147.410584255@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 562e9b8080272..0ecfda9d9f8b4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1598,7 +1598,7 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 	struct perf_tool *tool = session->tool;
 	struct perf_sample sample = { .time = 0, };
 	int fd = perf_data__fd(session->data);
-	int err;
+	s64 err;
 
 	if (event->header.type != PERF_RECORD_COMPRESSED ||
 	    tool->compressed == perf_session__process_compressed_event_stub)
-- 
2.51.0



