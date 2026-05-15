Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E903FD97A;
	Fri, 15 May 2026 16:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861984; cv=none; b=sJuTM0/sG5H3vejFJj09N9e+DP3UzAedLC98Aq12Jb0arYMzPcfOObH5e1sznAJ7mO4na6daw3BWjWAmdlwnImopIEg0Rec+6WbNoOoteMUOVogRUW/u2R0u0XnOLehUU+1QyOmXL4qv0rhhXmY2YPrJVIxhG0vwzAyEcci/k0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861984; c=relaxed/simple;
	bh=xQSsQvl4kQ46v0FoBJA3qnwsvvTRCOuvQPXd6xa1OI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NCkKZK4y2iSMYaitTrKDS3gStBLYgZLlsu7L+IPHhaZdWh8faMhdwWDQ4om+LRReoJueJ8oRV+0G9mAFaobhovDLCZguTbDUAGrdhLeIO1VzIGpHhk4XggBi8O8hPiNdvq2l5Jdy9tadWL94m5L5gha0iFuPrRcf7kkjuLYvLL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBNRQ0z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBNRQ0z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7426EC2BCB0;
	Fri, 15 May 2026 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861983;
	bh=xQSsQvl4kQ46v0FoBJA3qnwsvvTRCOuvQPXd6xa1OI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBNRQ0z3iS0yGnHGtVOtJ78VO/DmfGxzMhhkYSIm0IoSPjRm/CtMJyJfWDvTk2JZn
	 OGuvApvao7k59HgxaYFdOtRkT7PxKqAWU/5MFlEAo8pBJRSE5rSNYJcuy+ksQ3L87r
	 e1Kx+2CWkn6afJMKSZFLlIdjgJXh4pb7QsAxI9JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 061/188] media: iris: Fix dma_free_attrs() size in iris_hfi_queues_init()
Date: Fri, 15 May 2026 17:47:58 +0200
Message-ID: <20260515154658.640837101@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 4a49ae56b0e4268d48fd96babe0cc68596bc301a upstream.

The core->iface_q_table_vaddr buffer is alloc'd with size queue_size
but freed with sizeof(*q_tbl_hdr) which is different.

Change the dma_free_attrs() size.

Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Fixes: d7378f84e94e ("media: iris: introduce iris core state management with shared queues")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/qcom/iris/iris_hfi_queue.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_queue.c
@@ -263,7 +263,7 @@ int iris_hfi_queues_init(struct iris_cor
 					  GFP_KERNEL, DMA_ATTR_WRITE_COMBINE);
 	if (!core->sfr_vaddr) {
 		dev_err(core->dev, "sfr alloc and map failed\n");
-		dma_free_attrs(core->dev, sizeof(*q_tbl_hdr), core->iface_q_table_vaddr,
+		dma_free_attrs(core->dev, queue_size, core->iface_q_table_vaddr,
 			       core->iface_q_table_daddr, DMA_ATTR_WRITE_COMBINE);
 		return -ENOMEM;
 	}


