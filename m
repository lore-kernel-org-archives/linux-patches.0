Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8314179C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0D1C433EF;
	Thu, 12 Jan 2023 14:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534143;
	bh=4wi3KPwd9tikusbCykhfFXGqK7n/QRAG4eEKKh0Lg0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fuPfvQlHdo5tIoq2tTZBG3hIrRxSw07pIQGpZ82/ioRqu3sHckpL9Uyc0HZ6cs/Iv
	 defDhs+BTa1QJ1nmceHF/jD3e8N716ucY4TCI1VDoWbqxdn0rQAgeHJHYH9QI+vLiF
	 p4UHAkEDmUtf/v0X5RAmi6ZYPXeAhURtdKlZ8J2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 710/783] ext4: use memcpy_to_page() in pagecache_write()
Date: Thu, 12 Jan 2023 14:57:06 +0100
Message-Id: <20230112135557.282638845@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit bd256fda92efe97b692dc72e246d35fa724d42d8 ]

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Link: https://lore.kernel.org/r/20210207190425.38107-7-chaitanya.kulkarni@wdc.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 956510c0c743 ("fs: ext4: initialize fsdata in pagecache_write()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/verity.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 35be8e7ec2a0..130070ec491b 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -80,7 +80,6 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
 		void *fsdata;
-		void *addr;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
@@ -88,9 +87,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		if (res)
 			return res;
 
-		addr = kmap_atomic(page);
-		memcpy(addr + offset_in_page(pos), buf, n);
-		kunmap_atomic(addr);
+		memcpy_to_page(page, offset_in_page(pos), buf, n);
 
 		res = pagecache_write_end(NULL, inode->i_mapping, pos, n, n,
 					  page, fsdata);
-- 
2.35.1



