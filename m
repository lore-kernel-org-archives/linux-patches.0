Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117FB3B83FE;
	Tue, 21 Jul 2026 20:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666955; cv=none; b=c+nFRr7IBntLwtAj7B0x1J2BvOi2rpQ0HyueTik2SBKyFtXJwGCIwj1HtXDUSpaYhIvmxIXCnW6EfDTenZ7p9OV4cCKulwOjZGUCe+4Ei648LQvHastQ5+dYfSw8koSBEPJcRdinVG2eYnRUnYqKMr+WSnvDIFHzOMgxWtP1mZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666955; c=relaxed/simple;
	bh=DkMTmqA8ORPKg87EKvAfBD1eqbfEkNMYu3iqolywhyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsFlYQd8eFL+bxhyjsiFtA836khRqFP86oBJdZCXw+P20YCBOywxXM37jUCe3y+R9q0fqjqPKV2jy0Z9FA4+4jpe5hkrt7GIkGSOkk4ggIIZbXbxkod5FY3obCCIrIGq/9XfOvQ6NZqzN5ZpSx5TABLCjGBfaVKbnPRQpAGocs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEdCtI96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEdCtI96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778331F000E9;
	Tue, 21 Jul 2026 20:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666954;
	bh=kdNRe2KPMHVkh/tKPHJhU3LttQNnMutDbnQSYPu3wNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEdCtI96hdPXWiRUTlHTif2FZGtFrOWgB1FUwdoe97nY56MnMd9PxUZa7gClxOCWC
	 uiPpWqAR1xCQa4mnrzK6su/nBiDeTOQb1DzqSyOl64ejpHMsaUezxsg4ShCkcJ/322
	 7P9JE8ThXvpBQJndndQhA0wj+pu485AqisSXKqBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0835/1266] minix: avoid overflow in bitmap block count calculation
Date: Tue, 21 Jul 2026 17:21:12 +0200
Message-ID: <20260721152500.540667267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit fb3e566cafc38fe3ba35e6843a2d529a3748870c ]

minix_check_superblock() uses minix_blocks_needed() to verify that the
on-disk imap and zmap block counts are large enough for the advertised
inode and zone counts.

The helper currently performs DIV_ROUND_UP() in unsigned int arithmetic.
A Minix v3 image can set s_ninodes or s_zones near UINT_MAX so the
addition inside DIV_ROUND_UP() wraps to zero. That makes a zero imap/zmap
block count look valid, after which minix_fill_super() can dereference
s_imap[0] or s_zmap[0] even though no bitmap buffers were allocated.

Impact: mounting a crafted Minix v3 image whose s_ninodes or s_zones is
near UINT_MAX makes minix_check_superblock() accept a zero bitmap-block
count and minix_fill_super() dereference s_imap[0]/s_zmap[0], panicking
the kernel.

The divisor is the bitmap capacity in bits, blocksize * 8, which is
always a power of two: minix_fill_super() obtains the block size through
sb_set_blocksize(), and blk_validate_block_size() rejects any size that
is not a power of two. Use DIV_ROUND_UP_POW2(), which divides before
adding the round-up term and so cannot overflow for a power-of-two
divisor.

Fixes: 8c97a6ddc956 ("minix: Add required sanity checking to minix_check_superblock()")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260618143922.3066874-1-michael.bommarito@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/minix.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index d493507c064f67..aee0ff9e5623d4 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -91,7 +91,7 @@ static inline struct minix_inode_info *minix_i(struct inode *inode)
 
 static inline unsigned minix_blocks_needed(unsigned bits, unsigned blocksize)
 {
-	return DIV_ROUND_UP(bits, blocksize * 8);
+	return DIV_ROUND_UP_POW2(bits, blocksize * 8);
 }
 
 #if defined(CONFIG_MINIX_FS_NATIVE_ENDIAN) && \
-- 
2.53.0



