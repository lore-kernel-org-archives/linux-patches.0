Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513A92E173B;
	Tue, 11 Nov 2025 01:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825061; cv=none; b=YCJ6MD7J0VqaQg9Szg/VB01Td0tWnloKMjMzet9drI7+vAZG1t8GJw5e6KLpQevX2Dh+KTRXPDtb3lDZS7LaIE4hrJWG1t/Edc6ZJP+xrS0sahMa7EWjjr0YC2643UcmiXkUp9tY2Gnuyli7JWgGvJeGoD3kxdn4IZZUPoMsEdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825061; c=relaxed/simple;
	bh=Fb4ORf60/3rsZMlAuzxGNlBbLnWKa+FPwc3g6kTlB0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRahvy7S1NvoOvF67ETTzSZj3tlESs1i68FMrKPIVvH1ho5iRRPiugWeE+ud2d9b3Wj0+TMrJ8Kp+u6igGL6pznBbbZKirjPB+ZGWv1onaQWlC4UwRJ64VaBc5Eyfqt2jkgl66yYvoiy0yzHHu4t1csILK1o0cM/6lkn/ntSDc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RJCvdVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RJCvdVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60DDC4CEF5;
	Tue, 11 Nov 2025 01:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825061;
	bh=Fb4ORf60/3rsZMlAuzxGNlBbLnWKa+FPwc3g6kTlB0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RJCvdVN2CAMdQs5SG8PZKyMSMCnnlw6Ygb7f2F5HwUXRgEIsgPG5SkIZaxEJNpXF
	 4LYe1UhG79020PEtFRCBQStDoZUtdoiQp5DLvKM3AD3617XuLBPQGnz/zrm/ck4URt
	 1ubRGJnJeXsNNS06dKY1+e2R9tPs20VYxZb1ryTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chuguangqing <chuguangqing@inspur.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 644/849] fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock
Date: Tue, 11 Nov 2025 09:43:34 +0900
Message-ID: <20251111004551.998940589@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: chuguangqing <chuguangqing@inspur.com>

[ Upstream commit 1534f72dc2a11ded38b0e0268fbcc0ca24e9fd4a ]

The parent function ext4_xattr_inode_lookup_create already uses GFP_NOFS for memory alloction, so the function ext4_xattr_inode_cache_find should use same gfp_flag.

Signed-off-by: chuguangqing <chuguangqing@inspur.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b0e60a44dae9d..ce7253b3f5499 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1535,7 +1535,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 	WARN_ON_ONCE(ext4_handle_valid(journal_current_handle()) &&
 		     !(current->flags & PF_MEMALLOC_NOFS));
 
-	ea_data = kvmalloc(value_len, GFP_KERNEL);
+	ea_data = kvmalloc(value_len, GFP_NOFS);
 	if (!ea_data) {
 		mb_cache_entry_put(ea_inode_cache, ce);
 		return NULL;
-- 
2.51.0



