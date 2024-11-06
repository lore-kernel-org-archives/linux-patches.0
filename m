Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F71C1DEFF5;
	Wed,  6 Nov 2024 12:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895033; cv=none; b=E0ZxRKtjMmpbH2d8kDWaoq1Y5LiWTjcDbrhpsYON+T6w059svRzS3qCG3yt4Y9jp6AqsWp8DT0WOVaJJ6T+6+TUw/mKChMojXEdcuVCs0d86kBZhoLnJZUwlmqIZivHijAYSfGXVGBvII9sUw+eZAU2FObUPF0ZHVcUloFLPBg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895033; c=relaxed/simple;
	bh=4bI1I/RIXxvGVAEmqFQrTfEr8pQQ3xwbOL8bNXQUngM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2PphnfOB5myVrBhWiU7itrketNQllsIpnRp18XUfR2mdmWgPf3hu5aQ1jlKjwMsNvVaQmO3dFOXi3WKQFMD6WfVgtQzmPG5oik5XZwlFmroJqBuY+F2pBJ8HVakixpaVwMCNJPvWus3pUhP9embYfBx8vK5Qqfj3zpoDvui02E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bn49jSwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bn49jSwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BB3C4CEDE;
	Wed,  6 Nov 2024 12:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895033;
	bh=4bI1I/RIXxvGVAEmqFQrTfEr8pQQ3xwbOL8bNXQUngM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bn49jSwHqETGMa2G77HsQ+QGKo8INcrj6K/Hngm29gAcGkJtWt81/DO2UroWMeayR
	 kw63ET7g/F9X0SAA6es4DmOujuCl0HHWlP70/cZrt8X0SODLxeVrwut+FIMfbiqZTB
	 AGe26hMCv/T3vS8r2sjzhTXIFyrkJwbt/gUQulcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Chaitanya S Prakash <chaitanyas.prakash@arm.com>,
	Colin Ian King <colin.i.king@gmail.com>,
	David Ahern <dsa@cumulusnetworks.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Junhao He <hejunhao3@huawei.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Yang Jihong <yangjihong@bytedance.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/350] perf time-utils: Fix 32-bit nsec parsing
Date: Wed,  6 Nov 2024 13:00:09 +0100
Message-ID: <20241106120322.896738219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 38e2648a81204c9fc5b4c87a8ffce93a6ed91b65 ]

The "time utils" test fails in 32-bit builds:
  ...
  parse_nsec_time("18446744073.709551615")
  Failed. ptime 4294967295709551615 expected 18446744073709551615
  ...

Switch strtoul to strtoull as an unsigned long in 32-bit build isn't
64-bits.

Fixes: c284d669a20d408b ("perf tools: Move parse_nsec_time to time-utils.c")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: David Ahern <dsa@cumulusnetworks.com>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Junhao He <hejunhao3@huawei.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yang Jihong <yangjihong@bytedance.com>
Link: https://lore.kernel.org/r/20240831070415.506194-3-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/time-utils.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/time-utils.c b/tools/perf/util/time-utils.c
index 6193b46050a56..540a71450de52 100644
--- a/tools/perf/util/time-utils.c
+++ b/tools/perf/util/time-utils.c
@@ -17,7 +17,7 @@ int parse_nsec_time(const char *str, u64 *ptime)
 	u64 time_sec, time_nsec;
 	char *end;
 
-	time_sec = strtoul(str, &end, 10);
+	time_sec = strtoull(str, &end, 10);
 	if (*end != '.' && *end != '\0')
 		return -1;
 
@@ -35,7 +35,7 @@ int parse_nsec_time(const char *str, u64 *ptime)
 		for (i = strlen(nsec_buf); i < 9; i++)
 			nsec_buf[i] = '0';
 
-		time_nsec = strtoul(nsec_buf, &end, 10);
+		time_nsec = strtoull(nsec_buf, &end, 10);
 		if (*end != '\0')
 			return -1;
 	} else
-- 
2.43.0



