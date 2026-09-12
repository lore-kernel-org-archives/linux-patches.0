Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E2F369D7C;
	Sat, 12 Sep 2026 19:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241470; cv=none; b=LmamdDyQQ3QkttXfeCBrSTOvdhqC3CJTj0ICGYyUXVc3aMvgXCuBRbUDLnPuuEjYbxvo2Gld8zP3C8MKFwp2jj9LdWu0KTwWCYybahsM4Dw5QcIxsZvJ90j0HqX2VngOz7/LNxDaDrHHFT8e9RuK3HYJ+LGGSyKFx64xL/MUsJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241470; c=relaxed/simple;
	bh=p8MIG2qfvRRMNP3Nz5Nb2+vaRgaB5cbe+ZwNNoQ4SVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlRWtXoOALK+IVkX5HkVbKx9OOcv7ZsrveCk8dG6JvQ0UAetHMLt4JX6RkeoolI25wbQJBljwnG6HjjBbYMz+MGulMnYKb2zA6YtMhz46SjUA1pq8wcP6vQG6NBYs27UX04K07R/9qLS4dPBsimLMYV0iDutfxNl9sgqcKaoBgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ap2a98mZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ap2a98mZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEC51F000FF;
	Sat, 12 Sep 2026 19:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241468;
	bh=NEL3vXnOzMPhL4hxH2yJjVdAgORP8I/5VJvFEBuU8kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ap2a98mZYhMresX+8DS+tyfjbySjKwJur8DFAOEndAgNdY/31cniFyfmVINvcqK00
	 p66KsE5z5dT1eGkXBpE0YhQcFqX/9AxV5Tlizi8FnjnPdncYwVGFw0e+hFbKF3ota8
	 x3Z6/fxH+ST3tL1hXvGlg7id7zBJsJTUmvPHdz+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunkai Deng <chunkai.deng@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 105/798] rpmsg: glink: smem: order FIFO read after availability check
Date: Sat, 12 Sep 2026 08:55:33 +0200
Message-ID: <20260912065519.368354026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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


