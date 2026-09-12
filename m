Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605EE29D288;
	Sat, 12 Sep 2026 19:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242877; cv=none; b=hYEfFLl80MBth55a0Wg+v25H0SSZF/hWYNZoLXThtxPYrCbPtgufjKgipdQGyUgnJKM3yV1FpabUmBwmdZ7Cv0Rqyu0libfeKeywVtR209egCyrJdL8xgyKdIHIAejAMEJ6QO39sFeOz5H0tFvkDjrplUf/QtsUYIH4BVPzrNmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242877; c=relaxed/simple;
	bh=YIPgdiXW4+2ZHP8VxymjRhzrOKFwboK8DxLJG7YzSlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lv/FnbA77594wtmkEZsNRuN1uvA/oO5ZuDT31iu8xrzwnD6xmvklnkcLgzLDVLb2a67InRYJ8gM5UljgNAfKyZNmQunTKgXJ4wy6GE27MFqBzZxsZ67b4PopZtF+2QqhdlnyzHrAOhDX4Tnwi74MQNcOhsHUCJDrokAMfdfWCig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvWx0bqf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvWx0bqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804B01F000FF;
	Sat, 12 Sep 2026 19:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242876;
	bh=/kxAVWa2VX2z41+7yg0cejA9NjGujGrW7dx2tFl9jm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvWx0bqfbnoU3OgIKIW5mUmbNeqQONd2G16fqlfQy133G3q9TgqOrMkDBzu/oVrTm
	 Y0oFOTSVWmZ/c35RLK4QmLTt2NVPSvxLMwCGzPfwQuYIbGCV3PAcrU+0Y/j20MHNy7
	 L+HJA8gCBVX0g79oon05Ny8xrAJQR9WN7EXrlwm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 527/798] RDMA/efa: Fix PBL chunk length computation
Date: Sat, 12 Sep 2026 09:02:35 +0200
Message-ID: <20260912065529.212564777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 15086856581f7..3cb1aebae7006 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1217,9 +1217,11 @@ static int pbl_chunk_list_create(struct efa_dev *dev, struct pbl_context *pbl)
 
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
@@ -1231,9 +1233,12 @@ static int pbl_chunk_list_create(struct efa_dev *dev, struct pbl_context *pbl)
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



