Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046367;
	b=Nae3pYT3fMUO144RILNiW9olgTkGS3sJFZNHBXv+mpZNwZFtUHK5vVz3/aGF+N7F6w5G
	 k/yYhAeOXvSRzKavrYqwlYxLw8mRZU9KNIoRyOWM6BbmW+YQtvlExKBNi4f/tICb+dG1z
	 H0rY0kG3Ck5J+uCvOKkgVKGcNT5yqs/Y/BbbrZHFNSnPqWL2/txvsbSkxafVUJw1Q3CZQ
	 2w2sXxr77sDIbJnVR8KFVk+gdO93yID7z4I9NFTJe0TwJyAUJD4ZH0BpM9m40hvZn7ZBG
	 qRZQc80xK03XRBxuCL4uUfRchygnY2ec+hOXJC2ZFQuFgv1dcpRdFnFXJ34B/tl9eKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KcYZxf76jOADbgF4bqdDUzv7o0nyjMs9UooWCxG6yrE=;
	b=ktoJFKP0jNftLrdpdUjbt4Qu88dNMsuwGbvW2oiYRjKa2avz6HWvDNIpsQY44/vRElXh
	 ud1T7ejRwXg7YP6lEqLUW6ReS2R/6LNSTEwuPi/+R2dAKbi8HxPauWdAND4xMmDSieL5B
	 FqlNqY2TvZ++GwxYjlUpjyVGvYrcvVhAkiORnGZhkGGAAnnz4iJUh4jfxtzCX/73q7Fvz
	 qR3OmEN4FwqwMc2sC8pul3cHsCPNA+dNsF3sLsODQ0Ly1tNki7rCxU0YDaaAGHZcXh17N
	 r2cVi7sWuVGQK6lNYcnahHLYXE9phnsslmEiL/HCP6cDkTqg/mIT9MC6uef/sHu3WJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5WW2Cjc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4AC606A320;
	Wed, 18 Nov 2026 23:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5WW2Cjc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E50E1F000C6;
	Wed, 18 Nov 2026 23:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046367;
	bh=KcYZxf76jOADbgF4bqdDUzv7o0nyjMs9UooWCxG6yrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5WW2CjcaSV1OazCJJkYKpS9Xqr24N9Hz4eHNAr8To7j3F1+n0vuomla6tX8mHlB6
	 hk07Q0fEq0vZwBh1AUzl8rDoeqpMcOLJTJUhOPP2Ct4Asl9NPaiydG4Mxwmc2Lzubx
	 T8us6InpyS70F25MefYUq9U0pA2Y/seydL4ILjGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Andrew Morton <akpm@linux-foundation.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1257/2857] fat: hold truncate_lock in fat_write_failed()
Date: Wed, 18 Nov 2026 15:38:11 +0100
Message-ID: <20261118150246.798556687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>

[ Upstream commit 7b90009546f5d3f3ac9428040cd7ffbdfd60f2eb ]

The current fat_write_failed() implementation calls into
fat_truncate_blocks() without holding truncate_lock.

A failed or short extending write racing with FIBMAP can spuriously make a
FAT filesystem read-only.  FIBMAP bounds its lookup by i_blocks, so it can
walk allocated clusters beyond i_size while fat_write_failed() is removing
them.  If the chain is shortened during the walk, the mapper can report a
bogus "request beyond EOF" error, triggering the default read-only error
policy.  Hold truncate_lock for write around the block cleanup to
serialize it with _fat_bmap().

For comparison, fat_setattr() correctly holds truncate_lock during
truncation:

	down_write(&MSDOS_I(inode)->truncate_lock);
	truncate_setsize(inode, attr->ia_size);
	fat_truncate_blocks(inode, attr->ia_size);
	up_write(&MSDOS_I(inode)->truncate_lock);

Make it so ->truncate_lock is held exclusive while truncating.

Link: https://lore.kernel.org/20261021162105.62525-1-matheus.aalmeida@inf.ufrgs.br
Fixes: 16fab2015099 ("fat: permit to return phy block number by fibmap in fallocated region")
Fixes: 459f6ed3b8c7 ("fat: convert to use the new truncate convention.")
Signed-off-by: Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 1cbcc4608dc78..5a09d49b3f6bc 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -221,7 +221,9 @@ static void fat_write_failed(struct address_space *mapping, loff_t to)
 
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, inode->i_size);
+		down_write(&MSDOS_I(inode)->truncate_lock);
 		fat_truncate_blocks(inode, inode->i_size);
+		up_write(&MSDOS_I(inode)->truncate_lock);
 	}
 }
 
-- 
2.53.0



