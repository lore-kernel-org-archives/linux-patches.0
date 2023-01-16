Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57516FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9D0C433D2;
	Mon, 16 Jan 2023 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888851;
	bh=B5cmW82kB/wHHhC92fetUlos7ytIswBOSmFyzhyEhnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCTNbVGMzyWXXbHndShWE+aWfCAgo+89AuJjxFbfrfjvqoIGg1Og7jKF85o6oJiF5
	 ICm8LtNjsUqiDRqdVlahfgn6CvDSqsGZyHhQ1tkO6sCdTe6Yoq23e9B49CFyEm23gJ
	 ifb9vF2bJ5F9U2FzYffnJIFgJArpzQ8QyJ4214cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 163/338] staging: vme_user: Fix possible UAF in tsi148_dma_list_add
Date: Mon, 16 Jan 2023 16:50:36 +0100
Message-Id: <20230116154827.995594631@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
index fc1b634b969a..2058403f8806 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -1778,6 +1778,7 @@ static int tsi148_dma_list_add(struct vme_dma_list *list,
 	return 0;
 
 err_dma:
+	list_del(&entry->list);
 err_dest:
 err_source:
 err_align:
-- 
2.35.1



