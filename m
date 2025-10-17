Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC20337117;
	Fri, 17 Oct 2025 14:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713028; cv=none; b=ehciOrTYrPl4dBzsRTUc6+nVNFiycZ+dCeA2ZUXErpCLgZfacOGlQnM7oiAMhrksuELoOFPNMYDPTFpsxmBt+YnaAfOTkz8ld04GlCSYsTPJmnm3cWNbioQKN9G0ymq4xsgceOo7grRaif2vE4zgvb7fZgczx+ln6As9D69+yXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713028; c=relaxed/simple;
	bh=fRGmflm5x2eZPUL1W4sUMco93sIcB1/g+kcYlL0FJiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/2mYGb6+ZXwe7cGwdhkCUoVDJ0g6rbY/gmf1bSi5JxGzn+XVsoF9eUPSDPnhHBJuDMU7kFFFsBc34grgXuUOM56jAhep+z7viNLr7JzrAzGCNeZktGgGwHp5iNEpDM1N3dO8jZHIRWspCKnovpbsPftY5vb48TcOZdSuE1YXac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZTgU+nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZTgU+nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C6DC4CEE7;
	Fri, 17 Oct 2025 14:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713028;
	bh=fRGmflm5x2eZPUL1W4sUMco93sIcB1/g+kcYlL0FJiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZTgU+nZGjDXGdppfgUXYmjBxytWUs+ZNVaSmezNbRJV2N7yr147NbGvcOE3/OpYp
	 hol/fdioDpbGVQuKH7E3yMGGK82Da5H4ifa9fkhaNkThQ84AJMfXzoh6TWp7LZOrrM
	 bqw86lkxzpyTBNshwtdPaRafVnjc9E2C5O0jsc5o=
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
Subject: [PATCH 6.1 009/168] perf util: Fix compression checks returning -1 as bool
Date: Fri, 17 Oct 2025 16:51:28 +0200
Message-ID: <20251017145129.356867164@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 51424cdc3b682..aa9a0ebc1f937 100644
--- a/tools/perf/util/lzma.c
+++ b/tools/perf/util/lzma.c
@@ -115,7 +115,7 @@ bool lzma_is_compressed(const char *input)
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



