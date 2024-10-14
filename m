Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACD7487A7;
	Mon, 14 Oct 2024 14:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917959; cv=none; b=emeqZOO9k7tQyM3z4BEoWKZchtBltymY0rL2C559vysulcBzQKQt7yztW0pEDXUfGiZFnSGJpmKBTr8EAt0uIeWTZLAvpJpR/ttjLiI2bSsiQrob3LgiLTOS9Y2TCV1YDmwjbVvpdCXfcZOZE3BPnpkmxn3qnekeNL73fJKxnW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917959; c=relaxed/simple;
	bh=88kSdUsHqg0goiXM0ovYxKr3ydZuMZlXh1D0+nACKS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3SKhSsDk+RJ/p+qhvU2UVfEnE7bmzK7RqZGkW/RLz+RccSghNln+rs+DH6+XKa28N1yOiSfqbB3p6aRT2PwcxONv4qLAepsQiyjuL3Lx/cYfOBVyZRtfP3DZQY5pI/sCz1GN84IWRsN4pVSYiEVOvYL/VFTjtgoUODvwtT73mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHsnAQaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHsnAQaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DCD6C4CEC3;
	Mon, 14 Oct 2024 14:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917958;
	bh=88kSdUsHqg0goiXM0ovYxKr3ydZuMZlXh1D0+nACKS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHsnAQaDubOXtcu/PrV9IUmHx0v9akn0DlD8KAIXznBf/Y7UOjOKLtMV9MGRq0nxF
	 PfCVtamfrip8p2QS3b/EierP5339LpZB7NUeNl5OgNFUb2AO9QOLFP+9hWZINoU/6S
	 OoKyQeFBft5jz4EOoj05kTyv7VGk0JF4JcDIUhn4=
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
Subject: [PATCH 6.1 182/798] perf time-utils: Fix 32-bit nsec parsing
Date: Mon, 14 Oct 2024 16:12:16 +0200
Message-ID: <20241014141225.083842548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3024439216816..1b91ccd4d5234 100644
--- a/tools/perf/util/time-utils.c
+++ b/tools/perf/util/time-utils.c
@@ -20,7 +20,7 @@ int parse_nsec_time(const char *str, u64 *ptime)
 	u64 time_sec, time_nsec;
 	char *end;
 
-	time_sec = strtoul(str, &end, 10);
+	time_sec = strtoull(str, &end, 10);
 	if (*end != '.' && *end != '\0')
 		return -1;
 
@@ -38,7 +38,7 @@ int parse_nsec_time(const char *str, u64 *ptime)
 		for (i = strlen(nsec_buf); i < 9; i++)
 			nsec_buf[i] = '0';
 
-		time_nsec = strtoul(nsec_buf, &end, 10);
+		time_nsec = strtoull(nsec_buf, &end, 10);
 		if (*end != '\0')
 			return -1;
 	} else
-- 
2.43.0



