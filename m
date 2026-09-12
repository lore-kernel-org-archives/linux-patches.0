Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7BC346E75;
	Sat, 12 Sep 2026 20:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243297; cv=none; b=lPBGg8ABfc4FrYGc/m8A6ZxXGQRpnqlZCD4HaH3qLqsFm8QZlzo0BpsHqiZsxBqq9KCs4WqANKPIbqLU4ID+6Bpfs9wsZtwHbmn5hgVJYmXGr0ZA5vDmudCpx7q4SX5SCyDHJc6we17fj1sRqslbdANIjS3YBoylbDTf/zH6ZDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243297; c=relaxed/simple;
	bh=Of4n9a7xj7DCReLGNtYWrmGtgWQ4zsH83YNrW1iUcZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOCyJ1UrZXTVQ600YQAW16bTrsOQ+O+DWdGXZ16DZRHUKEAgH5GXOH8cQpvVHUsqTh+RzYthpHeHEJ4kRgcz3mH3hox48yXCJ3uquDEgoS+nXbM37iBYrr1sFQFd3/DiWtpbdkoBi9okopQDHBvAPzyI5o0xhRXaUfIWZahaPvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVP4ldQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVP4ldQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61841F000FF;
	Sat, 12 Sep 2026 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243296;
	bh=XWUOqY+SIl43Tg+D3WEi1RMgKfmIsCAkFEVfJbzFGX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MVP4ldQ5M/0wjq3WS3rExzIjXLi/Fwk4RdzVtc9Sp9hpLfMAtaL+pNDA+NDse4U+6
	 DCt32Gf8z0L3eRqDGAXiwjrqMTFKtmA0rk9cyscTqY/TftEFafzydSsF35iqPbJ4cL
	 NxyXhsom86Qpe2Iww8bCBZPjFWx6e/avH41lqFiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Yuejie Shi <syjcnss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 707/798] Squashfs: check block offset is not negative
Date: Sat, 12 Sep 2026 09:05:35 +0200
Message-ID: <20260912065533.291741745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit e300eb5002925b29be803d2661af07266cfa267e ]

If a negative offset is read off disk (for example the offset into the
decompressed fragment block), this will cause squashfs_copy_data() to
perform an out of bounds access.

Fix by checking if offset is negative, and returning 0.  This matches
existing behaviour where an offset beyond the block returns 0 bytes
copied.

To trigger this out of bounds access requires a crafted Squashfs
filesystem and CAP_SYS_ADMIN to mount it.  Unprivileged users will not be
able to mount such a filesystem, but once mounted, an unprivileged user
can trigger the out of bounds access by reading the crafted file with the
negative offset.

Link: https://lore.kernel.org/20260807162951.672510-1-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Yuejie Shi <syjcnss@gmail.com>
Closes: https://lore.kernel.org/all/20260803032735.81785-1-syjcnss@gmail.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 25bf038b880ab..2091af7416327 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -295,7 +295,7 @@ int squashfs_copy_data(void *buffer, struct squashfs_cache_entry *entry,
 {
 	int remaining = length;
 
-	if (length == 0)
+	if (length == 0 || offset < 0)
 		return 0;
 	else if (buffer == NULL)
 		return min(length, entry->length - offset);
-- 
2.53.0



