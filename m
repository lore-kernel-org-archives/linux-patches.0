Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308092D9484;
	Wed, 30 Sep 2026 16:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785660; cv=none; b=jQV7lvsxb0HlmgHjeQOAAVA34aAUtUM2bcF6ycnvODlnH+7PQUech81RL56Mbms0jfj2Vq2JSVk4XlEw6v/SoZQ0T0K1xvlEe+RQ04cmBXMR84DXiAJlnk0kQAGrubHJUzX2wuVOFohtvg/FCqNdClmo6db1xuJZHg3xe9nlG+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785660; c=relaxed/simple;
	bh=SX0ppuzpJ60Ja7kJHRIrSAc/H6egwpu5javpwi2x1UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsBBpyd+wPSdDUDmYtz+G8khSswv1IX5UylgLlUtzazgulqXnnIpUFuGbWPe018hJOnNs/TOXc/kodgzBZWs3CrUtSgtRDOAuS2m4gmhrBXmj7DaKposVf7SulGIxgaXtGgm8fmd8nJdYoigXhSWaXYdCQgbVo2SPXbzuX5OUo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqNwBAM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqNwBAM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653521F00893;
	Wed, 30 Sep 2026 16:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785656;
	bh=+bPmvkX7RWmv5SdAQBStnovU3XIuEiqPvLb+JHyR5TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqNwBAM1LXGtfWWyr/Kn392xUlhteBQ4FB173ydmU/godx0O7qeQGgZ4+vqOhUEy4
	 KZujZ+lYKyaJ6DZZBFXwz5L7a/Hs1j7sl++xWQeeHJuaOkAMNbRtt3d12egkWpaR7I
	 iSGF9exkFXOZRxwnYUCUwFh3z+v/tX+zxcbmJyNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 584/982] Revert "perf cs-etm: Avoid truncating AUX buffer sizes to int"
Date: Wed, 30 Sep 2026 17:22:00 +0200
Message-ID: <20260930152429.324791328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

This reverts commit 9ccb4d7bd325012505d2d5d2456cad199417be57.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 46 +++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 10e9657ee58c1..361b75b0882c4 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1087,7 +1087,8 @@ cs_etm__get_trace(struct cs_etm_queue *etmq)
 	etmq->buf_used = 0;
 	etmq->buf_len = aux_buffer->size;
 	etmq->buf = aux_buffer->data;
-	return 0;
+
+	return etmq->buf_len;
 }
 
 static void cs_etm__set_pid_tid_cpu(struct cs_etm_auxtrace *etm,
@@ -1684,33 +1685,26 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
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



