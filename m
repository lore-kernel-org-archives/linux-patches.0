Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0784D881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46744C433D2;
	Fri, 10 Mar 2023 14:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459311;
	bh=8E18eDaXP2YlRI1Uu/mmTr15LUGEm2IV5/DEGOX4k34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d2cM1qT0nrnFxbP9eQc5qzL2WVA78QlYiLyb4JAtQH6HkQCmEVs/5YlCHShVo29xW
	 2hQYa7dR1dzOm36hdlqkSh3Q9+4PBgI15AbphohsZizkWfeILza6ueETVr8G83/2C/
	 6UI80yFi3a56IjzBXPnUx/Vur4acf3vb/mHggV7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Eric Biggers <ebiggers@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 289/357] fs: f2fs: initialize fsdata in pagecache_write()
Date: Fri, 10 Mar 2023 14:39:38 +0100
Message-Id: <20230310133747.506954825@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Potapenko <glider@google.com>

[ Upstream commit b1b9896718bc1a212dc288ad66a5fa2fef11353d ]

When aops->write_begin() does not initialize fsdata, KMSAN may report
an error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Suggested-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/verity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index e5a47782a97ef..c4bd5a1542524 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -76,7 +76,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
-- 
2.39.2



