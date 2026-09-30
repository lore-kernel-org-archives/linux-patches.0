Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413B74C10D4;
	Wed, 30 Sep 2026 15:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783280; cv=none; b=e/OPgNH9+sW7jDz5a1k2360cw3fnfPwSPrFRyVHzzmyDvWc1yrXg1oewPKUF/3wp1iiBsW9onUlKcpmv8fPTBW8pZduS7Ood0KbEuv+j451luORzSd+mazQpwstVYPT7W9daNjtszrL25oQPL8pOKVr1cG7RqizLtc0fiHqGMp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783280; c=relaxed/simple;
	bh=MugvqLB32SVlxGB1pbcEq1MD8SA+DwzGnbqoN5zCXd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaLGClZ9xOynJhgQaYjBcrbDsruUcXMyF/HruTNCDpcV+UVhLzI13ydfmoPubZgw8TL5XUcodZQ4M9/otjr8rWzIQSISQPlpMahCeUNaRY2UNMvJ3iYm+Un9iK7suLX+dbPJTI5seP8tOJbglYwFKemfR+R1VW15iVwa+Tmkb7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwBy95gO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwBy95gO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603531F00898;
	Wed, 30 Sep 2026 15:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783273;
	bh=MHNICkkx5hj1C1JSrcu9KTS2bub/Bl+wJcfsdw0AZDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwBy95gOpdzo+1HzqfMz9BI3xGpZfevLnpYA7zEct6ffGFOPqwk7J3RHKmgUYYegQ
	 DswN4qt8peI+ProsUxjBSnKa0hErqQp8pOfdbTFyAqmm3xSfIrshjcRnpb5FRGxShx
	 9tAhcdKQswngahfGU3zCDufe8YQ+3o76Cu4YCPUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 340/595] Revert "perf cs-etm: Avoid truncating AUX buffer sizes to int"
Date: Wed, 30 Sep 2026 17:23:53 +0200
Message-ID: <20260930152354.991658508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 23893444447675e4e0701e24eb31163c8540438d.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 46 +++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 9a6e8db74c5f6..9b38eedabc9fc 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1065,7 +1065,8 @@ cs_etm__get_trace(struct cs_etm_queue *etmq)
 	etmq->buf_used = 0;
 	etmq->buf_len = aux_buffer->size;
 	etmq->buf = aux_buffer->data;
-	return 0;
+
+	return etmq->buf_len;
 }
 
 static void cs_etm__set_pid_tid_cpu(struct cs_etm_auxtrace *etm,
@@ -1658,33 +1659,26 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
 {
 	int ret;
 
-	/* The current block is not finished */
-	if (etmq->buf_len)
-		return 1;
-
-	ret = cs_etm__get_trace(etmq);
-	if (ret < 0)
-		return ret;
-
-	/* No more buffer to read */
-	if (!etmq->buf_len)
-		return 0;
-
-	/*
-	 * We cannot assume consecutive blocks in the data file
-	 * are contiguous, reset the decoder to force re-sync.
-	 */
-	ret = cs_etm_decoder__reset(etmq->decoder);
-	if (ret)
-		return ret;
+	if (!etmq->buf_len) {
+		ret = cs_etm__get_trace(etmq);
+		if (ret <= 0)
+			return ret;
+		/*
+		 * We cannot assume consecutive blocks in the data file
+		 * are contiguous, reset the decoder to force re-sync.
+		 */
+		ret = cs_etm_decoder__reset(etmq->decoder);
+		if (ret)
+			return ret;
 
-	/*
-	 * Since the decoder is reset, this causes a global trace
-	 * discontinuity. Flush all thread stacks.
-	 */
-	cs_etm__flush_all_stack(etmq);
+		/*
+		 * Since the decoder is reset, this causes a global trace
+		 * discontinuity. Flush all thread stacks.
+		 */
+		cs_etm__flush_all_stack(etmq);
+	}
 
-	return 1;
+	return etmq->buf_len;
 }
 
 static bool cs_etm__is_svc_instr(struct cs_etm_queue *etmq, u8 trace_chan_id,
-- 
2.53.0



