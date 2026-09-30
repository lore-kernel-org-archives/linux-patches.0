Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9713D4118;
	Wed, 30 Sep 2026 19:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794925; cv=none; b=VKVGei0Cj7LvKQirbUr/FjgNn06KRNCYkCovkgkAYAmBZsXI0wcJPngbCD2W8kJqbDnnDpArOjDdVsZLgXJqNc1Js1v472peeIB8T7EYitI2Eoz22g1fi3f9MqY1J+ukRxt5B2Sfi9hKWqfwTIJCjLM4hczVVFA6rvSvKBiqVJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794925; c=relaxed/simple;
	bh=U/rjqVLrj+dAiZaq/XLmy0o86F95uvkgGbfvDRehLc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXyCVBiQupBxvXfqYZ5vKeLLZTMr2NvuEELW7i7E3kC0aUQnBqTHqgGGv9z6YyQSLmIo0N5Bncz/t2z8ZBQ4J5o0Vh5vSCPAO6jaVgHYHMiYJwvARVfXZ81//X31sjQr593m2J9UitjovA6aayfsL4aflWUeLMWxRnzSrptkDWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVXfwbhx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVXfwbhx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622DF1F00898;
	Wed, 30 Sep 2026 19:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794923;
	bh=M1Ul+Z/uAKo5Do82kq777frd08KO1Qt1HQ4VgTb20Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVXfwbhxh2vwBomPQ2U/1X/xFhxlbrsQlKq/5lKuPIq7NkdOteS734yaU6nEh1fqn
	 2SwH0hKwbksbXGeLhex8xb/Ujry6DW9Gs64V967XN1hbE5Oelo4NxY/H1XiC3tp94Z
	 sVp59a9H8KnOpZtEODhdvOBt5VzKerEVIuufdPHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0382/1193] ufs: Convert ufs_get_page() to use a folio
Date: Wed, 30 Sep 2026 17:17:46 +0200
Message-ID: <20260930152442.673030821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit bf9883d5779117776c2e25d29d4dfed31d390fb2 ]

Remove a call to read_mapping_page().

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 08edfb34ee9c ("ufs: do not treat unreadable directory blocks as empty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ufs/dir.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 27c85d92d1dc5..3f9ffc0c73739 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -195,18 +195,19 @@ static bool ufs_check_page(struct page *page)
 static struct page *ufs_get_page(struct inode *dir, unsigned long n)
 {
 	struct address_space *mapping = dir->i_mapping;
-	struct page *page = read_mapping_page(mapping, n, NULL);
-	if (!IS_ERR(page)) {
-		kmap(page);
-		if (unlikely(!PageChecked(page))) {
-			if (!ufs_check_page(page))
-				goto fail;
-		}
+	struct folio *folio = read_mapping_folio(mapping, n, NULL);
+
+	if (IS_ERR(folio))
+		return &folio->page;
+	kmap(&folio->page);
+	if (unlikely(!folio_test_checked(folio))) {
+		if (!ufs_check_page(&folio->page))
+			goto fail;
 	}
-	return page;
+	return &folio->page;
 
 fail:
-	ufs_put_page(page);
+	ufs_put_page(&folio->page);
 	return ERR_PTR(-EIO);
 }
 
-- 
2.53.0



