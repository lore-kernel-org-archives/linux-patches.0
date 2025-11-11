Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AED026E158;
	Tue, 11 Nov 2025 01:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824351; cv=none; b=QEVFNYufEL5fGkf7hCCYK7KOYAZbPiJkb1gnka1vm9ZB55/kpMfAiXK1JE9p41KgjnPf2ongZNw1V0hyIWt5vOHBsRM/ImHM3/n5RBPt/C4t+/NXhsqVULeuW8dLD9UOES0n3TsqtP03P8I9jVbQ50LugbH2Wx+KSkbHdzxvzV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824351; c=relaxed/simple;
	bh=xbJNB479zV5BE+fbsk3ezV1XJS5dinz1KyzaUJodJW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fo7OwOuMVW5wRyqorotjEJmZAHXWWKeVZRzYQtttwfOmQgqUki2yzt7okimB6sK1408GRv9HH0v8IgnoTcczLBmOQsxHi6A/924xRrElz8TQK8zgxGNQFmnsEfZlQSsf/yiaQ+4C2rsZWrhOyMwsRPu5DTETsadOrh1ouutsu5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SB8l/vwp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SB8l/vwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7504C16AAE;
	Tue, 11 Nov 2025 01:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824351;
	bh=xbJNB479zV5BE+fbsk3ezV1XJS5dinz1KyzaUJodJW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SB8l/vwpLLXGPQJy5TkGpvYhZ43FfgYSu0lMh/x98oQNtzTg4zg+uSED4/Gh+FleK
	 YNy814afAMVFrlu/yCkcD+AQPI+dICJis5t6jTKw4iCZfDyusVR0eBICoRdzzxNpJA
	 sMgzIMrGodiu8ph9nGl0MQ9rR0/0F5gUM2ZeWYHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chuguangqing <chuguangqing@inspur.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 427/565] fs: ext4: change GFP_KERNEL to GFP_NOFS to avoid deadlock
Date: Tue, 11 Nov 2025 09:44:43 +0900
Message-ID: <20251111004536.472716224@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5ddfa4801bb30..ce986312bf685 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1552,7 +1552,7 @@ ext4_xattr_inode_cache_find(struct inode *inode, const void *value,
 	WARN_ON_ONCE(ext4_handle_valid(journal_current_handle()) &&
 		     !(current->flags & PF_MEMALLOC_NOFS));
 
-	ea_data = kvmalloc(value_len, GFP_KERNEL);
+	ea_data = kvmalloc(value_len, GFP_NOFS);
 	if (!ea_data) {
 		mb_cache_entry_put(ea_inode_cache, ce);
 		return NULL;
-- 
2.51.0



