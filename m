Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDFA21C9EA;
	Fri, 17 Oct 2025 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713134; cv=none; b=jjDi/EAtw3xt4x6Q+ogSrpkgDBhQZgNQ3IeQ3R4rWT4FoEG61FbKwjBFrrGxbffRL/fyuOUc3lWD/Fqiksu/sM7Mfs2aWU0tOgRoShYBkaeK5ODyqpfNZgX9Tiewp0tf0aj8M+QSsAWC3se5VmlMJUEAVMLYqTonr8QGX+7U7Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713134; c=relaxed/simple;
	bh=0s6657QeaQuP0ls9llG7qaJMiD9EoS+RAnoFHtkQDrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nwdZBgM1l6RXgyhGiPx8pl/7+O73irGOMg1iWmj23/DmPRbi132vG8REz7+YDv6YEceVUZLqKEJzGmmhvq/7GQuTFPGATzHt9Qvg9JN01+A3IWQTu/R/lTM4gw0S6z1yDc0NC51dQnbGGCTYPhKJvKLYKddWeMAymavF5yAPAZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSoMzOa/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSoMzOa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA525C4CEE7;
	Fri, 17 Oct 2025 14:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713134;
	bh=0s6657QeaQuP0ls9llG7qaJMiD9EoS+RAnoFHtkQDrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSoMzOa/7BEUP8Q8hCXD3djfg9IGoUxYWco3W7j5xwiKyTB/NnYk1nWh3U2sLosr5
	 /EXjMIdbJANEtTmvb25Qe9nN8cqJTqXIuo+WwSjWRp2hdJjlvjuwZXEzScTLHlH+li
	 AHnSNDXgWqbOARwsw+EJK37vL58U3nk6Fo8dKzB4=
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
Subject: [PATCH 6.1 016/168] perf session: Fix handling when buffer exceeds 2 GiB
Date: Fri, 17 Oct 2025 16:51:35 +0200
Message-ID: <20251017145129.614633589@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c8f7634f9846c..1c4d124b10531 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1658,7 +1658,7 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 	struct perf_tool *tool = session->tool;
 	struct perf_sample sample = { .time = 0, };
 	int fd = perf_data__fd(session->data);
-	int err;
+	s64 err;
 
 	if (event->header.type != PERF_RECORD_COMPRESSED ||
 	    tool->compressed == perf_session__process_compressed_event_stub)
-- 
2.51.0



