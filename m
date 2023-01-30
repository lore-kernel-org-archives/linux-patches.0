Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A3428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:10:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F26C433EF;
	Mon, 30 Jan 2023 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087839;
	bh=8N3Y5qSC60YSLIWZ5FXaT0Pk2QNwmnPgXL+K2TsiDMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fekfX/2UChZdbVu9WTNEd6OFsCXqQcAQxy4dbTFDvpYs8/KByiKH+IWcTKcgxqFkZ
	 BDiU4AEG8vEFiEUV9VzZQFNyElOJwNUYirjB85/BtKRg52/AK+aSK9iNl7fKG+0hcy
	 bDA0oVtJfXQyCCuzWzOkhRUh5GKqgUVCzpl41hOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/204] affs: initialize fsdata in affs_truncate()
Date: Mon, 30 Jan 2023 14:49:51 +0100
Message-Id: <20230130134317.454176147@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
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

[ Upstream commit eef034ac6690118c88f357b00e2b3239c9d8575d ]

When aops->write_begin() does not initialize fsdata, KMSAN may report
an error passing the latter to aops->write_end().

Fix this by unconditionally initializing fsdata.

Fixes: f2b6a16eb8f5 ("fs: affs convert to new aops")
Suggested-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/affs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/affs/file.c b/fs/affs/file.c
index 75ebd2b576ca..25d480ea797b 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -881,7 +881,7 @@ affs_truncate(struct inode *inode)
 	if (inode->i_size > AFFS_I(inode)->mmu_private) {
 		struct address_space *mapping = inode->i_mapping;
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		loff_t isize = inode->i_size;
 		int res;
 
-- 
2.39.0



