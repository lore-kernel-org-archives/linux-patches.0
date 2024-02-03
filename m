Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E3710A31;
	Sat,  3 Feb 2024 04:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933747; cv=none; b=BItSxj/43lo8FOfoT0DFFyrNwM/DpetiWSnnBg2N4Lw+5O6oUUUN7spBNE8cB6x62tfyL57IPsu4EegfNuGo2nn0z60bSnOHzXEX99q8HEfN1K73MeiQW8h17pLL3w5XkUpGLoNTHBDDb6nxDjgHzQ2Lp3JXCAw9yzwuaPGQdG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933747; c=relaxed/simple;
	bh=k+c1H1hS1Aa+YNRnvVabVXwJ/ZiFKjPD9QJWssI30p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbQjaPAQo9wXZ5Y3eZaJnu0lFNH87vjqj4AZF8+tC+dEcFbiJVfVUV6xMz/Sgi/4tvKtVZgoaQmfwAxoLCAA6tuuWoSUj3YvlPzXRn9rvhxwgYldOFeoctN5GixO7bun5wBms1dMT7u+LmFQD+KyTaD4Mj5pMhbcJkqfkHX7soM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfJlcTAD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfJlcTAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4956FC433F1;
	Sat,  3 Feb 2024 04:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933747;
	bh=k+c1H1hS1Aa+YNRnvVabVXwJ/ZiFKjPD9QJWssI30p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfJlcTADO8vrnwmqiiwtCgEDY2lkpemZJ3ipRRGH5PZUD87d0I2VUqkuGUnX2Z4t+
	 ro6LCcG//8+7WSLQiLoyPL1laeSWicsyFJCvw4qtxaXhEdVACohDfgc6+IjMjCAlJK
	 ZH7Qejj32nHioj4hNcuP61eGR+Caw049HKXA+dgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 041/353] erofs: fix ztailpacking for subpage compressed blocks
Date: Fri,  2 Feb 2024 20:02:39 -0800
Message-ID: <20240203035405.105024752@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit e5aba911dee5e20fa82efbe13e0af8f38ea459e7 ]

`pageofs_in` should be the compressed data offset of the page rather
than of the block.

Acked-by: Chao Yu <chao@kernel.org>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20231214161337.753049-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index a33cd6757f98..1c0e6167d8e7 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -815,7 +815,6 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 
 	if (ztailpacking) {
 		pcl->obj.index = 0;	/* which indicates ztailpacking */
-		pcl->pageofs_in = erofs_blkoff(fe->inode->i_sb, map->m_pa);
 		pcl->tailpacking_size = map->m_plen;
 	} else {
 		pcl->obj.index = map->m_pa >> PAGE_SHIFT;
@@ -893,6 +892,7 @@ static int z_erofs_pcluster_begin(struct z_erofs_decompress_frontend *fe)
 		}
 		get_page(map->buf.page);
 		WRITE_ONCE(fe->pcl->compressed_bvecs[0].page, map->buf.page);
+		fe->pcl->pageofs_in = map->m_pa & ~PAGE_MASK;
 		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
 	}
 	/* file-backed inplace I/O pages are traversed in reverse order */
-- 
2.43.0



