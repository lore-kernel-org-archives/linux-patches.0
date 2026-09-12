Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE21632B126;
	Sat, 12 Sep 2026 18:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239071; cv=none; b=k0LSMFGWP1o7bNgXNTP7MsWQPtgn4nWEHe8zY+57JlXDJBbYH/dK/3WIkzV2je+30js8A/PQGSpkTxrDTB+RnjDRDhEEeJsJb8toP8zedms+nbCpvVJ9LEK8GgOzWrgnkR6irFRQ9ifilVjmbDASc3uUTj5xdqB9xBtM5/S/gs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239071; c=relaxed/simple;
	bh=V5RWlIgMn8fKHKAhQR11tumGML1fWQpI/TxKKwjO5E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADd9CUpm6IKtw9+EKxQDRgITMkstlA53Rhwwe4amtrrSp3f5j96ExEZouXm2ruDhyAHUEkM4L5JiFRn/bBVd9N5YTX6QZ3YaafZLOXaMqThqD0bLUBw5DDOVg1VsCH/2csJ0XT6jb83Ek9QFhVZnKqQgxYbR6QVMBHENWtrX4kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjNu5qy1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjNu5qy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58FE1F000FF;
	Sat, 12 Sep 2026 18:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239070;
	bh=VSroVwEFlepw7tyW6hlaLe9DXqzMC4uqr/BnvJrA8z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjNu5qy1oQIQXOZj+sBpfVYWVGjQgMNTkmTk3A+zea98bbsGDRgA41ldx0hBcQkjc
	 MjNziuij1vANSxop90YoZ/bzqazbqMDUIZ+NyUkxDsHNbWqo8KJht1MtJ3psyh2MIf
	 npX85b1tGYk5O+39tXZbT34CoqZjDL5V93rtcXxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suyash Mahar <smahar@meta.com>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 591/935] perf cs-etm: Avoid truncating AUX buffer sizes to int
Date: Sat, 12 Sep 2026 09:00:21 +0200
Message-ID: <20260912065540.395892172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
index be5a2e2d226d8..20492e58792d6 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -1089,8 +1089,7 @@ cs_etm__get_trace(struct cs_etm_queue *etmq)
 	etmq->buf_used = 0;
 	etmq->buf_len = aux_buffer->size;
 	etmq->buf = aux_buffer->data;
-
-	return etmq->buf_len;
+	return 0;
 }
 
 static void cs_etm__set_pid_tid_cpu(struct cs_etm_auxtrace *etm,
@@ -1687,26 +1686,33 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
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
 
 static bool cs_etm__is_svc_instr(struct cs_etm_queue *etmq, u8 trace_chan_id,
-- 
2.53.0



