Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF002F12CF;
	Fri, 17 Oct 2025 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713554; cv=none; b=Vkoy5Sl8k+d5I7bov7Kq0QMU3pqlTTL6fFFIDIwYz1BATAPlqO0AUULIJ0WqbThQyw9AS7iDnJUTMpz4o+k7SBpj1v4jCSDrR9HdIYJ3iV198gwOoDRWidOnwrBdmLSs5P8Ju9JnoIDWCbUd+upPD8qdCy9XGLnljfWalEb47yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713554; c=relaxed/simple;
	bh=tLa+yd5rfnCjrcDVjtqz1NpRStbSaFdCSnIWpzmyJIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9q/Xln7U/pKoEFR1OE+FhbDuvIx4SofbUNq64SkKLH8xY2PMELshCcfVeXe6TILl1+XxjdcjPEEUoQ8wCWikCU3hRDeZhUG3e9cIzWD9HhfA7mWZiWUavKrd5mjGX26NQ9w+sSS6TyXUrLzk12iwcnW4eGpwCyCj39vnwvLcMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLWRfsVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLWRfsVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741ECC4CEE7;
	Fri, 17 Oct 2025 15:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713554;
	bh=tLa+yd5rfnCjrcDVjtqz1NpRStbSaFdCSnIWpzmyJIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLWRfsVm2fILKgj4/AuaZA+cjRjWD98p2yef5EJqR8Rw6ULYEy6+lIF2M8alw2DU2
	 PBaDs5dcDLFdGIaSgEn/MasdktqKvuLfaZ1j83HFsNP8Hlqbhc9M1LW8lCZ4PLL9u/
	 X+l7oXUmwvZHTLwhZIGRhHPQYwZbdIC5RoxyDKUg=
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
Subject: [PATCH 6.6 010/201] perf util: Fix compression checks returning -1 as bool
Date: Fri, 17 Oct 2025 16:51:11 +0200
Message-ID: <20251017145135.110100365@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index af9a97612f9df..f61574d1581e3 100644
--- a/tools/perf/util/lzma.c
+++ b/tools/perf/util/lzma.c
@@ -113,7 +113,7 @@ bool lzma_is_compressed(const char *input)
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



