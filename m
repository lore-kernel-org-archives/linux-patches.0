Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F44E400E07;
	Wed, 20 May 2026 18:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302397; cv=none; b=fbOwR5wcAbDdtkNWjZdERpcMygH7uIrrWvBd/GDbA5N51TVYSk7NrNJLguBqbuNdUV9Vl3Pt2o9xDishaeSNAauyS7x8dvHIzvhgLS2qTBR6IGW5ClMTNS0Mz75jdZQLKhqBY875xZoQs0pTDiopD4tn5QIkXH33pFN+eJ5LRGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302397; c=relaxed/simple;
	bh=KdT8TlWFMzpfFUVSXKWHmPSk2KstfA5P3GtrgT6nDEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZMlVAinuQ5PNssh3eJxZVlk7InDQUjoHi7BWuGjoAe+M+zv6kNbHxSspSJzqU1Bjm235jECitg5KdQEUxie2sAUDdo5VFTmq9yUEWIQG/hfXxXqUOosW4Zj6UlwoOhMv4X82yroeClVWWVeMSs7I5TYkASJrZtySzMS31XctFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhDtg8SR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhDtg8SR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42781F000E9;
	Wed, 20 May 2026 18:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302396;
	bh=1ELeJ6F/vc09FZZT/R5H30On9PFqJEdaNdM20Qpd2IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhDtg8SRy8tiE3RHWys3EYhu7kaEv+HXHV8Eg7m4n2RLJt1j2irpYqPX/1qE7UdA0
	 ETDvNVth6jHbpdNohiZQmY7GrxKA9GioZZ8zwztbo1V9Q2ybOsNssuuNVGzX0Si90y
	 q6sYR7Q6dYkFnhyJMJTznq+QzZ+hDIkpbuyKI/C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mike Leach <mike.leach@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/508] perf: tools: cs-etm: Fix print issue for Coresight debug in ETE/TRBE trace
Date: Wed, 20 May 2026 18:21:12 +0200
Message-ID: <20260520162104.044558587@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index e917985bbbe6d..640e383cef441 100644
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
@@ -755,9 +733,6 @@ cs_etm_decoder__new(int decoders, struct cs_etm_decoder_params *d_params,
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



