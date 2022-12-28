Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4430D1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2CCC433EF;
	Wed, 28 Dec 2022 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240134;
	bh=B6I3QwotEuoVP9/A5cllJVFQ8PF/X5fd3Xhk7pT5rqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K1f4rRU5wwAPIdkxIxP32D4ZXGGHwTmlRSzxiSZ50cPBhJOpU4lSk5RJ9KdB1Xwc2
	 gZz2lbanS30Q4fqwyt3usUIVm5nk66A4K1/kqYWzubSjuqSKhkap2Cbr3DfwmOFf6Y
	 SktZsynGUg+rEERXBk6Ql0H1w/MaMzKlE/j3oLek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 313/731] media: coda: Add check for kmalloc
Date: Wed, 28 Dec 2022 15:37:00 +0100
Message-Id: <20221228144305.650526104@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit 6e5e5defdb8b0186312c2f855ace175aee6daf9b ]

As the kmalloc may return NULL pointer,
it should be better to check the return value
in order to avoid NULL poineter dereference,
same as the others.

Fixes: cb1d3a336371 ("[media] coda: add CODA7541 JPEG support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-bit.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 284608845b85..582a6c581f3c 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1082,10 +1082,16 @@ static int coda_start_encoding(struct coda_ctx *ctx)
 	}
 
 	if (dst_fourcc == V4L2_PIX_FMT_JPEG) {
-		if (!ctx->params.jpeg_qmat_tab[0])
+		if (!ctx->params.jpeg_qmat_tab[0]) {
 			ctx->params.jpeg_qmat_tab[0] = kmalloc(64, GFP_KERNEL);
-		if (!ctx->params.jpeg_qmat_tab[1])
+			if (!ctx->params.jpeg_qmat_tab[0])
+				return -ENOMEM;
+		}
+		if (!ctx->params.jpeg_qmat_tab[1]) {
 			ctx->params.jpeg_qmat_tab[1] = kmalloc(64, GFP_KERNEL);
+			if (!ctx->params.jpeg_qmat_tab[1])
+				return -ENOMEM;
+		}
 		coda_set_jpeg_compression_quality(ctx, ctx->params.jpeg_quality);
 	}
 
-- 
2.35.1



