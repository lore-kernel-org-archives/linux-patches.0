Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996C6332901;
	Fri, 17 Oct 2025 15:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714415; cv=none; b=lpfPyg8pForMWXSlKQ9R8bldFyJkaAhCN30f1b7zSYzeamB9M7wGXtCbeKIf6j2HiE4gCI2VnbNYQrONsE3A8/mrxoUWoKAuwMbMyOdokD7KINLo2Rn1xmOhkiDIwg0YTv+B1e6OVrkqUoh4NanYfmE9NKtZG+/uPOT9ALkGvQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714415; c=relaxed/simple;
	bh=bC6VSP9KSwHzrvHhg7M9Zvw0ET0xMm+oWz8Ya+mtvU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z86aN2eTnj4U/wqfHZq1JvmxZ7F/VtIbFxpiaYXCR5onBrlNkBHoMbTTYQrW3Fs+aT80TZJyTyTFItYWch9lP6b+jAKL9JuudvRzqUo2m0+7MyK1ElCOA9tIOffbOa95Iu6ptdHUesWgp3vPSEcndtTjgtcMGPxMPLMQInJktF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RztcfTlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RztcfTlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EA4C4CEE7;
	Fri, 17 Oct 2025 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714415;
	bh=bC6VSP9KSwHzrvHhg7M9Zvw0ET0xMm+oWz8Ya+mtvU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RztcfTljji/yR6KslvnZBQsHts7sYvuYaxfbsy2ie93Hvbn7VAxmbBGJYGLRzETrc
	 54PPcQcHJMzjv7ItjT74Nfi710r1YMRyagVfZygaArCml3r+ehjhJ8/9ruxavlEKB5
	 PLsQGtFxd2ki7+JJsJO1uGJe0G8a1FDXLsSzEyK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 104/277] media: cx18: Add missing check after DMA map
Date: Fri, 17 Oct 2025 16:51:51 +0200
Message-ID: <20251017145150.928044298@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit 23b53639a793477326fd57ed103823a8ab63084f upstream.

The DMA map functions can fail and should be tested for errors.
If the mapping fails, dealloc buffers, and return.

Fixes: 1c1e45d17b66 ("V4L/DVB (7786): cx18: new driver for the Conexant CX23418 MPEG encoder chip")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cx18/cx18-queue.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/media/pci/cx18/cx18-queue.c
+++ b/drivers/media/pci/cx18/cx18-queue.c
@@ -379,15 +379,22 @@ int cx18_stream_alloc(struct cx18_stream
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
-		buf->dma_handle = dma_map_single(&s->cx->pci_dev->dev,
-						 buf->buf, s->buf_size,
-						 s->dma);
 		cx18_buf_sync_for_cpu(s, buf);
 		list_add_tail(&buf->list, &s->buf_pool);
 	}


