Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C8D299A94;
	Tue, 26 Aug 2025 14:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218072; cv=none; b=FUpcSMsh94QBdiBZd259nUwjEbpGoL2uRym1Ih5PZs47vhsUwWgTu7Nx6yzjLJIA2rpNtGJVgCzts6sj6C3fCZr939KKWzd+hIWkZ+KCODO5kooHqpyUvIEUZVmBe1+B4CL8LATwTO49C7xzPsUUEef75l7ZBYOF7H1PCyaYFfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218072; c=relaxed/simple;
	bh=VD/IV/8ZNlwSoKr8CnBOLrGveHshnpsoNQM7ZYfqfyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBtGf4EosSR4tWvLciDJ9H0QtSFDpa4bbTdmYZscqd9tmpFpXwQas23fwLWN49eMkXaBwZagmmmyze6L2WCGYtLapx11s0XyaAi570IRqAjqVlRmsDkt2N6ChRA4PKDXtAH0qGeWe2McVl3WDpWh2whQLJB0os1PmlpU2jh6GYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXw9z+Oa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXw9z+Oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67DEC4CEF1;
	Tue, 26 Aug 2025 14:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218072;
	bh=VD/IV/8ZNlwSoKr8CnBOLrGveHshnpsoNQM7ZYfqfyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXw9z+OaCbRxMrKMa1ORDMYGQGkYH3nGMdWyPU1QMg2lpYWKm6YHi8y45CQ+0heH3
	 1BemkDene7+mxKD9L9VfS/HOYTY0/2BpQWn9Pq9wfakJpAt8C9hd2epdOp5J3hRuZe
	 d5DZ721dJ6XqXHaYYLxjXQJfumoNr145ICIvNmpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vedang Nagar <quic_vnagar@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 383/523] media: venus: Add a check for packet size after reading from shared memory
Date: Tue, 26 Aug 2025 13:09:53 +0200
Message-ID: <20250826110933.909746869@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vedang Nagar <quic_vnagar@quicinc.com>

commit 49befc830daa743e051a65468c05c2ff9e8580e6 upstream.

Add a check to ensure that the packet size does not exceed the number of
available words after reading the packet header from shared memory. This
ensures that the size provided by the firmware is safe to process and
prevent potential out-of-bounds memory access.

Fixes: d96d3f30c0f2 ("[media] media: venus: hfi: add Venus HFI files")
Cc: stable@vger.kernel.org
Signed-off-by: Vedang Nagar <quic_vnagar@quicinc.com>
Co-developed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -240,6 +240,7 @@ static int venus_write_queue(struct venu
 static int venus_read_queue(struct venus_hfi_device *hdev,
 			    struct iface_queue *queue, void *pkt, u32 *tx_req)
 {
+	struct hfi_pkt_hdr *pkt_hdr = NULL;
 	struct hfi_queue_header *qhdr;
 	u32 dwords, new_rd_idx;
 	u32 rd_idx, wr_idx, type, qsize;
@@ -305,6 +306,9 @@ static int venus_read_queue(struct venus
 			memcpy(pkt, rd_ptr, len);
 			memcpy(pkt + len, queue->qmem.kva, new_rd_idx << 2);
 		}
+		pkt_hdr = (struct hfi_pkt_hdr *)(pkt);
+		if ((pkt_hdr->size >> 2) != dwords)
+			return -EINVAL;
 	} else {
 		/* bad packet received, dropping */
 		new_rd_idx = qhdr->write_idx;


