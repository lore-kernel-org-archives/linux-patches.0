Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88D532142A;
	Mon, 27 Oct 2025 18:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591510; cv=none; b=S0GX1TXI1+/vyePeiAF/wjp6cIHg/mS1DqWf7YbgahrI2V7x28eiHRiaV3Oqc1TyYLfzWZQnjlDcRGpU3aPNbTmynluBSSFwyWul+9ciiNyXuV6ujx6gpENqvWIotEp5FE26CrPYrQejps3GTab6c1KAYCfbEQcEFoei1bbxAzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591510; c=relaxed/simple;
	bh=loUFQSd7MEXbTzcGDYEk4+zZZeYLpOUYhxJ/lOAqrvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLqTkCPwHF6KgZQ6aTrIZbqFWrbk9oThx/TvySXuVTR+RC2+WSjeSi2P4T0+2W++FLwPqTwURHw99NIY/lahdxfof8ouoTDDA+9dd/fbBPJgkW2i/g2/SDoAzfyfKQpYH7iETHluAfhiGcE1hG0M0UnAwdXMd09s8VPFOumsgnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KnN8kPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KnN8kPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B28F8C4CEF1;
	Mon, 27 Oct 2025 18:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591510;
	bh=loUFQSd7MEXbTzcGDYEk4+zZZeYLpOUYhxJ/lOAqrvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1KnN8kPd1yj6Z8uSWrWxGnkDfof/sHo4q3XvMbM1VO9lgYuW1hWFt4qNoq16Ifdxv
	 T16V4N9LFb3DdXeP6UedVNedYg2Xq5rmP/g+3XUq4C/iHUrEoVUNHzYwxMLSGxHuW6
	 ygoRlqTQbThFAEPHLrAcczuxBEUJC+CkPTpn6g00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/332] media: cx18: Add missing check after DMA map
Date: Mon, 27 Oct 2025 19:34:36 +0100
Message-ID: <20251027183530.678481325@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 23b53639a793477326fd57ed103823a8ab63084f ]

The DMA map functions can fail and should be tested for errors.
If the mapping fails, dealloc buffers, and return.

Fixes: 1c1e45d17b66 ("V4L/DVB (7786): cx18: new driver for the Conexant CX23418 MPEG encoder chip")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ removed pci_map_single() replaced by dma_map_single() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cx18/cx18-queue.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/media/pci/cx18/cx18-queue.c
+++ b/drivers/media/pci/cx18/cx18-queue.c
@@ -379,14 +379,22 @@ int cx18_stream_alloc(struct cx18_stream
 			break;
 		}
 
+		buf->dma_handle = dma_map_single(&s->cx->pci_dev->dev,
+						 buf->buf, s->buf_size,
+						 s->dma);
+		if (dma_mapping_error(&s->cx->pci_dev->dev, buf->dma_handle)) {
+			kfree(buf->buf);
+			kfree(mdl);
+			kfree(buf);
+			break;
+		}
+
 		INIT_LIST_HEAD(&mdl->list);
 		INIT_LIST_HEAD(&mdl->buf_list);
 		mdl->id = s->mdl_base_idx; /* a somewhat safe value */
 		cx18_enqueue(s, mdl, &s->q_idle);
 
 		INIT_LIST_HEAD(&buf->list);
-		buf->dma_handle = pci_map_single(s->cx->pci_dev,
-				buf->buf, s->buf_size, s->dma);
 		cx18_buf_sync_for_cpu(s, buf);
 		list_add_tail(&buf->list, &s->buf_pool);
 	}


