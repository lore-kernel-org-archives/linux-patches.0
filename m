Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DCB27733;
	Tue, 16 Jul 2024 15:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144851; cv=none; b=kAHEAUW/yblo4tTxu/ljtEKkYcF9BKoDpJahauer9W1OxfSAnDkf8lpxMYbX9V+kacqiS5mPf3uDLB1l9iTXrDkzILs+liJeikFELQLhsdg6deMsBowQhrVD1b2hIaidGIkZFUUMRiai5/R829DSTb1f0J9Yc5W1k+JOgLrrzXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144851; c=relaxed/simple;
	bh=9P1x7CkPIjY+6Kpva47PqFqfb3b6QLYOaWQThijSy8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoaQDfBxsaOllIdauLiuEMCr+dLIZ/4oTNVXHID5PUe5feA5Q08I4XbGPyuh/bixlb/DjPAGFEiWjzoP5HTGfAaE7f0LVZIzjwS/nE9zjPHimSNZEERO62RXI72QYPCSx8aohsGSXCXBr+3oGem7hunC28RetlY+cPGEQuI1D0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TN8yNoRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TN8yNoRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC74C116B1;
	Tue, 16 Jul 2024 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144851;
	bh=9P1x7CkPIjY+6Kpva47PqFqfb3b6QLYOaWQThijSy8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TN8yNoRKBAqJmNmBs896SAA2ZCrCkDxIPRnuuacD0iPUlTjaDlCUM3VhWLIoSUIgp
	 BRdq3s8R32InbkC4pTvfpAUz82GZiSCIxTuvjbrdGhCwLJD6XU7a4Q9yzdnxdHQwGD
	 Ol5tDmxUAmPvyOfLEXLRsb6f4+XO9r7jP+KtQpMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 017/143] fs/dcache: Re-use value stored to dentry->d_flags instead of re-reading
Date: Tue, 16 Jul 2024 17:30:13 +0200
Message-ID: <20240716152756.652858343@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: linke li <lilinke99@qq.com>

[ Upstream commit 8bfb40be31ddea0cb4664b352e1797cfe6c91976 ]

Currently, the __d_clear_type_and_inode() writes the value flags to
dentry->d_flags, then immediately re-reads it in order to use it in a if
statement. This re-read is useless because no other update to
dentry->d_flags can occur at this point.

This commit therefore re-use flags in the if statement instead of
re-reading dentry->d_flags.

Signed-off-by: linke li <lilinke99@qq.com>
Link: https://lore.kernel.org/r/tencent_5E187BD0A61BA28605E85405F15228254D0A@qq.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: aabfe57ebaa7 ("vfs: don't mod negative dentry count when on shrinker list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 71a8e943a0fa5..407095188f83a 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -355,7 +355,7 @@ static inline void __d_clear_type_and_inode(struct dentry *dentry)
 	flags &= ~DCACHE_ENTRY_TYPE;
 	WRITE_ONCE(dentry->d_flags, flags);
 	dentry->d_inode = NULL;
-	if (dentry->d_flags & DCACHE_LRU_LIST)
+	if (flags & DCACHE_LRU_LIST)
 		this_cpu_inc(nr_dentry_negative);
 }
 
-- 
2.43.0



