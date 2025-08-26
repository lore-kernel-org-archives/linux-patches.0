Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C854A2FDC5C;
	Tue, 26 Aug 2025 13:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214940; cv=none; b=fnEC8331BdSUkx3OBdUL7l6yf4dqjM1eKjdViGFFLMc4mo4DwK5XC1/raSt7kGLNGay1EBI67yUYxh/UyVnl6chLwkVPsO8Nf5CNc8rFoLfvx1zyGtpfLdPjULGhVjKwIAN0GP2fZjLOklkpEv+xS3MxlTtbPg7dt4XMzXRGDBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214940; c=relaxed/simple;
	bh=nTS7+oth8i1oFSY/p+eQlkKx/SVPxD0bP31dG2QBgHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnNXR3YGNmhuZ08ArJlGtje6CFd4ln0wo+vwSCCfOZmwdKPpVJuJCa2RgyzHhtRR4Hk2NVnild6V8jLvnbgbGXGIzBrUUswhFv+HbRXc8CiczxbGwI753KIxOuVir1Wd+qDztgWplrLH0PNW0u80Czxl2F/QRL+4NZleGnuJABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgbxi5gk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgbxi5gk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0394AC4CEF1;
	Tue, 26 Aug 2025 13:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214940;
	bh=nTS7+oth8i1oFSY/p+eQlkKx/SVPxD0bP31dG2QBgHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgbxi5gkSEYiE+rJQapW7BLIj71nHu5MZogsTnQC6jGIylhz8IC8XtwIT+pKs9CR3
	 fFqkQoWttKdVaFOOIttj0447I9MY0P/6QCk8J/c1rz5+Zbs2J+JNdLqFXOCYlr4KFl
	 jgbWHmEgsC5P/SYxmNUjPMLAoHLosudOrC2ttrHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vedang Nagar <quic_vnagar@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 328/482] media: venus: Add a check for packet size after reading from shared memory
Date: Tue, 26 Aug 2025 13:09:41 +0200
Message-ID: <20250826110938.918425969@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -239,6 +239,7 @@ static int venus_write_queue(struct venu
 static int venus_read_queue(struct venus_hfi_device *hdev,
 			    struct iface_queue *queue, void *pkt, u32 *tx_req)
 {
+	struct hfi_pkt_hdr *pkt_hdr = NULL;
 	struct hfi_queue_header *qhdr;
 	u32 dwords, new_rd_idx;
 	u32 rd_idx, wr_idx, type, qsize;
@@ -304,6 +305,9 @@ static int venus_read_queue(struct venus
 			memcpy(pkt, rd_ptr, len);
 			memcpy(pkt + len, queue->qmem.kva, new_rd_idx << 2);
 		}
+		pkt_hdr = (struct hfi_pkt_hdr *)(pkt);
+		if ((pkt_hdr->size >> 2) != dwords)
+			return -EINVAL;
 	} else {
 		/* bad packet received, dropping */
 		new_rd_idx = qhdr->write_idx;


