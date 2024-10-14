Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64B81B4F31;
	Mon, 14 Oct 2024 15:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918152; cv=none; b=rfviT8pOd9CbH3LyQ3aGtYNaYnsWMr7NVpO7Aa3rHp2XcH2wTsaj9Hvl9lQgUcJQUE0ydl0nJhlBq5sTu/oZoIs7Y2vjJNfpx01yF4AnJXIY0GW+ie16qq3F0CjFfq9+7k40ccsfEV6u2o7EQRG87i0SPCEV5ZI/izv8StP+A1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918152; c=relaxed/simple;
	bh=Y9LG5m+EGE3ZS6N7ePZrOS9ajVgSrvlnzf0p7bkfPuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rl3DhSPQYJ7coDeE8RJXN+k+q81AuTynMWi4DIDjk0Tg6u3gq/EqvTMTjt8e3TJEIBWQEZ3vuAtBMoXncGPu7DqkSNFBCBaPKVmKUZWZkceMARhvvCQAEsih3KMPEmwFRuvSQtVSg3euCzNLIe1p33M4Hk4u+VBe+sdiFhTpeEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGyikMDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGyikMDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31997C4CEC3;
	Mon, 14 Oct 2024 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918152;
	bh=Y9LG5m+EGE3ZS6N7ePZrOS9ajVgSrvlnzf0p7bkfPuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGyikMDI1VUUzcGXe+x1EYrx+6WJLGJbBn1KlIL2WiZjMrrEK6TtZZHbd+W3Y4gdr
	 /RSPobUTbb+1iltAp63Xiw8J07mTDBxGEZaLxb+gLcKcQOoDvs+652rJF5eyNYsD5E
	 DCZ4YZn/tdKaLDmvy60Hdi2yapi79+kZEI2EHGxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 239/798] f2fs: fix to wait page writeback before setting gcing flag
Date: Mon, 14 Oct 2024 16:13:13 +0200
Message-ID: <20241014141227.308790403@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit a4d7f2b3238fd5f76b9e6434a0bd5d2e29049cff ]

Soft IRQ				Thread
- f2fs_write_end_io
					- f2fs_defragment_range
					 - set_page_private_gcing
 - type = WB_DATA_TYPE(page, false);
 : assign type w/ F2FS_WB_CP_DATA
 due to page_private_gcing() is true
  - dec_page_count() w/ wrong type
  - end_page_writeback()

Value of F2FS_WB_CP_DATA reference count may become negative under above
race condition, the root cause is we missed to wait page writeback before
setting gcing page private flag, let's fix it.

Fixes: 2d1fe8a86bf5 ("f2fs: fix to tag gcing flag on page during file defragment")
Fixes: 4961acdd65c9 ("f2fs: fix to tag gcing flag on page during block migration")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f03320c47c823..c9f0bb8f8b210 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2749,6 +2749,8 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 				goto clear_out;
 			}
 
+			f2fs_wait_on_page_writeback(page, DATA, true, true);
+
 			set_page_dirty(page);
 			set_page_private_gcing(page);
 			f2fs_put_page(page, 1);
@@ -4108,6 +4110,8 @@ static int redirty_blocks(struct inode *inode, pgoff_t page_idx, int len)
 		/* It will never fail, when page has pinned above */
 		f2fs_bug_on(F2FS_I_SB(inode), !page);
 
+		f2fs_wait_on_page_writeback(page, DATA, true, true);
+
 		set_page_dirty(page);
 		set_page_private_gcing(page);
 		f2fs_put_page(page, 1);
-- 
2.43.0



