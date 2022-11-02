Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6D67E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B860C433D6;
	Wed,  2 Nov 2022 02:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357223;
	bh=PdIrvHIl+y1YkdJcK+5MIOtFm6wWoYghbNhOtjlw7yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBIOjj6tsQJfy0x8Aw3ilZQR71BM5H4n1wn1a7L8U9cggVZ8tVf7YxObHs8whtb5T
	 zl/wxqTOP/Mb78RVw7lEbj24Qop/kMZMYQgGAxZmyR00W7sy4jaTAworDrncyBXz+G
	 RSU+8+l+I3SDZj5u/uprQpGyBKjD4Y8zuvannFW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 134/240] erofs: fix up inplace decompression success rate
Date: Wed,  2 Nov 2022 03:31:49 +0100
Message-Id: <20221102022114.410792838@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit e7933278b442f97809b1ea84264586302bd08a03 ]

Partial decompression should be checked after updating length.
It's a new regression when introducing multi-reference pclusters.

Fixes: 2bfab9c0edac ("erofs: record the longest decompressed size in this round")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221014064915.8103-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 6e663275aeb1..c7511b431776 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -765,13 +765,13 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 	if (fe->pcl->pageofs_out != (map->m_la & ~PAGE_MASK))
 		fe->pcl->multibases = true;
 
-	if ((map->m_flags & EROFS_MAP_FULL_MAPPED) &&
-	    fe->pcl->length == map->m_llen)
-		fe->pcl->partial = false;
 	if (fe->pcl->length < offset + end - map->m_la) {
 		fe->pcl->length = offset + end - map->m_la;
 		fe->pcl->pageofs_out = map->m_la & ~PAGE_MASK;
 	}
+	if ((map->m_flags & EROFS_MAP_FULL_MAPPED) &&
+	     fe->pcl->length == map->m_llen)
+		fe->pcl->partial = false;
 next_part:
 	/* shorten the remaining extent to update progress */
 	map->m_llen = offset + cur - map->m_la;
-- 
2.35.1



