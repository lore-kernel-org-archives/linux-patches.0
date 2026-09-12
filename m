Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687D13C1D67;
	Sat, 12 Sep 2026 11:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211197; cv=none; b=RLDaagMkuPQXnzK3tq6Pu/vzxyPJ+GxzOnbMdryxz7mFSiVaeLL06BAAs3TbCK8kmxWxNl2IFp66M3jd2bSz61wpKcEQLfNWBsf+kO9OxtIXrfwTIAQfa/kXJYMZWnEm3DG/Q73xlOrFUGk0OeqRgb7NDihWb9MbdFdDglY5dd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211197; c=relaxed/simple;
	bh=gl26KpXm1WJig4yDUcUPGWas7WKL7TO/oOzTq2TFgLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtxYdsyJ6G3ZK4/eMQcfuBVq7L+653UNFj/fhFd8FXQbmTlWKNqLjI/0i/1aJjoYEC1OYKDAhusWdfRgx8nllE+HmFgLNvpFzi8rbwgb5CPQ6p6afo2+ZpBLat9fprDvqkxrTPsrBGIBgNHwHZ/cRSOsvK1Cl/jiPzqqCuHkKAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgwfNb+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgwfNb+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6A71F000FF;
	Sat, 12 Sep 2026 11:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211196;
	bh=hp3J6Xn0zx0n5hDMgHoB/unE8xXtCdmD08Hu2xUXGIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgwfNb+bYCo3XQo177guy+IRPavwT+wg1L6vk14p1jMFmaWfBa6UG17V17tenf94I
	 laBmpI3KRQy4ZEsRGmimIt7DCLhlKDrwFOKUPOXiZ1WPvPPTs8AXyFqJJ36KUkPEmu
	 jrWb8QSVc/Ea07epc0quc/g6vq0B2MazSrV7yhIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Yuejie Shi <syjcnss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1180/1518] Squashfs: check block offset is not negative
Date: Sat, 12 Sep 2026 08:55:49 +0200
Message-ID: <20260912065650.171086108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 92fb857d2c761..c8756f65bc548 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -299,7 +299,7 @@ int squashfs_copy_data(void *buffer, struct squashfs_cache_entry *entry,
 {
 	int remaining = length;
 
-	if (length == 0)
+	if (length == 0 || offset < 0)
 		return 0;
 	else if (buffer == NULL)
 		return min(length, entry->length - offset);
-- 
2.53.0



