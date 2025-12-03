Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A2E368278;
	Wed,  3 Dec 2025 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779441; cv=none; b=icNg/P/tbeSIOHsGUAq4/PaUDJ4fz0oCu6u161dYZkNxPeCLGGnErcdaQwDYDzkmbFgyeKrJpLZi8r3P2eAHOcY7Exv2uXoBZ9wU7B5enVnrGrgLnkANhacTIT8XyRLTNBasBQ5rHJjreDPSTMxVCFDwvNyjkz8Ret+PMxsdpl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779441; c=relaxed/simple;
	bh=tKs0GSq4G62hOka/Mmg9hfHQm6eshf3iSbK7KoB5D/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=alS3HYNNe2Gu6lIGbw29Z0SP0kkmZirIPhFpdIQeBfjdFAa8+Bks4rkyu5eVmh6Xt/5XIWXT9S3eqLOM88b9dqzeyFBzcYxITAN+EZC7zs6PTbFbEeacuDIqMo32G5r2M3TilqI0Pdh3OGw0jZYxHEjs6yz7VnLYYeN1X/tAJ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtzTdlSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtzTdlSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40112C4CEF5;
	Wed,  3 Dec 2025 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779441;
	bh=tKs0GSq4G62hOka/Mmg9hfHQm6eshf3iSbK7KoB5D/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtzTdlScyIfmhKCaHq+UhW4VyXLJ1usNlWJte+UlbVWRbmY4RlMnsYjTkzpoSekDc
	 e7TpPNN8iBtY8x/6FWhDhHdO2po8DMMasQe8LxsLcGeFzN7AtOeUIir3WqoFhMS9hb
	 EN5w9ExQK3+/WH3LIkkoxqvejgxEkjrs0zHItZmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chuguangqing <chuguangqing@inspur.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 259/568] fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock
Date: Wed,  3 Dec 2025 16:24:21 +0100
Message-ID: <20251203152450.205702555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e6de83037d62f..226c48aa75b57 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1499,7 +1499,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 	WARN_ON_ONCE(ext4_handle_valid(journal_current_handle()) &&
 		     !(current->flags & PF_MEMALLOC_NOFS));
 
-	ea_data = kvmalloc(value_len, GFP_KERNEL);
+	ea_data = kvmalloc(value_len, GFP_NOFS);
 	if (!ea_data) {
 		mb_cache_entry_put(ea_inode_cache, ce);
 		return NULL;
-- 
2.51.0



