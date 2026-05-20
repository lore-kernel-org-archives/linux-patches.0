Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6641E3A1E72;
	Wed, 20 May 2026 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296003; cv=none; b=ZbCxJynCM9I4W3tc0DATSFTcNZUreK36XuAbXw7TGy+kq1X7k6QfLDAQVhzMgfeW/8KUl2qGGN3LN7PXH7DCMtOwXKlIPL6yFr8wux9DK++CYnwVdXq5sZamevMG1CYk5kTiGZp3cRi/6euMp/ihoM6iVAaiHckUXYDvwMi7Pv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296003; c=relaxed/simple;
	bh=PKfO1+ij1RCuI9xXF48WjbW5Cn55xS5KqmdNbqVCwEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz9Sate18JRtiYXq7ZwgKuqXmNA2A9fJixwSBfGwSq04sZyoUkwWbsXRMS8GBD97KrF11oQO/0yLZVbxtPlKVH150DP7Lp+C3ketvS9I0LrpTmHNL/2WGASvTawB7u3m29vdPjeAh7t239N9aENf/kWUF2AR6m9EqvNOroSIRlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTmS33jR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTmS33jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5964C1F000E9;
	Wed, 20 May 2026 16:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295999;
	bh=3PxJkoJgzmzdwNKERallWjGOVgQJLjVSXrKBna9B1gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTmS33jRrQFA7f5qY9/6wdDJid8pLwtW1PgqFbO5sQG3zwB8Xg1Cc/Hq2cRzq1LW3
	 zhienhHd3C4fcnrlEXvApeiqMRhvkN6cgAtUYGgEJMrTzF+WaX9qnqOCk63BT0iABF
	 9WmyiY6845UOEkXUN55y1q1Y2DvjNB/aqcZuHiUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mike Leach <mike.leach@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0632/1146] perf: tools: cs-etm: Fix print issue for Coresight debug in ETE/TRBE trace
Date: Wed, 20 May 2026 18:14:42 +0200
Message-ID: <20260520162202.487951868@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Leach <mike.leach@arm.com>

[ Upstream commit 6c478e7b3eba3f387a2d6c749e3e3ee0f8ad1c53 ]

Building perf with CORESIGHT=1 and the optional CSTRACE_RAW=1 enables
additional debug printing of raw trace data when using command:-
perf report --dump.

This raw trace prints the CoreSight formatted trace frames, which may be
used to investigate suspected issues with trace quality / corruption /
decode.

These frames are not present in ETE + TRBE trace.
This fix removes the unnecessary call to print these frames.

This fix also rationalises implementation - original code had helper
function that unnecessarily repeated initialisation calls that had
already been made.

Due to an addtional fault with the OpenCSD library, this call when ETE/TRBE
are being decoded will cause a segfault in perf. This fix also prevents
that problem for perf using older (<= 1.8.0 version) OpenCSD libraries.

Fixes: 68ffe3902898 ("perf tools: Add decoder mechanic to support dumping trace data")
Reported-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Mike Leach <mike.leach@arm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../perf/util/cs-etm-decoder/cs-etm-decoder.c | 51 +++++--------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
index 212f17a3dc72d..310af40751103 100644
--- a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
+++ b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
@@ -237,46 +237,24 @@ cs_etm_decoder__init_def_logger_printing(struct cs_etm_decoder_params *d_params,
 					      (void *)decoder,
 					      cs_etm_decoder__print_str_cb);
 	if (ret != 0)
-		ret = -1;
-
-	return 0;
-}
+		return -1;
 
 #ifdef CS_LOG_RAW_FRAMES
-static void
-cs_etm_decoder__init_raw_frame_logging(struct cs_etm_decoder_params *d_params,
-				       struct cs_etm_decoder *decoder)
-{
-	/* Only log these during a --dump operation */
-	if (d_params->operation == CS_ETM_OPERATION_PRINT) {
-		/* set up a library default logger to process the
-		 *  raw frame printer we add later
-		 */
-		ocsd_def_errlog_init(OCSD_ERR_SEV_ERROR, 1);
-
-		/* no stdout / err / file output */
-		ocsd_def_errlog_config_output(C_API_MSGLOGOUT_FLG_NONE, NULL);
-
-		/* set the string CB for the default logger,
-		 * passes strings to perf print logger.
-		 */
-		ocsd_def_errlog_set_strprint_cb(decoder->dcd_tree,
-						(void *)decoder,
-						cs_etm_decoder__print_str_cb);
-
+	/*
+	 * Only log raw frames if --dump operation and hardware is actually
+	 * generating formatted CoreSight trace frames
+	 */
+	if ((d_params->operation == CS_ETM_OPERATION_PRINT) &&
+	    (d_params->formatted == true)) {
 		/* use the built in library printer for the raw frames */
-		ocsd_dt_set_raw_frame_printer(decoder->dcd_tree,
-					      CS_RAW_DEBUG_FLAGS);
+		ret = ocsd_dt_set_raw_frame_printer(decoder->dcd_tree,
+						    CS_RAW_DEBUG_FLAGS);
+		if (ret != 0)
+			return -1;
 	}
-}
-#else
-static void
-cs_etm_decoder__init_raw_frame_logging(
-		struct cs_etm_decoder_params *d_params __maybe_unused,
-		struct cs_etm_decoder *decoder __maybe_unused)
-{
-}
 #endif
+	return 0;
+}
 
 static ocsd_datapath_resp_t
 cs_etm_decoder__do_soft_timestamp(struct cs_etm_queue *etmq,
@@ -738,9 +716,6 @@ cs_etm_decoder__new(int decoders, struct cs_etm_decoder_params *d_params,
 	if (ret != 0)
 		goto err_free_decoder;
 
-	/* init raw frame logging if required */
-	cs_etm_decoder__init_raw_frame_logging(d_params, decoder);
-
 	for (i = 0; i < decoders; i++) {
 		ret = cs_etm_decoder__create_etm_decoder(d_params,
 							 &t_params[i],
-- 
2.53.0



