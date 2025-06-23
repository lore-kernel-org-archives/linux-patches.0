Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771C31E487;
	Mon, 23 Jun 2025 13:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684517; cv=none; b=FetdN57xvQCySp1yIP52cnEe+h4FV36B/LNkdhou9XiPv42KQh2jh//ujA3cu6KK5jcwIguSIiyz0XspqHGzIoc1abWyJXoeI4BAgsIGZW5YhZrOMBpX9fw/WwbLxHsDRtH2bTdZ5vAAFJnYX/GZkPf5/qA9oePgHSQ8vnETIbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684517; c=relaxed/simple;
	bh=EiI6SG7JDTMYoJpWrrKZ+WzqvNcEJmXot+094Ux/ahE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTkPb9w+VIUJIDinanXChC+/WNwLOB5x0l5bMcS9G+kD0QBDSeTl/Z9eUx6Abxo875/WUlWxuLjHNBUImM/Qh3aRgv1cNzSis1bIXyOqWhSFpCv3y1AWLIU/OxyjYl6cZ8e1mCBPkIAimsDLRTYM/nyfHq+ER66Iqlgix225UUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YQPTz8IK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQPTz8IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D376C4CEEA;
	Mon, 23 Jun 2025 13:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684517;
	bh=EiI6SG7JDTMYoJpWrrKZ+WzqvNcEJmXot+094Ux/ahE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQPTz8IK+bb8lHNycwZJm/wDlkRzyvSrAVYd4JzHB++0WtMzPoZRPqXf9pHwLbDH1
	 R2NVcmb0RnBaObr+LrPVYzfFOFDD67bdXaiCWdV3fZ1s7Eqp3PpAOH08juYcH99lJP
	 dtCoM+2hOS/7G6SKM47QdyskCqgG3URmODhTnzZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <quic_yabdulra@quicinc.com>,
	Sumit Kumar <quic_sumk@quicinc.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.15 099/592] bus: mhi: ep: Update read pointer only after buffer is written
Date: Mon, 23 Jun 2025 15:00:57 +0200
Message-ID: <20250623130702.630589177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Kumar <quic_sumk@quicinc.com>

commit 6f18d174b73d0ceeaa341f46c0986436b3aefc9a upstream.

Inside mhi_ep_ring_add_element, the read pointer (rd_offset) is updated
before the buffer is written, potentially causing race conditions where
the host sees an updated read pointer before the buffer is actually
written. Updating rd_offset prematurely can lead to the host accessing
an uninitialized or incomplete element, resulting in data corruption.

Invoke the buffer write before updating rd_offset to ensure the element
is fully written before signaling its availability.

Fixes: bbdcba57a1a2 ("bus: mhi: ep: Add support for ring management")
cc: stable@vger.kernel.org
Co-developed-by: Youssef Samir <quic_yabdulra@quicinc.com>
Signed-off-by: Youssef Samir <quic_yabdulra@quicinc.com>
Signed-off-by: Sumit Kumar <quic_sumk@quicinc.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://patch.msgid.link/20250409-rp_fix-v1-1-8cf1fa22ed28@quicinc.com
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/ep/ring.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/bus/mhi/ep/ring.c
+++ b/drivers/bus/mhi/ep/ring.c
@@ -131,19 +131,23 @@ int mhi_ep_ring_add_element(struct mhi_e
 	}
 
 	old_offset = ring->rd_offset;
-	mhi_ep_ring_inc_index(ring);
 
 	dev_dbg(dev, "Adding an element to ring at offset (%zu)\n", ring->rd_offset);
+	buf_info.host_addr = ring->rbase + (old_offset * sizeof(*el));
+	buf_info.dev_addr = el;
+	buf_info.size = sizeof(*el);
+
+	ret = mhi_cntrl->write_sync(mhi_cntrl, &buf_info);
+	if (ret)
+		return ret;
+
+	mhi_ep_ring_inc_index(ring);
 
 	/* Update rp in ring context */
 	rp = cpu_to_le64(ring->rd_offset * sizeof(*el) + ring->rbase);
 	memcpy_toio((void __iomem *) &ring->ring_ctx->generic.rp, &rp, sizeof(u64));
 
-	buf_info.host_addr = ring->rbase + (old_offset * sizeof(*el));
-	buf_info.dev_addr = el;
-	buf_info.size = sizeof(*el);
-
-	return mhi_cntrl->write_sync(mhi_cntrl, &buf_info);
+	return ret;
 }
 
 void mhi_ep_ring_init(struct mhi_ep_ring *ring, enum mhi_ep_ring_type type, u32 id)


