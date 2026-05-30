Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933B4263F44;
	Sat, 30 May 2026 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161466; cv=none; b=nEsRAr1lkBmkplSrcsxKWDQ6oLEJwjzbbxPPe/XSQIZokzpY5+XIy/erEF9d4ujiWKDvF3S76HLWbB2n5tWBUdMXTVd8jIWi8Bi8/Bw1Py4oTEbNiKF52tl804RqIcEb2PldRnhS8Q3TluuoR3LBA+JjCy8khz5cy6L0dYcgIro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161466; c=relaxed/simple;
	bh=eMpz5qf7mQvDutMG++WC/XuplFSNZJPYnPUp4kkeNSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfwSfpubAB34WMbU5twa8oY7IUZaUWsXE+VZpaShwEpaoT/6yHVbKJVUdIyXgHSLy4VaY0JGFkflcrrFheVx1FE2/Slj0PMzguZA4XK8qwVF3+3kqsGiBuhI6r2d4aVdwyjRVljAXrPueXZRQf6fyVVAOy9yrNWa22ZTezhpckw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NivX9TE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NivX9TE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A82E1F00893;
	Sat, 30 May 2026 17:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161465;
	bh=8BGWcsn3eVJm9TuwuP8zNLee8hToGQdY41+2fEEe3Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NivX9TE0xdIb8ms8RsxV2yPbuwjZhBH5/FdUi84bIG9Xp7PHhDtyF2hdjBMc02q3a
	 wqLVr8QXmWmrFgyQWzeFEe/pDh5NYfMt2r5ItPyXO3ExKTOWH+x3ku0HKtUcDFZ7Uy
	 cUnlwFs7bklQRG7x34FwZXtSQ1K8pXuirG43zcqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mike Leach <mike.leach@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 630/969] perf: tools: cs-etm: Fix print issue for Coresight debug in ETE/TRBE trace
Date: Sat, 30 May 2026 18:02:34 +0200
Message-ID: <20260530160317.847300523@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 31fa3b45134a2..fc74a95a23faf 100644
--- a/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
+++ b/tools/perf/util/cs-etm-decoder/cs-etm-decoder.c
@@ -214,46 +214,24 @@ cs_etm_decoder__init_def_logger_printing(struct cs_etm_decoder_params *d_params,
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
@@ -716,9 +694,6 @@ cs_etm_decoder__new(int decoders, struct cs_etm_decoder_params *d_params,
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



