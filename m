Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD56D6FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:53:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A17C433C8;
	Sun, 17 Sep 2023 19:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980436;
	bh=S33edq4/IjUMOqhW+dfkeknk4czdlFWsmC/W88KH/tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bxQ3NWIGS1uMDK3LXKwTo3tMhWw5Ubrn94Ys9HoVSdnRJ0N8AgecIYWDKuGx2em/Y
	 dsg+stOWly0WMPeDtXwCtf/Lz2aIdtShbY7T2EMfdJjTO1TcvUUwntDlOyQMN8x0tw
	 +XvdGk7cLqpPps0gwqqhhO+rHsGqmx8yiDkd7Zco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.5 191/285] f2fs: get out of a repeat loop when getting a locked data page
Date: Sun, 17 Sep 2023 21:13:11 +0200
Message-ID: <20230917191058.211820637@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit d2d9bb3b6d2fbccb5b33d3a85a2830971625a4ea upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=216050

Somehow we're getting a page which has a different mapping.
Let's avoid the infinite loop.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1389,18 +1389,14 @@ struct page *f2fs_get_lock_data_page(str
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


