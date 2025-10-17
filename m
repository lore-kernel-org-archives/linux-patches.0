Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75013370F8;
	Fri, 17 Oct 2025 14:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713142; cv=none; b=T6OAAo0+9+ATKu1ciUjXp25Shgnv41zNv1/n3UYZNhn1Q1GS8z23MmMrlFmAvddvFfhcUnGSORfGbU5b0yR+hjRibnxV4YOdgt8vj0hlahB5Cs/Ob3KtcE595Lb9rnHoaFYA3lJ/XKXMO/0cTmzd9qiH05J3w38IVmvLxO1GCx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713142; c=relaxed/simple;
	bh=Wc5JaPkCjNirUDVmxnncxQuUdV20Pf2DTg5rHPRbu8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzzP3Ht70ccV9zDGnTviQcZTVTYwTKTTkgjgPNKhMY0ev8uxoLFNqByodH/dkFIqqImV+bSlB8eaxE03UW/HLIfi3NXs5JCr2JuVnA8xNRREpu8wjKWY+7fdhGvVZo7XYt8m0TEoTVP+swZmclVNe3GKdmcrrRvAOgyOiuMicLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAzZfAzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAzZfAzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E579C4CEE7;
	Fri, 17 Oct 2025 14:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713142;
	bh=Wc5JaPkCjNirUDVmxnncxQuUdV20Pf2DTg5rHPRbu8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAzZfAzIQVfQraGVPCmdU/HsBJbYewiV7sp0+h8X0zZ7VjF2T0lyAOYE/cfh3vJjX
	 67xMmMSgvwJ+eyJHnP7ksm5NlJEbByzEfK8q7qDkw9sEFwfDrMtRAzHhFZd+GMQFH6
	 5D/irdqHCvhBuo8I/DU4HVfK3wViZ+NFDQDCJlVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 063/168] media: cx18: Add missing check after DMA map
Date: Fri, 17 Oct 2025 16:52:22 +0200
Message-ID: <20251017145131.345190800@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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


