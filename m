Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92B222301;
	Thu, 16 Jul 2026 13:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210348; cv=none; b=LkTgNQUybh0D897mv+rVnfjmY7+UcBhwv7nZxQ0nNDcyyRr3QliL424TtzH4fx2fLAZhjxkxH1WoeSdtAmYg2ibilJzgy1ZhlmZGmcIgkg3GQGc0EZXEKVkRiOJStY0CPG7J+2QhvVVxyF5Yt1qNrY0gMVoCJSdRb8Hoau+6wcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210348; c=relaxed/simple;
	bh=5lyApN1bAcBRmVZuDvf10hq8PZbLCUM3h5IJLE9dhbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWvDoHMSsoIweRwLonrB+w4PiCNgNOcbMNtsKOBQlf0klTeTLj5MvGl8M8gGc+fX38F3Awrs5TtVOKhfGG3lP+AnyXm5WzrZZYweLe3pdAmPD4UUivHwPcGHkEGI0AMVCbe6R8sfEbac4wklOTCXLHoHCOjWDc2Vi/y3lXT8ytE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxWeGJi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxWeGJi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2701F000E9;
	Thu, 16 Jul 2026 13:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210347;
	bh=icyhJgobSYP4zvv438DUlD+7NlK3W58oDWXnOO+6mNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wxWeGJi7/wRD1zITAXBchmt9iG7iqcKx5G3xgZfaD7/g4t7dG7mw5Tj4ZFpb3ez6B
	 Ec8ESQ6tF4Qrud6CTxBqZM8g1yfZDvm0wd8WgPi3jbRMa26j0q7M1Z7lqXTK0qdQMC
	 7R5PdYXHk3oJ0P1vX61+iM9lwKtLsekGwqi3kVp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Keshav Verma <iganschel@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/480] f2fs: fix listxattr handling of corrupted xattr entries
Date: Thu, 16 Jul 2026 15:26:01 +0200
Message-ID: <20260716133044.999223574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keshav Verma <iganschel@gmail.com>

[ Upstream commit 5ef5bc304f23c3fe255d4936472378dcb74d0e94 ]

Validate the xattr entry before reading its fields in f2fs_listxattr().
Return -EFSCORRUPTED when the entry is outside the valid xattr storage
area instead of returning a successful partial result.

Fixes: 688078e7f36c ("f2fs: fix to avoid memory leakage in f2fs_listxattr")
Cc: stable@kernel.org
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Keshav Verma <iganschel@gmail.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/xattr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -581,8 +581,6 @@ ssize_t f2fs_listxattr(struct dentry *de
 		size_t prefix_len;
 		size_t size;
 
-		prefix = f2fs_xattr_prefix(entry->e_name_index, dentry);
-
 		if ((void *)(entry) + sizeof(__u32) > last_base_addr ||
 			(void *)XATTR_NEXT_ENTRY(entry) > last_base_addr) {
 			f2fs_err(F2FS_I_SB(inode), "list inode (%lu) has corrupted xattr",
@@ -590,9 +588,11 @@ ssize_t f2fs_listxattr(struct dentry *de
 			set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_FSCK);
 			f2fs_handle_error(F2FS_I_SB(inode),
 						ERROR_CORRUPTED_XATTR);
-			break;
+			error = -EFSCORRUPTED;
+			goto cleanup;
 		}
 
+		prefix = f2fs_xattr_prefix(entry->e_name_index, dentry);
 		if (!prefix)
 			continue;
 


