Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B363370FB;
	Fri, 17 Oct 2025 15:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714923; cv=none; b=jDfMqaektI/ZF4RpkctNWfh9rf7A4gpFDo5690NoWSECkUCoBbfv0RFHrwk0xNKxCY9r0LkZMAERKpTF6WYetmsMRz7HpableSHAwYD+EgBtmJIWMlHgk+lxJdKc6Wv2sQYFgYugiak9cpvgvQyIVOXxIUSwXnWIpw+NvXE/34w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714923; c=relaxed/simple;
	bh=OOSW01oQTh1xfBbsMOffrHLUao5ji+7kMImoRrAUpzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhFfLf51/gU9WKCE5yYWaNCEXWyGuLRey7d+R5IgAKgbfBBFDJkocKbm8eOfPsx4iP9wPqNnGaCNo6PrNKHSLgE4e7T3AaYS2MLY9r/xFoEn9ql97dvhpvnIXZF0xbtT/rblZuz3d8pD36ad67lkLuoqLJi+YtaNHOBRBwJG6ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uljfJdvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uljfJdvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF3DC4CEE7;
	Fri, 17 Oct 2025 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714922;
	bh=OOSW01oQTh1xfBbsMOffrHLUao5ji+7kMImoRrAUpzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uljfJdvGXNu9nwc048DhqnCMeRbTEar3/s+ABhMDtZxXmwhlUpcXa17IaqkLUlef+
	 688FYdgDtuq02rsV+nl4XnlB3FdDLQSCneqd2fxirsbZ61Nj4eRN3Bz2Sr63PlkREM
	 IhI5wTfReVA/5jJuBEZiVMtr2+flevocSHqtRP/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Yunseong Kim <ysk@kzalloc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 036/371] perf util: Fix compression checks returning -1 as bool
Date: Fri, 17 Oct 2025 16:50:11 +0200
Message-ID: <20251017145203.107043422@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunseong Kim <ysk@kzalloc.com>

[ Upstream commit 43fa1141e2c1af79c91aaa4df03e436c415a6fc3 ]

The lzma_is_compressed and gzip_is_compressed functions are declared
to return a "bool" type, but in case of an error (e.g., file open
failure), they incorrectly returned -1.

A bool type is a boolean value that is either true or false.
Returning -1 for a bool return type can lead to unexpected behavior
and may violate strict type-checking in some compilers.

Fix the return value to be false in error cases, ensuring the function
adheres to its declared return type improves for preventing potential
bugs related to type mismatch.

Fixes: 4b57fd44b61beb51 ("perf tools: Add lzma_is_compressed function")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Link: https://lore.kernel.org/r/20250822162506.316844-3-ysk@kzalloc.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/lzma.c | 2 +-
 tools/perf/util/zlib.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/lzma.c b/tools/perf/util/lzma.c
index bbcd2ffcf4bd1..c355757ed3911 100644
--- a/tools/perf/util/lzma.c
+++ b/tools/perf/util/lzma.c
@@ -120,7 +120,7 @@ bool lzma_is_compressed(const char *input)
 	ssize_t rc;
 
 	if (fd < 0)
-		return -1;
+		return false;
 
 	rc = read(fd, buf, sizeof(buf));
 	close(fd);
diff --git a/tools/perf/util/zlib.c b/tools/perf/util/zlib.c
index 78d2297c1b674..1f7c065230599 100644
--- a/tools/perf/util/zlib.c
+++ b/tools/perf/util/zlib.c
@@ -88,7 +88,7 @@ bool gzip_is_compressed(const char *input)
 	ssize_t rc;
 
 	if (fd < 0)
-		return -1;
+		return false;
 
 	rc = read(fd, buf, sizeof(buf));
 	close(fd);
-- 
2.51.0



