Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366F4AD5A;
	Tue, 27 May 2025 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364377; cv=none; b=TK04T2fU6nlLAiQzhY4Zl2J/RAFS5UKpmTxF4JT/8PoRVsvuSU0WYqPqjMG6jvhWy7pmUXnuVhBozyY9P5tWc9UuIFAQ86qgxh5UsIoELvd2A8vJDkR/hNwDJ/5QLaUz5eO6uVoBosICdfc/Nf8PEEYliCzdVyzisjvoQHYjTbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364377; c=relaxed/simple;
	bh=E4CJ7rnyudbAaTs6EWAkiX5Om6Lh4qB3nTqXegiM2Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxRomKNi96HgHY3ooyH3fcW/Ysk6RicEQtxdch6r7AcqUeQfNBsh5db+t5vwlMGmULjoOwpZH+Ycby+5OABZKATUY758wzIChkOoU9hpVXRcAz6/yF9K1VxxW69av9Mlvbk8MJ7AFH7dYtGTZBg4rmW1rV7R8Hco+bWc61J/8W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxbP1E19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxbP1E19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A56EC4CEEF;
	Tue, 27 May 2025 16:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364375;
	bh=E4CJ7rnyudbAaTs6EWAkiX5Om6Lh4qB3nTqXegiM2Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxbP1E19Lg5XXlHsMHu1u+6AL6GgiO/+qyP3+gLDg/k7sgQ6arhf48srPjNvRL/N7
	 zX3BfRospD9x98OFnxVQOiwYT9FL8M0pYXaMbaFTeaO1y5FcL0kZrRwUxrqrLeBa0x
	 +Tmdk5NmNDYk5V9xKf1jIn0TYEyA9YgDgISdjvAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Davidlohr Bueso <dave@stgolabs.net>,
	kdevops@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/626] fs/ext4: use sleeping version of sb_find_get_block()
Date: Tue, 27 May 2025 18:18:49 +0200
Message-ID: <20250527162446.534226384@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 6e8f57fd09c9fb569d10b2ccc3878155b702591a ]

Enable ext4_free_blocks() to use it, which has a cond_resched to begin
with. Convert to the new nonatomic flavor to benefit from potential
performance benefits and adapt in the future vs migration such that
semantics are kept.

Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://kdevops.org/ext4/v6.15-rc2.html # [0]
Link: https://lore.kernel.org/all/aAAEvcrmREWa1SKF@bombadil.infradead.org/ # [1]
Link: https://lore.kernel.org/20250418015921.132400-7-dave@stgolabs.net
Tested-by: kdevops@lists.linux.dev
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 92f49d7eb3c00..109cf88e7caac 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -6644,7 +6644,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 		for (i = 0; i < count; i++) {
 			cond_resched();
 			if (is_metadata)
-				bh = sb_find_get_block(inode->i_sb, block + i);
+				bh = sb_find_get_block_nonatomic(inode->i_sb,
+								 block + i);
 			ext4_forget(handle, is_metadata, inode, bh, block + i);
 		}
 	}
-- 
2.39.5



