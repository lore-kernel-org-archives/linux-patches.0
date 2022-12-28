Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF451863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ED7C43392;
	Wed, 28 Dec 2022 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240865;
	bh=JHzCgzUwCvXaMBV1VYxxeHav3suYjsRw21mC/+XbepA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8AR5V0iJOWCDyiySHUTMN//WWKIldmW5kwjbXbvy6M9YkOUWKcCGrLw+5duL7Hj2
	 MvQuQ8BfB1/XXXGjOPz+GHi74fbzccDYdwlj6Xfgxqdl5MFhRunBSs0qUrq5PNmakg
	 hkqQ7fcY3YX9umd8TltRg6Gszg1kl2Eqj103WE7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0176/1146] erofs: fix missing unmap if z_erofs_get_extent_compressedlen() fails
Date: Wed, 28 Dec 2022 15:28:35 +0100
Message-Id: <20221228144334.936474846@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit d5d188b8f8b38d3d71dd05993874b4fc9284ce95 ]

Otherwise, meta buffers could be leaked.

Fixes: cec6e93beadf ("erofs: support parsing big pcluster compress indexes")
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221205150050.47784-1-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index 0bb66927e3d0..f49295b9f2e1 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -694,7 +694,7 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 		map->m_pa = blknr_to_addr(m.pblk);
 		err = z_erofs_get_extent_compressedlen(&m, initial_lcn);
 		if (err)
-			goto out;
+			goto unmap_out;
 	}
 
 	if (m.headtype == Z_EROFS_VLE_CLUSTER_TYPE_PLAIN) {
@@ -718,14 +718,12 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 		if (!err)
 			map->m_flags |= EROFS_MAP_FULL_MAPPED;
 	}
+
 unmap_out:
 	erofs_unmap_metabuf(&m.map->buf);
-
-out:
 	erofs_dbg("%s, m_la %llu m_pa %llu m_llen %llu m_plen %llu m_flags 0%o",
 		  __func__, map->m_la, map->m_pa,
 		  map->m_llen, map->m_plen, map->m_flags);
-
 	return err;
 }
 
-- 
2.35.1



