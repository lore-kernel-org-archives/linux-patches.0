Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DB135F191;
	Sat, 12 Sep 2026 08:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200047; cv=none; b=LH6QvBloD3P7ZqtAKtj7ulVm6TGWUpT4V0vLsCNru/dUQmwasGSvnVNhnIScLhRY8MnA8mhlKSYaEscf8maj6AKti41I1nXmkj3fMFj/5riqBwQSeeV4VCrgmaG94TZ5b7zi8qAKJvd+Nf+kvTBlvVvSi9s4qaPXkiwHmp4+2ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200047; c=relaxed/simple;
	bh=YvSQ1TGKXeXs+vcYSmiCl3R+vp5cb7NuFgBE55eb1I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7bIS3G6KnYm+F9nyCCA3zacVgexH+5U2QzqBFMtHjKcYbzu0Knp5xARuM5lZ7zEu0FaNMdNyxRYxrRK4wYlpYwZcvQJicBmdl7glVua+at8aVBvirNZ9vvT2dcfotmvUaPpnNjzFgJPOcKVOcy4vCYITTXklPAnK2al3wxwBi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r05mq7Hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r05mq7Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A181F000FF;
	Sat, 12 Sep 2026 08:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200046;
	bh=bwqXqRFeRsVAyvJizgVwuwlYJDH0bgPZoKcg1wTekF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r05mq7HiokChX4yBMjDeJOrWLmc7OA0kCkZCGXLGvGJ0ZzzV7fr1fUuSipFDlwxsi
	 R4lqjm112KA501U6+R8azfqHdy31zC0AlSja5OkDCYRn9nMoSkMAcYb8wRb+fyrsW1
	 c5Y4qdHx0qXKv/GEFKzo+mKbs6Reu4NKvVfilgh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0710/1815] RDMA/efa: Fix PBL chunk length computation
Date: Sat, 12 Sep 2026 08:41:00 +0200
Message-ID: <20260912065705.562679166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 06d3365aeb569..267a74ac15f3d 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1345,9 +1345,11 @@ static int pbl_chunk_list_create(struct efa_dev *dev, struct pbl_context *pbl)
 
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
@@ -1359,9 +1361,12 @@ static int pbl_chunk_list_create(struct efa_dev *dev, struct pbl_context *pbl)
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



