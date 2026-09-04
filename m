Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C655D3876CC;
	Fri,  4 Sep 2026 05:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501269; cv=none; b=dqK+oI7N6ZSkM7zgkJRg4QpKBqK0DKorcR8KDiopkhkgY2HUIIWxH8Nq54Gcd6Ya1XRoPru3t3ztkxvzkRZuAcZFPUeWBN1l6KPnilKfpIZpnkUaLFp3/yH/ND1XEHqKC5qdlSN7aYTdjgp3KbW7eyQPqY/s7ZWEWoVO97EnP1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501269; c=relaxed/simple;
	bh=EyRI5+sSB3IqZCtDikOvfza8OlPze0lwXanBbJAgQew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqN+s9FWi5DyL1LW1uYLJP+z3Zros5NLc3aKLd6TbvGu4kWJsmHxnJoIpsUEHNcIml63fDPLv9CB6oOevCbwrUNGJcv4WJNRLQlZoQDJCG8sARPsPN9Khj+kDZTOZbLumg43k2Xw0Gw9o/jL3jHoj5TkHtNdeYbwTi/rT+Aum00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lcra6wDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lcra6wDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9A91F00A3D;
	Fri,  4 Sep 2026 05:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501268;
	bh=w60z+7J2EkO5gbw1rklXWLJULQAooSi5+U0113Z6UlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lcra6wDnNLO3LlkSVmx0LPoe+tRNTOdALnFTwi0cdoCBKcljYTtaGXtgLJhQEsmzG
	 4AUJNIBsHZw53+dx35SZXPAMg6LD2HgCUIR13GyO/XsYzD8wgEyvFmiX0K1BCth5QU
	 ysucsms7liDhAg8rE1vvD1fKiolyHw1iDxzjeRUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunkai Deng <chunkai.deng@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 307/552] rpmsg: glink: smem: order FIFO read after availability check
Date: Fri,  4 Sep 2026 06:57:44 +0200
Message-ID: <20260904045757.241989843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


