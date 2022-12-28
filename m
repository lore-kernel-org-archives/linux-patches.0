Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ECB1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19129C433EF;
	Wed, 28 Dec 2022 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241146;
	bh=S6V5u5OV27pQOmyaW+vYiNVeAx7P3V/kz81SGJAcsSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lXI4afPLScU9T0LowPf8+uOj0mWAvOdX2aD8ZNYqmYiRmRYuKdtWBmp1DGBj9fSzk
	 KhEMRhVekQ9ni4M/Y9VV1SPWLwBzJvDGLygDHGFA0oW+cNNRVouZ52fhBqVotjtHgi
	 PHvifg7HJnhVd/ft0a9cIUmH4xhn9o8/fTDAgGyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 446/731] staging: vme_user: Fix possible UAF in tsi148_dma_list_add
Date: Wed, 28 Dec 2022 15:39:13 +0100
Message-Id: <20221228144309.483866246@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 357057ee55d3c99a5de5abe8150f7bca04f8e53b ]

Smatch report warning as follows:

drivers/staging/vme_user/vme_tsi148.c:1757 tsi148_dma_list_add() warn:
  '&entry->list' not removed from list

In tsi148_dma_list_add(), the error path "goto err_dma" will not
remove entry->list from list->entries, but entry will be freed,
then list traversal may cause UAF.

Fix by removeing it from list->entries before free().

Fixes: b2383c90a9d6 ("vme: tsi148: fix first DMA item mapping")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221117035914.2954454-1-cuigaosheng1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vme/bridges/vme_tsi148.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index be9051b02f24..5b4c766d15e6 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -1765,6 +1765,7 @@ static int tsi148_dma_list_add(struct vme_dma_list *list,
 	return 0;
 
 err_dma:
+	list_del(&entry->list);
 err_dest:
 err_source:
 err_align:
-- 
2.35.1



