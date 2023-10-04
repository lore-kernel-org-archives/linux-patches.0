Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1171D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuhtDghd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F0CC433C7;
	Wed,  4 Oct 2023 18:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443353;
	bh=qtLvpfoXZJff4yTr17Uq5ukIl/0Ako8U7c0D6dlT2d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuhtDghdlfvHQ/rxuckvZZAXYEXCaiXMOQoLgm4KZr8jY4Dtbo+uBXajN1CapfJlk
	 iisE5n7vSQlnnbW5414aT7cpm6KLtRlxaGlBp2ufkPfDavQ/r6kfLkPeE7uA+ptHjU
	 9N1rtrmKfoQDOtSXWU+tzXQJ+SHAc4XuNEcfsWeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/259] f2fs: get out of a repeat loop when getting a locked data page
Date: Wed,  4 Oct 2023 19:54:31 +0200
Message-ID: <20231004175221.842823873@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit d2d9bb3b6d2fbccb5b33d3a85a2830971625a4ea ]

https://bugzilla.kernel.org/show_bug.cgi?id=216050

Somehow we're getting a page which has a different mapping.
Let's avoid the infinite loop.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 0faed0575f8aa..a982f91b71eb2 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1329,18 +1329,14 @@ struct page *f2fs_get_lock_data_page(struct inode *inode, pgoff_t index,
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct page *page;
-repeat:
+
 	page = f2fs_get_read_data_page(inode, index, 0, for_write, NULL);
 	if (IS_ERR(page))
 		return page;
 
 	/* wait for read completion */
 	lock_page(page);
-	if (unlikely(page->mapping != mapping)) {
-		f2fs_put_page(page, 1);
-		goto repeat;
-	}
-	if (unlikely(!PageUptodate(page))) {
+	if (unlikely(page->mapping != mapping || !PageUptodate(page))) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
-- 
2.40.1



