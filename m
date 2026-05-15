Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47F04C040C;
	Fri, 15 May 2026 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862518; cv=none; b=gjhXYPsiqJ+DjGyM6+wZW7l0eQhEuIM4z7Pp5Ecq0RvcB3Hq89szxpu83qmkUcam8hHl6e5FcS5iEtaTlsooJztckGB7lGgFpu3qQQPrYKl0pPzmpVyCru1tES29Qnzut2m3dsMn3RR6oDhFPpfXmz2lf4/6AF4mGc8evo+vB2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862518; c=relaxed/simple;
	bh=JNTg0PJBNkUIBinN9yb81e0GyYohAkI5FIJo8yXk+bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WydZb/PLa7x51pqn3dZpFQfqVXRsjk+RyocySAA60lQbxgVavcfzDJIwrLXBpgyrY5BvIudOZIs9vkzkhkR/OYXyu3pK1MDRL0+6zW4+2JdTw80ZyjRFo0I5AXLNje54dwPZdCWv4jVOmkaYNQ2Og0Wr5k6vV/cWUk48LzLsZi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdcKOez/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdcKOez/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5F7C2BCB0;
	Fri, 15 May 2026 16:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862518;
	bh=JNTg0PJBNkUIBinN9yb81e0GyYohAkI5FIJo8yXk+bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdcKOez/Y+uvW38UdsvU+6Xfi93KloLqacSIBGsGmZCwXsUCaey2Vsf+nsq670p94
	 DP6wU/+1xEWvpZCgz2Z1mfOS94JVqcxg2KYpdI09TNjH05VPcYxEPKvUESLs7Vihm1
	 crVoPirDJc94L2epYz2bdhCT0nGAe4SuzKGI2dAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 078/201] media: iris: Fix dma_free_attrs() size in iris_hfi_queues_init()
Date: Fri, 15 May 2026 17:48:16 +0200
Message-ID: <20260515154700.222225596@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


