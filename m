Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805E91863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012FFC433F0;
	Wed, 28 Dec 2022 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241424;
	bh=fU9NGN+IJAEiEuvOco0vIM5JZMuMZWYN7Rxz2xFWODs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ClIv2vM5bMJnqtx0DlqxcqMqgxu+NSTT5Ic6Pb+dGB3FTd4E8AQw25a6HCRfd/cUV
	 8ledZDl5yIdI5fwPIgLl6AgWBqtYB4kSZszLjUGfzwE7A4n7LEm92jJN5CZHO16W4S
	 CR3VkIKR+ZaUAmKnekG+m3+hjioBYPkzgKcE86gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0282/1073] media: rkvdec: Add required padding
Date: Wed, 28 Dec 2022 15:31:10 +0100
Message-Id: <20221228144335.680276358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

[ Upstream commit 00c47aa85bb26450edc6059c3d245de062e60b5d ]

The addresses of two elements of the segmap[][] member are passed to the
hardware which expects 128-bit aligned addresses. However, without this
patch offsetof(struct rkvdec_vp9_priv_tbl, segmap[0]) is an odd number
(2421) but the hardware just ignores the 5 least significant bits of the
address. As a result, the hardware writes the segmentation map to incorrect
locations.

Inserting 11 bytes of padding corrects this situation by making the said
addresses divisible by 16 (i.e. aligned on a 128-bit boundary).

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Fixes: f25709c4ff15 ("media: rkvdec: Add the VP9 backend")
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec-vp9.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/rkvdec/rkvdec-vp9.c b/drivers/staging/media/rkvdec/rkvdec-vp9.c
index d8c1c0db15c7..cfae99b40ccb 100644
--- a/drivers/staging/media/rkvdec/rkvdec-vp9.c
+++ b/drivers/staging/media/rkvdec/rkvdec-vp9.c
@@ -84,6 +84,8 @@ struct rkvdec_vp9_probs {
 		struct rkvdec_vp9_inter_frame_probs inter;
 		struct rkvdec_vp9_intra_only_frame_probs intra_only;
 	};
+	/* 128 bit alignment */
+	u8 padding1[11];
 };
 
 /* Data structure describing auxiliary buffer format. */
@@ -1006,6 +1008,7 @@ static int rkvdec_vp9_start(struct rkvdec_ctx *ctx)
 
 	ctx->priv = vp9_ctx;
 
+	BUILD_BUG_ON(sizeof(priv_tbl->probs) % 16); /* ensure probs size is 128-bit aligned */
 	priv_tbl = dma_alloc_coherent(rkvdec->dev, sizeof(*priv_tbl),
 				      &vp9_ctx->priv_tbl.dma, GFP_KERNEL);
 	if (!priv_tbl) {
-- 
2.35.1



