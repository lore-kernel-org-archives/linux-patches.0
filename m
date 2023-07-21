Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A5E20F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34102C433C8;
	Fri, 21 Jul 2023 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967204;
	bh=mHIEelpe/S7D/3a1+0wNKgINSFmILmE/v7jFAEfiVMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzUbEk7FEo8K7eB+/OtQ1lolLveHtrYGrAGgr8OvB8sY2RSGV7fzDV0t7ZYadOQQ2
	 p/u2YXvG7bajUtLfSZeClIQbBpHr+Egu+maKzzyd5nDrBNOQSHUQ1M//+SUPZY0Aq9
	 GsWnBVpyNwZve8AScpyv/HEkV0Lxcz941zXdVUao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/223] erofs: avoid useless loops in z_erofs_pcluster_readmore() when reading beyond EOF
Date: Fri, 21 Jul 2023 18:05:05 +0200
Message-ID: <20230721160523.073181343@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chunhai Guo <guochunhai@vivo.com>

[ Upstream commit 936aa701d82d397c2d1afcd18ce2c739471d978d ]

z_erofs_pcluster_readmore() may take a long time to loop when the page
offset is large enough, which is unnecessary should be prevented.

For example, when the following case is encountered, it will loop 4691368
times, taking about 27 seconds:
    - offset = 19217289215
    - inode_size = 1442672

Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
Fixes: 386292919c25 ("erofs: introduce readmore decompression strategy")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230710042531.28761-1-guochunhai@vivo.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 92b2e4ddb7ce9..bf6a369f9c696 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1660,7 +1660,7 @@ static void z_erofs_pcluster_readmore(struct z_erofs_decompress_frontend *f,
 	}
 
 	cur = map->m_la + map->m_llen - 1;
-	while (cur >= end) {
+	while ((cur >= end) && (cur < i_size_read(inode))) {
 		pgoff_t index = cur >> PAGE_SHIFT;
 		struct page *page;
 
-- 
2.39.2



