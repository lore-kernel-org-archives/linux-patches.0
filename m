Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6023D38B7D2;
	Sat, 12 Sep 2026 09:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203601; cv=none; b=k4FKhqrKI/Ng2pmg1zF5+p1QOSzYDQys2ZfobQzFp13X8M1hvlkhYBGPIm6fdPGUSf3uctY/s+hXFM+40A4MCDPNndnLr4Ul0R+eC+/y19UweEEuaDouHgGNZVd8/o5e3SXUDB3ZPgYdHoAtWAlJecVcxc/NXEHkmRd7zGLUGe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203601; c=relaxed/simple;
	bh=gTowh27K4Mp1aFYTdddqiwOXAQVxidar5IKAQj24bvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7bVUuccEcrsR01jNK4PcWaSFk8XnF7V11cKksq8IescPRgkuVv5MchQrFFnif3k+DZDync7YyeNiqJCGAXnQi57Z4EmNCaKZWdLxC1vnXNPeyChL7VMtyp1qdYD3qcVyGfI1TCNGxp5ErPyinxtKOJb5/gyDl+Bb3pzGJv1ikI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmg3ypWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmg3ypWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D65A1F000FF;
	Sat, 12 Sep 2026 08:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203600;
	bh=93rWIoLX6aDr9FmVhzg8VU44atwykIMacxyLYN14UpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmg3ypWqLbyMJKPgeDYiEA6Y7YOqrBSBSsXJwc9xtcGavDArx1V4D9SAQSCXUpIqx
	 AsxODagsyPIg2m+1KmiHJfrS6mH/Sps/6KExz/G0BWVoghqpTNLWXGz7Q1WtjLV41B
	 pFBKEqzwxXzKeN+5yFF+I2YrtcDPDPBv23Bz1T0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Yuejie Shi <syjcnss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1441/1815] Squashfs: check block offset is not negative
Date: Sat, 12 Sep 2026 08:53:11 +0200
Message-ID: <20260912065722.846545505@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 67abd4dff2222..2807b80d46b72 100644
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



