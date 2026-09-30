Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1E43B3BE1;
	Wed, 30 Sep 2026 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791804; cv=none; b=AnWTdKzt522SVXFdwHklZTX7lmx7dU+wC60EmZaQBCeqxYBf089Hi9y6KXMaN9p2XOPhxOfK4fsbGmkxU8aXUoVtXtlIoViElK4TmzmXihz70OYlq99I1Sew3TCIkiBJW4DGkUos/mLSQh3/iLL6YingeVqB9BKzG0QExcFBmo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791804; c=relaxed/simple;
	bh=iA+rVjgtJ5zkaiDyLBT1m/3K0b4fK94dkQHSPvLJBBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzXVdJrEcgcf3VvwNSrsBqu9RiPQRYFAqruzFdHXBM4uklA9De8YmpMJwJ34moLvyhte0WA4/uTR+Jk0cBHqD8FsdDe7biThOw7tvdfQ7rF/v4Z6h7WGdgEU3GbS7e+dbLbQ9zN8GSswIWaIISwTukiy76Oxzz/mT8gmIAzIBVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvQDWnuJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvQDWnuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877B71F00898;
	Wed, 30 Sep 2026 18:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791803;
	bh=om3Sd6nZ4JGL4E0ismqMXRdEu+7kpxEHr1PejFnoUks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvQDWnuJ8Zexj0j+txbUCNcscUtoxBZGeQ9CIKrqmObU0X0Mx39VyoVeRwEZmDCQj
	 CL2iSMJIuB7sDDfDkKWn3oBOP0uXuaNXXiSaso9TkvAvwwtgaVdHG6tr8Xh/LiShZj
	 nrIYWzz/njhBBGC3PlWJladFR/+3SB6qYx2rG7Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/752] Revert "perf cs-etm: Avoid truncating AUX buffer sizes to int"
Date: Wed, 30 Sep 2026 17:25:02 +0200
Message-ID: <20260930152407.633124657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit df034692b739f56c3b7d49687816f0c6b8e70113.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 46 +++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 20492e58792d6..be5a2e2d226d8 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1089,7 +1089,8 @@ cs_etm__get_trace(struct cs_etm_queue *etmq)
 	etmq->buf_used = 0;
 	etmq->buf_len = aux_buffer->size;
 	etmq->buf = aux_buffer->data;
-	return 0;
+
+	return etmq->buf_len;
 }
 
 static void cs_etm__set_pid_tid_cpu(struct cs_etm_auxtrace *etm,
@@ -1686,33 +1687,26 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
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



