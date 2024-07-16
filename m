Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E84D1DDCE;
	Tue, 16 Jul 2024 15:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145268; cv=none; b=SU9npe6eDYecs6SyMdfn/kzDKw6n8/YYyQ+WaOrpHE2kwPQUhIKJA8tzoSZ8yKTq4FvgchdEoQBgboD/5gJzvzw71jTgP0el/2sQx9v8XU1le0+KOC7xaNg7mP63+pcRjoOyBRJH7B5nAzqcPdAbAhsrP3lNyPHJndttZPdqrX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145268; c=relaxed/simple;
	bh=hWoawiR62yJjf563mWI2fa+meGV0NXLDQZaBlO4lfN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIIeP5717spwM0Om2HQiKmQ2JKkT5Oo52hH7FqFAY+aZOEgHhmzZx9l+Qd7fK9KOzxr2a9FwlRfNWRyU8j8vorKUR/OqLoGsMuq2qurHG9IrEQcGAEL7r2r6BSJAy8SQRPD1LyrXBRgA/pDk6ptHZ44kBncMwBFmgFZu/mkff10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDxwjLHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDxwjLHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DBEC116B1;
	Tue, 16 Jul 2024 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145268;
	bh=hWoawiR62yJjf563mWI2fa+meGV0NXLDQZaBlO4lfN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDxwjLHBmE/IcsmIGsW6LgkOGHpfJ/Vwx/Jj0T5v/TVDSMvduCGmq8eY4aJbHmefo
	 hMyEpehFWdJRBsAVzi/q4qD9fBd/71m64NswzeaB0ls0uR+JzzNdnJLwx8FC3yHeKE
	 JVPwLsFZ8GvceRvhH60jfsLr/Rf4BIgGzHM22vmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linke li <lilinke99@qq.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/96] fs/dcache: Re-use value stored to dentry->d_flags instead of re-reading
Date: Tue, 16 Jul 2024 17:31:21 +0200
Message-ID: <20240716152746.914191349@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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
index b09bc88dbbec7..9b10f1872f6c9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -356,7 +356,7 @@ static inline void __d_clear_type_and_inode(struct dentry *dentry)
 	flags &= ~(DCACHE_ENTRY_TYPE | DCACHE_FALLTHRU);
 	WRITE_ONCE(dentry->d_flags, flags);
 	dentry->d_inode = NULL;
-	if (dentry->d_flags & DCACHE_LRU_LIST)
+	if (flags & DCACHE_LRU_LIST)
 		this_cpu_inc(nr_dentry_negative);
 }
 
-- 
2.43.0



