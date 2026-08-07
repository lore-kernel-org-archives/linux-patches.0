Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D05A1C84D0;
	Fri,  7 Aug 2026 15:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116123; cv=none; b=a+2NLgrEzJhjag7+TJ+11XaikBPVo3Lg+0WaLbDe2/ogRAj0eu25ecKat0zkoezsTwUF+fXx+3vG14M+HErufrj3zOnnJEvLMBIQ9KqpRh7xh+YS3kS8BcWTCVGDOPpw+V5N9YzCwAqG+oibEQ369IsligAcfL6CBAqfIMMJA6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116123; c=relaxed/simple;
	bh=Lr172xOCNqieoczMBXVSSyDc1GKrk/1zTzL5csjaYnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKpvav3PcWJ+MmZoeomTogxpiLj/s2t3Qfj0fPpuWp3GYoREJjAnXeena4G+tNwfwcq6N4fhzxaLYhezAI9M9jlWabXfOVnAPTn1OqEn0ISBRQsX9+p1KkEsps1q3Ar+fLJN8EmPm76pN3T//lmm3aCnMz5LiRUKwSnE5+wePOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUaLPRxk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUaLPRxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC9E1F000E9;
	Fri,  7 Aug 2026 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116121;
	bh=ml6aPp3I2L0HjuPtwTQ1/O5R9umdd27PA3L1ondmyms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUaLPRxkBloqnzuFZbbfQhMTTAM3/2RjCu5+vdGAvLkpOz420y7KCoTJAHQSH6bKQ
	 sQVcBXkmRNJOmln1ycamhAxf8uLl9zaJQrnrmqsq5kL4O1mXI0pRom3A3JjPMQRDN/
	 vi+88gTYyk1fJuaPVnt5vJRTq/WMtxLnd1Gi2JN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/261] Bluetooth: btintel: Validate length before parsing diagnostics TLV
Date: Fri,  7 Aug 2026 16:37:03 +0200
Message-ID: <20260807143416.806968101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit b640ff9af3c809ff5ea2077fbba17df1594ec1e4 ]

btintel_diagnostics() accesses tlv->val[0] without first validating
that the diagnostics VSE is long enough to contain that field, so
may cause reading data beyond the received frame.

Fix by validating the length before access.

Fixes: af395330abed ("Bluetooth: btintel: Add Intel devcoredump support")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 25fcd00c6a174..4784da07dd8a1 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2922,6 +2922,9 @@ static int btintel_diagnostics(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct intel_tlv *tlv = (void *)&skb->data[5];
 
+	if (skb->len < 5 + sizeof(*tlv) + sizeof(tlv->val[0]))
+		goto recv_frame;
+
 	/* The first event is always an event type TLV */
 	if (tlv->type != INTEL_TLV_TYPE_ID)
 		goto recv_frame;
-- 
2.53.0



