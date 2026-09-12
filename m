Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCF1303A35;
	Sat, 12 Sep 2026 16:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231484; cv=none; b=PzQWZF2PGFU6dkwvypKtqqJYVNVvF7zaBlIDA6no5+SjjjefsgEI2iGcSKknxW8Ot71gHACH1/I43qeU7C6PgyzihCm8pQqBWpcjeuTTKCnr/HHsAbEg3XN3q8LEeocD5UyHBYgXs4Nuz6IwtkBkhvc/Zk8gNYSADE3BXZZkNeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231484; c=relaxed/simple;
	bh=d3zOgcbkZuJJeLt81pIqtjtBUuuicaxSHvYEcoV8zXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKgFzXbzEjrJYRWd+/OsllhWMRPm8oF1H1Xn13eJ+H4Rwi7MUBc/ZG0HiXGD6DHca02ppHz/S+623zztW5BIb1BeNjE81zc8MBxXOaw24Qeev930ptM9ri6krANPfWqPyt4FshAL7uXX46rMm2L3vfxch6SleYX8i6STUpzTsvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UHoFdTB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UHoFdTB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F221F000FF;
	Sat, 12 Sep 2026 16:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231483;
	bh=/FF00r0PsiLig/0UqApGpiKuqj7FFzcPvkSdkrjsaHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UHoFdTBOJ9UUEDgzEfsm3kqWHOLDWKSSfP1kll//3DmK3/2AG7H3mAx6M2CB+EyW
	 kfkxX4Ngx/C22We/X2WaSg0+bWw0RxM01Hc12HJxFibKyFqBYn1n8CRxA2lBleQ11k
	 +SJAZ0aPBOX+kc3V/7lxAO7jrcMOQ4/BN/ffOHd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Yuejie Shi <syjcnss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1006/1191] Squashfs: check block offset is not negative
Date: Sat, 12 Sep 2026 09:02:14 +0200
Message-ID: <20260912065610.790570734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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



