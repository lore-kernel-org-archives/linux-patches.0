Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FFC1D6A7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9447AC433C7;
	Wed, 20 Sep 2023 11:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211046;
	bh=j+D/W2jm8c6lsu6hf8PuVVp1oqPV5Dy/1z83KuBMaio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUH1/S4fdrCSc8zAAW8dLwVu0a3qG0TTklEh/uEtYOuTBhT2r/27FeiB9qrIKe3W6
	 xUBS9oz67P4OieCkbVJFO5lTvdsABinSigVw5o1NUQq5FfAmbvzfg1GRsJW+bjyJp/
	 wHXF5q69cX2DRoimXCieCcrTeyg79+ylG9B0nh8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/139] misc: fastrpc: Prepare to dynamic dma-buf locking specification
Date: Wed, 20 Sep 2023 13:30:23 +0200
Message-ID: <20230920112838.937591477@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

[ Upstream commit 791da5c7fedbc1d662445ec030d8f86872f6184c ]

Prepare fastrpc to the common dynamic dma-buf locking convention by
starting to use the unlocked versions of dma-buf API functions.

Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221017172229.42269-12-dmitry.osipenko@collabora.com
Stable-dep-of: a2cb9cd6a394 ("misc: fastrpc: Fix incorrect DMA mapping unmap request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 13518cac076c7..e9291694922bc 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -310,8 +310,8 @@ static void fastrpc_free_map(struct kref *ref)
 				return;
 			}
 		}
-		dma_buf_unmap_attachment(map->attach, map->table,
-					 DMA_BIDIRECTIONAL);
+		dma_buf_unmap_attachment_unlocked(map->attach, map->table,
+						  DMA_BIDIRECTIONAL);
 		dma_buf_detach(map->buf, map->attach);
 		dma_buf_put(map->buf);
 	}
@@ -736,7 +736,7 @@ static int fastrpc_map_create(struct fastrpc_user *fl, int fd,
 		goto attach_err;
 	}
 
-	map->table = dma_buf_map_attachment(map->attach, DMA_BIDIRECTIONAL);
+	map->table = dma_buf_map_attachment_unlocked(map->attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(map->table)) {
 		err = PTR_ERR(map->table);
 		goto map_err;
-- 
2.40.1



