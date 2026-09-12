Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F411E5B9F;
	Sat, 12 Sep 2026 07:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199656; cv=none; b=tETc8s6ycj8Zmpm0Ml8AnqZWuVBolOXkEVMC+Gmv2q3wifMSTSyazIdSPzwPDLvsqjFzJijR91YkjUAwgdiTgf+ZUkRlkUSbUhmI5YnNxx9+vGkte94nwwGQnwVi/dZljei4e697W6KS6JRpLO4mvPV3PRNVuLCM24132UxQgDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199656; c=relaxed/simple;
	bh=OVaMNtlkcrJR/qILntg42KpV1uzXESBzxYSf2Nz6q/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilm8OdPnSq5uKSawgVbXGZq6ABuixe8uoqdmlPeUo+GcrBeW8YxXvX8U7Qdx8+uMUix4HClkEw4L13re6sXMarSs9A1ZzXFx6KrFhTRRjAdN12gHBpoRtFLHwH+YssBtE2BxbcBxA6g9tYS2ttYvWbK+Wyy+xiVDi2y99MZAI9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJ4OPjhX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJ4OPjhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6441F000FF;
	Sat, 12 Sep 2026 07:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199654;
	bh=LbS/0iQH1nexSBCEEI5M4UE3vUqNx+f7KNEYDqbQCPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJ4OPjhX1crZNu7EDlLjvpBWfWR22tbyzT1RgHwjG76gUuqNRIEmZ1kVz64Neoy4U
	 B7ywu1VSDMfd48OWz+NoB+hVzD/c9ePgaivF6O1eGhiWuliPXhTQfmV/zdcTG6BKxy
	 NlTYwrSQ5vewsq3RWRRYpzN8XwNlkdYm2y6KD0o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suyash Mahar <smahar@meta.com>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0628/1815] perf cs-etm: Avoid truncating AUX buffer sizes to int
Date: Sat, 12 Sep 2026 08:39:38 +0200
Message-ID: <20260912065703.622192919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit ec99be8a31db999a4f866be74ea7db61dbb19f24 ]

cs_etm__get_trace() returns an int, but it used to return etmq->buf_len
on success. That value comes from auxtrace_buffer::size, which is a
size_t. For a large AUX trace block, returning the byte count through an
int can overflow and make a valid buffer look like a negative error.

The callers do not need the actual byte count from cs_etm__get_trace().
The buffer length is already stored in the etmq->buf_len. The callers
only need to distinguish three states:

  < 0: error
  = 0: no more AUX buffers
  > 0: data is available

Make cs_etm__get_trace() return 0 for all non-error cases and use
etmq->buf_len to indicate whether a new buffer was found. Then make
cs_etm__get_data_block() return 1 whenever data is available, instead of
returning the buffer length.

Also refactor cs_etm__get_data_block() to make its return value
semantics clearer.

Reported-by: Suyash Mahar <smahar@meta.com>
Fixes: 8224531cf5a1 ("perf cs-etm: Modularize auxtrace_buffer fetch function")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 46 +++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 54b82cf6442a7..fc3d4ebd1fbae 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1528,8 +1528,7 @@ cs_etm__get_trace(struct cs_etm_queue *etmq)
 	etmq->buf_used = 0;
 	etmq->buf_len = aux_buffer->size;
 	etmq->buf = aux_buffer->data;
-
-	return etmq->buf_len;
+	return 0;
 }
 
 /*
@@ -2139,26 +2138,33 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
 {
 	int ret;
 
-	if (!etmq->buf_len) {
-		ret = cs_etm__get_trace(etmq);
-		if (ret <= 0)
-			return ret;
-		/*
-		 * We cannot assume consecutive blocks in the data file
-		 * are contiguous, reset the decoder to force re-sync.
-		 */
-		ret = cs_etm_decoder__reset(etmq->decoder);
-		if (ret)
-			return ret;
+	/* The current block is not finished */
+	if (etmq->buf_len)
+		return 1;
 
-		/*
-		 * Since the decoder is reset, this causes a global trace
-		 * discontinuity. Flush all thread stacks.
-		 */
-		cs_etm__flush_all_stack(etmq);
-	}
+	ret = cs_etm__get_trace(etmq);
+	if (ret < 0)
+		return ret;
+
+	/* No more buffer to read */
+	if (!etmq->buf_len)
+		return 0;
+
+	/*
+	 * We cannot assume consecutive blocks in the data file
+	 * are contiguous, reset the decoder to force re-sync.
+	 */
+	ret = cs_etm_decoder__reset(etmq->decoder);
+	if (ret)
+		return ret;
+
+	/*
+	 * Since the decoder is reset, this causes a global trace
+	 * discontinuity. Flush all thread stacks.
+	 */
+	cs_etm__flush_all_stack(etmq);
 
-	return etmq->buf_len;
+	return 1;
 }
 
 static bool cs_etm__is_svc_instr(struct cs_etm_queue *etmq,
-- 
2.53.0



