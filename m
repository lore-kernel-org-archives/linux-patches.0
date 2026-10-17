Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6E43A7F41;
	Sat, 17 Oct 2026 17:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257887; cv=none; b=oER3fEk245RUHdh1NEO8RCUEq5NjyVnQ0xdR+Ch8EeP10DHytwHvdiJREsGRf5E4xuTxjVTTS9WTGKFi1g9eO19pL3G9rI+WWEn2gs8GdGgJSEtEqAuw865b6p1RbI1lQCeyly6JIfaJMRLopKLmjPNVs3+Dzwr8nD1VuCW7ZL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257887; c=relaxed/simple;
	bh=oUc1cG5oobjQfYeWR1Y/RTPTBVNYsvICC71E2XucNqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWwitbRZfkWke+XW7wd9tO02Yo4EwChiX3f6cGywWzdBUxOI1QK8KbKbTW6zB307BhrCWnqBU5SC68iQFlfHcg3wMsDsSL7N4dp4lc6uMZWdhleicg6e4XvnCNWzK0bdankqIAJ8PdLm+TN9wSLODolFTdY0diwj9yBa9OqjboQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuU+eIjV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuU+eIjV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C1F1F000C4;
	Sat, 17 Oct 2026 17:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257886;
	bh=9Mh3cvZ67sgH2XXmHKyqvgIG0wDMsYKD2ttGN/LYUt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QuU+eIjVuZdQtevnWKSyzHRzQA2gaOfm7imMVE53t/7uCjlTNBZd7a6HHq92kZDp6
	 q8JIxWIf/J+aC47QYMzvMkS3BhFN+/d863hmw0+EoYhR1RtR+ahpxxldFgJYw2Tuq3
	 mtPW4S9SgbfClvvmkpOjdmfJdetBqHZq8OFHI/Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0700/1674] f2fs: convert f2fs_handle_page_eio() to use folio
Date: Sat, 17 Oct 2026 17:49:32 +0200
Message-ID: <20261017160449.073571061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit 763a0dc792f9d7c79c1d85415c6cebc1f79bba16 ]

Convert to use folio, so that we can get rid of 'page->index' to
prepare for removal of 'index' field in structure page [1].

[1] https://lore.kernel.org/all/Zp8fgUSIBGQ1TN0D@casper.infradead.org/

Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 3147ee567dd9 ("f2fs: fix potential deadloop in prepare_compress_overwrite()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 2 +-
 fs/f2fs/f2fs.h       | 6 ++++--
 fs/f2fs/node.c       | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index c629b5580b724..74bdce66f866d 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -99,7 +99,7 @@ static struct page *__get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index,
 	}
 
 	if (unlikely(!PageUptodate(page))) {
-		f2fs_handle_page_eio(sbi, page->index, META);
+		f2fs_handle_page_eio(sbi, page_folio(page), META);
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8f399d5d7dbc8..d0d5bb469d8d8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4718,9 +4718,11 @@ static inline void f2fs_io_schedule_timeout(long timeout)
 	io_schedule_timeout(timeout);
 }
 
-static inline void f2fs_handle_page_eio(struct f2fs_sb_info *sbi, pgoff_t ofs,
-					enum page_type type)
+static inline void f2fs_handle_page_eio(struct f2fs_sb_info *sbi,
+				struct folio *folio, enum page_type type)
 {
+	pgoff_t ofs = folio->index;
+
 	if (unlikely(f2fs_cp_error(sbi)))
 		return;
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 586a90643ddd2..e7a0a841bd689 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1519,7 +1519,7 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 out_put_err:
 	/* ENOENT comes from read_node_page which is not an error. */
 	if (err != -ENOENT)
-		f2fs_handle_page_eio(sbi, page->index, NODE);
+		f2fs_handle_page_eio(sbi, page_folio(page), NODE);
 	f2fs_put_page(page, 1);
 	return ERR_PTR(err);
 }
-- 
2.53.0



