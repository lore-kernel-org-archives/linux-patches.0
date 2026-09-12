Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3CB430CD8;
	Sat, 12 Sep 2026 15:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227242; cv=none; b=LsCGFtmvcuFx8rs7Mpv40fx7UALFU7A9BP8JrTqkbrnUdMQRBPvlxdwgO4ip7uPVo0q5BdXgQmS3RxMggz6XgVuw2taaJUqIGDUmep0dccuXm1OQwOWRc/YUb/Cr0bJtQIKdzrXvgQ0UmQtxvP8Ae/ni3OuJnssE0KTBqLfnc7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227242; c=relaxed/simple;
	bh=q5ECn7ftThjcs+0x5QC9U3fHmZ2LK0SlIw1R19Ect+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PyXItUuw6ZqdogeVSEnv4yOLS/Xd8i24FJikENsKJFzMv1/dcQg48cEGfYGOy0gStvu9CU1D2XwVmEAsXJb34f/z20q7uvPi62tAoN2kzSZxEogJC7vpHx7xsyZkEYlJMaoP/V2CyBNV6J9oI8v7i9YoR4LS4O5FDhKT99rjbX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhKQP8+N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhKQP8+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08E41F000FF;
	Sat, 12 Sep 2026 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227240;
	bh=epWSp4JRM+IZo6ZcgxJoNKSMGBcz1gi7/XLFuEgrz3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhKQP8+NdbcYcnaKeJQ7Uya4v0liPYdq5CX0LhYSEvdYj0sSOCJKRlcreXu77Kkb8
	 fI1VShO9oEhm2ScIM/BDB6Kz85hn1xH3Bb4fTCZ0KDhr0RV307XoIfnYwnrhIWHBZE
	 Zyx63+i2PWG0Hyy91N2ap2syVxiZY8BBKBgwrzM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunkai Deng <chunkai.deng@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 0139/1191] rpmsg: glink: smem: order FIFO read after availability check
Date: Sat, 12 Sep 2026 08:47:47 +0200
Message-ID: <20260912065551.320282902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -88,6 +88,13 @@ static void glink_smem_rx_peak(struct qc
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


