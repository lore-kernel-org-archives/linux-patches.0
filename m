Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C772D33F368;
	Sat, 12 Sep 2026 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223985; cv=none; b=TxZPLskBnz+dv/4f2mdowUJfBz/ILtzafayuW0T/n9vKTWaU8z0cgB0PXaXyr3zlJTCfQqzRJgaRrEp86z4R7vnmNbdbAuN+yOK8Wjl44v3vncvAijQjVMPPqYgOvOgIQl6XrxDmStORZTIY1bkuiyrNGF+j2/xPzNdvdsKPU+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223985; c=relaxed/simple;
	bh=ihOClF/xN3mu/hlUl3wywwNCOTMRzb0F/4/luY8BVqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQycOAHNzwqnHTB7v/+0EexbK2VezUNhwqipf8ejokGpTPscTOmIDue34nVqzdSopNJGSaiGQmmflu9FtjtZpz7IenTxpgy0a+p+GCTHA9DOjat8fFFdDlIpX4Y1hx8mUlWRwc+nJga+X9OL2hzUjQo2JvB8NOEZcfTpypU1pgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIbnuGcI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIbnuGcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE671F000FF;
	Sat, 12 Sep 2026 14:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223982;
	bh=J/CsXdHV4Keq1nbzANh66WBKJ+bVC8xLHMZsnYOcDsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIbnuGcI26NJn0t94JIA9vptaoVJs3XrJpf7rVNcc8+9uZSMdKffMMUQ75d+PNfvW
	 IpPoHvXmQ0hs5oReLC0OElW/ycDzt4M1x9NssS4JauryvJE5yGKSGiLnobmHfW9mq2
	 PpbmfZ8iIa/esP9L8fdGJxuKdF1w/YM9XyRqeRT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0898/1424] RDMA/efa: Fix PBL chunk length computation
Date: Sat, 12 Sep 2026 08:55:30 +0200
Message-ID: <20260912065627.438718659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Yonatan Nachum <ynachum@amazon.com>

[ Upstream commit 229b42d7450c1cf96f45ec39ebb69211b06bc036 ]

On register MR, when creating the PBL, if it's an indirect PBL we create
a chunk list to hold the PBL pages pointers. Each chunk is 4KB in size
and can hold 510 addresses (EFA_PTRS_PER_CHUNK) and has a 12-byte
control buffer at the end of it holding the next chunk's pointer and its
length.

If the PBL number of pages is a multiple of EFA_PTRS_PER_CHUNK, the
calculated last chunk length is wrongly computed as 0, even though that
chunk is fully populated with 510 real page pointers. This wrong length
is used both to DMA map the chunk and is propagated to the device,
causing the device to see the chunk as empty and reject the memory
registration.

Fix the calculation so it will be performed only if the number of pages
isn't a multiple of EFA_PTRS_PER_CHUNK, if it is, its already handled in
the above loop correctly.
Also prevent out-of-bounds reach in the chunks array in such scenario.

Fixes: 40909f664d27 ("RDMA/efa: Add EFA verbs implementation")
Reviewed-by: Firas Jahjah <firasj@amazon.com>
Reviewed-by: Michael Margolin <mrgolin@amazon.com>
Signed-off-by: Yonatan Nachum <ynachum@amazon.com>
Link: https://patch.msgid.link/20260727090255.1175120-1-ynachum@amazon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 7648d162a10d2..6e9ca433d4b22 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1296,9 +1296,11 @@ static int pbl_chunk_list_create(struct efa_dev *dev, struct pbl_context *pbl)
 
 		chunk_list->chunks[i].length = EFA_CHUNK_USED_SIZE;
 	}
-	chunk_list->chunks[chunk_list_size - 1].length =
-		((page_cnt % EFA_PTRS_PER_CHUNK) * EFA_CHUNK_PAYLOAD_PTR_SIZE) +
-			EFA_CHUNK_PTR_SIZE;
+
+	if (page_cnt % EFA_PTRS_PER_CHUNK != 0)
+		chunk_list->chunks[chunk_list_size - 1].length =
+			((page_cnt % EFA_PTRS_PER_CHUNK) * EFA_CHUNK_PAYLOAD_PTR_SIZE) +
+				EFA_CHUNK_PTR_SIZE;
 
 	/* fill the dma addresses of sg list pages to chunks: */
 	chunk_idx = 0;
@@ -1310,9 +1312,12 @@ static int pbl_chunk_list_create(struct efa_dev *dev, struct pbl_context *pbl)
 			rdma_block_iter_dma_address(&biter);
 
 		if (payload_idx == EFA_PTRS_PER_CHUNK) {
+			payload_idx = 0;
 			chunk_idx++;
+			if (chunk_idx >= chunk_list_size)
+				break;
+
 			cur_chunk_buf = chunk_list->chunks[chunk_idx].buf;
-			payload_idx = 0;
 		}
 	}
 
-- 
2.53.0



