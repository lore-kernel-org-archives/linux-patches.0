Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA15749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35F1C433D2;
	Thu, 12 Jan 2023 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532376;
	bh=pe5eKJ6QFQLexdOIxDequbId2uIwFad5KU1W1iWG8Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QdLwAfLemSRD3TERFdfVgv7qQ+E7JpaAioPOMkzgq1GByrfI+LpWYfTP01CltvTei
	 uoUE7BiSbuKqOGqJbKXrFpN6mYZ9wUbl5LkVbXMAvn+nRRNhPZ6rfCYflgd9cXBbWw
	 NGWFeV1Dcr0aNeWitaWV/1jViKCBfsq/9o3jQXHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/783] media: coda: jpeg: Add check for kmalloc
Date: Thu, 12 Jan 2023 14:47:06 +0100
Message-Id: <20230112135529.298158876@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit f30ce3d3760b22ee33c8d9c2e223764ad30bdc5f ]

As kmalloc can return NULL pointer, it should be better to
check the return value and return error, same as
coda_jpeg_decode_header.

Fixes: 96f6f62c4656 ("media: coda: jpeg: add CODA960 JPEG encoder support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-jpeg.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-jpeg.c b/drivers/media/platform/coda/coda-jpeg.c
index a72f4655e5ad..b7bf529f18f7 100644
--- a/drivers/media/platform/coda/coda-jpeg.c
+++ b/drivers/media/platform/coda/coda-jpeg.c
@@ -1052,10 +1052,16 @@ static int coda9_jpeg_start_encoding(struct coda_ctx *ctx)
 		v4l2_err(&dev->v4l2_dev, "error loading Huffman tables\n");
 		return ret;
 	}
-	if (!ctx->params.jpeg_qmat_tab[0])
+	if (!ctx->params.jpeg_qmat_tab[0]) {
 		ctx->params.jpeg_qmat_tab[0] = kmalloc(64, GFP_KERNEL);
-	if (!ctx->params.jpeg_qmat_tab[1])
+		if (!ctx->params.jpeg_qmat_tab[0])
+			return -ENOMEM;
+	}
+	if (!ctx->params.jpeg_qmat_tab[1]) {
 		ctx->params.jpeg_qmat_tab[1] = kmalloc(64, GFP_KERNEL);
+		if (!ctx->params.jpeg_qmat_tab[1])
+			return -ENOMEM;
+	}
 	coda_set_jpeg_compression_quality(ctx, ctx->params.jpeg_quality);
 
 	return 0;
-- 
2.35.1



