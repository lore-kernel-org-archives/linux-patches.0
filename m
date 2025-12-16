Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FC2343D77;
	Tue, 16 Dec 2025 11:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884859; cv=none; b=lmR+QxTOMKy5j0zNFteW97mXOn5ZLN1pQJjEO9LrAiMSbAjtAJbhzdIycogxjcOvDZLpEnq6PSYOrL/7MtME89SyWfuBHh7kWGbUA1wtUGPAR0zO9Pw2eZxL9v+JBM3FrBtI7Eb92qlTuHlQnyoCp9bJiYsm/jEtWRYF6bM7SYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884859; c=relaxed/simple;
	bh=HjTHhYAYBb9XjnuwJrdFpsBc0hIRuPhmmqaXjZh/bbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNf/OZB0dowlQtpwNgpXViqYKIUWERnLFCdpy7xIi9DBDlh5eZnUblRjn3TTnNumrgg9oqWGJO50uKkWD4Kb7OswLNw3GKORF8pS3TIkfvyI5gMZeeCsiIZmhDkPr3P/yzaEOIa4UhmHWTQyWfMMHPomLODoiHB8xJYyCoCSHB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RcQrVVPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RcQrVVPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D2AC4CEF1;
	Tue, 16 Dec 2025 11:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884859;
	bh=HjTHhYAYBb9XjnuwJrdFpsBc0hIRuPhmmqaXjZh/bbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RcQrVVPDoX8pvqDdAD3H2U2u8tJPysRdfOkHZDQA51XaO5X++TVgrF4cFAxlpX3v5
	 iMSoITb6kzCDCrfYSsOT/kikTBjLZC+lwXcQ3wucKzt7xqxjC/0PLN9D5XrHnBcu/G
	 BLy8+3syO+MS9DnJwZb3IHIErlNxD8Obc/z4PhRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 287/354] perf hist: In init, ensure mem_info is put on error paths
Date: Tue, 16 Dec 2025 12:14:14 +0100
Message-ID: <20251216111331.310418575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f60efb4454b24cc944ff3eac164bb9dce9169f71 ]

Rather than exit the internal map_symbols directly, put the mem-info
that does this and also lowers the reference count on the mem-info
itself otherwise the mem-info is being leaked.

Fixes: 56e144fe98260a0f ("perf mem_info: Add and use map_symbol__exit and addr_map_symbol__exit")
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f387e85a00873..694faf405e11c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -528,10 +528,8 @@ static int hist_entry__init(struct hist_entry *he,
 		map_symbol__exit(&he->branch_info->to.ms);
 		zfree(&he->branch_info);
 	}
-	if (he->mem_info) {
-		map_symbol__exit(&mem_info__iaddr(he->mem_info)->ms);
-		map_symbol__exit(&mem_info__daddr(he->mem_info)->ms);
-	}
+	if (he->mem_info)
+		mem_info__zput(he->mem_info);
 err:
 	map_symbol__exit(&he->ms);
 	zfree(&he->stat_acc);
-- 
2.51.0



