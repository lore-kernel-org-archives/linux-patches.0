Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BAF4156F0;
	Fri,  4 Sep 2026 05:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499449; cv=none; b=Q6rrdykgaF8rJ7b8cEpIq2MJScbjkatpYAYMvKlFa8E7EutmGhscX/HToLeVrnqTnNGLMzC38R0GAkBZNUK06bDesm4ceT7N/4FlXx7UbrbXFEGyzdkbS/HwNuX91XTDw5u9C88I/q0AT5FH2H2lcrZwsd01YmNfBE3EfHP1oF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499449; c=relaxed/simple;
	bh=Vvt9UTblVk6Vq6ahyg03Mq/RndRxMunF3yDeebC4pQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qg0/8ZfT5gRwUhYoFLTzi2PHDACFD4Z8kVpSUOLSVkZxTOI5xg5t1vv8/4KngC8RlimmLJH+1dIilg5f4q5uYCoPyrL6AioJX1PDKTYEkW8HwJx2cHoeNYMc47BPqBvhNBJ03jOOmdh0hVqrJmpPUGFH0b2sVup9A7UY62Pmgps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHSCTed3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHSCTed3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0401F00A3F;
	Fri,  4 Sep 2026 05:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499448;
	bh=RU8mCNLrmZFiCZvxkyA9QmuPgbKZNb6I8+DPYEY8L7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHSCTed3OLbRLzIGiy8sGI6jTJUJr04p4S/rZTyIMOphhD209Nu688kdrgjFmu/ED
	 krMCXI0aYcdf8En6oV1or4d8povbv4Ckhku7D5p9NovRNCstC37v1NLuQvqwMDuDHj
	 4JP+WK/fgbMSQbiEYE4rhndLaYKi9dCPqSrf9/x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunkai Deng <chunkai.deng@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 7.2 421/713] rpmsg: glink: smem: order FIFO read after availability check
Date: Fri,  4 Sep 2026 06:56:29 +0200
Message-ID: <20260904045813.267500873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Chunkai Deng <chunkai.deng@oss.qualcomm.com>

commit 786439ad58763e04b91bc2ec5f590e463939f197 upstream.

glink_smem_rx_peek() reads the RX FIFO payload after the caller has
determined data is available via glink_smem_rx_avail(), which reads the
remote-updated head index. A control dependency between the head read
and the subsequent payload read does not order the two loads, so the
CPU may speculatively read the FIFO before observing the head update
and consume stale data the remote has not yet published.

Add rmb() in glink_smem_rx_peek() before the memcpy_fromio() so the
availability (head) read is ordered ahead of the FIFO payload read,
matching the consumer pattern in
Documentation/core-api/circular-buffers.rst.

Fixes: caf989c350e8 ("rpmsg: glink: Introduce glink smem based transport")
Cc: stable@vger.kernel.org
Signed-off-by: Chunkai Deng <chunkai.deng@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260618-rpmsg-glink-smem-mb-v1-1-68a026453a69@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/qcom_glink_smem.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/rpmsg/qcom_glink_smem.c
+++ b/drivers/rpmsg/qcom_glink_smem.c
@@ -103,6 +103,13 @@ static void glink_smem_rx_peek(struct qc
 	if (tail >= pipe->native.length)
 		tail -= pipe->native.length;
 
+	/*
+	 * Order the availability (head) read in glink_smem_rx_avail()
+	 * against the FIFO payload read below, so APPS never consumes
+	 * stale data the remote has not yet published.
+	 */
+	rmb();
+
 	len = min_t(size_t, count, pipe->native.length - tail);
 	if (len)
 		memcpy_fromio(data, pipe->fifo + tail, len);


