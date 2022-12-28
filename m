Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFB31863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6C4C433D2;
	Wed, 28 Dec 2022 15:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240510;
	bh=f+rHpImTe65IwVNgLnQzC+g1RxqXej7c64UAOJr3mug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypQNkCV5Zg9LYVWjPTrOJgaHhA2jcWDRaIyckLvOYAaRXt/8RslBYsAdGfSaHt4hL
	 i75DUXmbso5TgF0S4KsUD1qN2QFKwGdCDGnOgekLOlnzZl8HhuAZv+334bSXap3+PC
	 ETP+jrVnz4RwZeyWc3z80oEEtnIc5SgHeg7P0doM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2ae90e873e97f1faf6f2@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0169/1073] erofs: validate the extent length for uncompressed pclusters
Date: Wed, 28 Dec 2022 15:29:17 +0100
Message-Id: <20221228144332.605389396@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit c505feba4c0d76084e56ec498ce819f02a7043ae ]

syzkaller reported a KASAN use-after-free:
https://syzkaller.appspot.com/bug?extid=2ae90e873e97f1faf6f2

The referenced fuzzed image actually has two issues:
 - m_pa == 0 as a non-inlined pcluster;
 - The logical length is longer than its physical length.

The first issue has already been addressed.  This patch addresses
the second issue by checking the extent length validity.

Reported-by: syzbot+2ae90e873e97f1faf6f2@syzkaller.appspotmail.com
Fixes: 02827e1796b3 ("staging: erofs: add erofs_map_blocks_iter")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20221205150050.47784-2-hsiangkao@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index a2a44c11bb64..720d74b5c699 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -677,6 +677,11 @@ static int z_erofs_do_map_blocks(struct inode *inode,
 	}
 
 	if (m.headtype == Z_EROFS_VLE_CLUSTER_TYPE_PLAIN) {
+		if (map->m_llen > map->m_plen) {
+			DBG_BUGON(1);
+			err = -EFSCORRUPTED;
+			goto unmap_out;
+		}
 		if (vi->z_advise & Z_EROFS_ADVISE_INTERLACED_PCLUSTER)
 			map->m_algorithmformat =
 				Z_EROFS_COMPRESSION_INTERLACED;
-- 
2.35.1



