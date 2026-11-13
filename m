Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591208;
	b=FGvPxR8fJUnHnDGi4pduo9Co96oLWkNdJ4BinRA+GhImM4IbKdIQaifrbUksyvsbiXcw
	 TzUipsV3cZ+D09nwJq2qZC64Z6XBUzI+thf9InMR+0l57xQ1ZOVzsc/4/Co1j8tLdlkK2
	 ufImbKjGrT/IbhqDhjv+XmLoDxrWGgf34yGvw7cuNWfT0xuTJMW4IAjmV3gXbgZByooju
	 tfwrNNlKxFHRS1nMMW44ZAsYM6aFv/s9zm+IGsHHtBs8D6P3joHRr7WPqAmpzXe9FTLKK
	 KSnMwIfbKR7/m1GzKLxAS9VDw2cb+oHJivyhCI0U7sDtS0YKZbn78UbxnTP5ele9jjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591208;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rBdnCMaBZn7qEOzxIaFRx+P443eCvlPx+xdAdVIBULg=;
	b=c6Gj7T1vwHumxM7ma7QJKwvqRJxDKF8kMeRlSqTF2szNgCUlSAO2GY9AymzAo/TfYTEb
	 XVnWLzNXs/KiZ0OLol+x/g0qaaJnxTWUlBHu+67lCw/hSZTOfP5dQuS+YYwWhirbSR+vM
	 aFnK44uMy2YjmJukx9vzfv0CmrjA3HRqQGZjIZZLYxVAKAh+Xqb+Nlh66KSWzZEONOksZ
	 AkVE/qCTyUdLdaksEHMNmqJFPVGBcICPPNj0SEGHTE8No47c10L8vgYrDEfXx3QsxWaUp
	 huyNeItxDDWvwG0pEn5bDOn38Q6Xd1yNzLIv8JE3+nXN9TCKbIAvIlEFDT+hVgv7LeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nsOPlnK5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FDF6075854;
	Fri, 13 Nov 2026 17:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nsOPlnK5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDF11F000C5;
	Fri, 13 Nov 2026 17:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591208;
	bh=rBdnCMaBZn7qEOzxIaFRx+P443eCvlPx+xdAdVIBULg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsOPlnK57plIPy8fMbsjBjp7SthF43JcSlVFMZkmf6lNRq6c8DS5ENG5zSzTimIw1
	 ODSMUuxeKV0VwzDIKJkp561WVVbcnGrhGmw70Vm32WgPnUGouJeR3Z0XOJHuWaZXQu
	 mePer11NTwlpsOuLlzru5AEG0L8hNt5qSpaVwPpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matheus Alves de Almeida <matheus.aalmeida@inf.ufrgs.br>,
	Andrew Morton <akpm@linux-foundation.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Pedro Falcato <pfalcato@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/670] fat: hold truncate_lock in fat_write_failed()
Date: Fri, 13 Nov 2026 10:47:34 -0500
Message-ID: <20261113153821.697366329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3852bb66358cc..1c9988efc8d29 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -215,7 +215,9 @@ static void fat_write_failed(struct address_space *mapping, loff_t to)
 
 	if (to > inode->i_size) {
 		truncate_pagecache(inode, inode->i_size);
+		down_write(&MSDOS_I(inode)->truncate_lock);
 		fat_truncate_blocks(inode, inode->i_size);
+		up_write(&MSDOS_I(inode)->truncate_lock);
 	}
 }
 
-- 
2.53.0



