Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2099B641;
	Tue, 16 Jul 2024 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144366; cv=none; b=JyY0sYyA/ZK+9SjlWphNMg4PRqoEDr2vrPpsmkd1vcXLy/b1djuAmb+ncGO/GOiHPMIBHYNl+DxggchMV573WiyomN2Pa+5O199AblSyNlqC9DlewepIXqiJUS/lUZrMvAkMk/CB3fE0XzAQ1t1eTCOOm4zhOE9yxRAnfwBPnYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144366; c=relaxed/simple;
	bh=0408nMAZnSQpR5yeNXjzB5HrWqZ6IHq0Ftl8sKTa55M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oel0NNhqMEeqOGIYCy+P68VIzh19EA/0+LPpOOfl2xtAbNRIxNPM+rXF438uedgkcRp9Gtxqtg78SjmpkqL3bVrv2r8dpHl2pJMyI1w2rLrd0unaWt4W7zek8ZK3blOrybPJl8NfHuoknKa81YAbdxMyI3RzEHqnV9QaUUBiB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9kxOYJq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9kxOYJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB40C116B1;
	Tue, 16 Jul 2024 15:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144366;
	bh=0408nMAZnSQpR5yeNXjzB5HrWqZ6IHq0Ftl8sKTa55M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9kxOYJqyndyq67HnXX6IaQLInWW/Q/UvOgPQKf6dLkvVVNE5hjhMlqnCmIXskvp4
	 PYBg63OLQWQx6UJ6oN/SauGAZcy2+tP2CgaHM2oZGLQYodOyefmIG4YiBkWsGe48Cn
	 gi5ub7wRm/onJQ/z528T4oMshaEx5qN8F/kyr5qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/78] fs/dcache: Re-use value stored to dentry->d_flags instead of re-reading
Date: Tue, 16 Jul 2024 17:31:19 +0200
Message-ID: <20240716152742.460047420@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 43864a276faa2..9505e5df30b74 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -329,7 +329,7 @@ static inline void __d_clear_type_and_inode(struct dentry *dentry)
 	flags &= ~(DCACHE_ENTRY_TYPE | DCACHE_FALLTHRU);
 	WRITE_ONCE(dentry->d_flags, flags);
 	dentry->d_inode = NULL;
-	if (dentry->d_flags & DCACHE_LRU_LIST)
+	if (flags & DCACHE_LRU_LIST)
 		this_cpu_inc(nr_dentry_negative);
 }
 
-- 
2.43.0



