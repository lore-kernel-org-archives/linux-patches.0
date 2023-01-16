Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFB14C83
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22756C433D2;
	Mon, 16 Jan 2023 16:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886780;
	bh=Al9B5woCyN4vPNuoYSpJTVd27cmI97/a3CPKo+rilBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xkmKXKnDpUELgXz8FvGFwQwqg6UH/OejUYMUiyWWQ4dVWTBnmR9xC7+oGdWPrRtCx
	 ZHmpAoK9HyOqerI/CiVeeD5uRWMsUEwYSnsESwJQLVq94FHWziOOu1cA1t1haPh406
	 xBKNbetrs5QEipsfoxB2AJ/RmbZUC/3V0X8bRQb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuqi Zhang <zhangshuqi3@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 560/658] ext4: use kmemdup() to replace kmalloc + memcpy
Date: Mon, 16 Jan 2023 16:50:48 +0100
Message-Id: <20230116154935.111925421@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuqi Zhang <zhangshuqi3@huawei.com>

[ Upstream commit 4efd9f0d120c55b08852ee5605dbb02a77089a5d ]

Replace kmalloc + memcpy with kmemdup()

Signed-off-by: Shuqi Zhang <zhangshuqi3@huawei.com>
Reviewed-by: Ritesh Harjani <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20220525030120.803330-1-zhangshuqi3@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a44e84a9b776 ("ext4: fix deadlock due to mbcache entry corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0081eab74b20..8f0e8b60ea20 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1907,11 +1907,10 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 			unlock_buffer(bs->bh);
 			ea_bdebug(bs->bh, "cloning");
-			s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
+			s->base = kmemdup(BHDR(bs->bh), bs->bh->b_size, GFP_NOFS);
 			error = -ENOMEM;
 			if (s->base == NULL)
 				goto cleanup;
-			memcpy(s->base, BHDR(bs->bh), bs->bh->b_size);
 			s->first = ENTRY(header(s->base)+1);
 			header(s->base)->h_refcount = cpu_to_le32(1);
 			s->here = ENTRY(s->base + offset);
-- 
2.35.1



