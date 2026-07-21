Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1993DD870;
	Tue, 21 Jul 2026 18:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658099; cv=none; b=D+2XrO9ngC71b65hv1pLq2Nlw7WZE8b5sobMBMwnnyqZIVWZt3T20J03kvRKoluymkX+6J3+6YgNsQs3RMFM9f6DO+K+ZHS7Tu+AXAf5ukF/NzOxb3E1PqZdFea+3xsxrv7Fd0jXtw9WdlqKMbafCHmIzX/0H8cA9a61R2lobwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658099; c=relaxed/simple;
	bh=3fSwkcWy3mi3GiVtRO7E3L5HpYk3TppeosKTKzqIj+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVvjni+BaD8IX1kDxTjGdWuy1jRlui1cYRSvB1Ma4ILxeNgCixNKEY6JBILPmHytfj7tWfIRjfCwSEnTkk/ZiZxl/xijbdjPBLWfBQW9WeIDYfZnyyY75Z8g1UXArbjiQXcCWMaITDXH0P0prBJVKS+Vp7kZfchVavwYQ3zkyLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FO4SPRfK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FO4SPRfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CDF1F00A3A;
	Tue, 21 Jul 2026 18:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658098;
	bh=3rTymBAdg7FjorUuwAZDbiB9h/x2cRuIvmuireKKO3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FO4SPRfKfpFZVTPqeWabqiTaCwPGa7uudqvnbm4m0eKCZgqrjQu2CLt5S9jfagQBg
	 IkXc70n60NmLLMQIdJwSX0Kz7Hrc7oKv2Vj/SwvV/H9fcNUluLOSZOaz7zP5ADBgac
	 /3kd8tKpotTeUD/oplju3oUw0cIqI6/4gwRauAck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1013/1611] minix: avoid overflow in bitmap block count calculation
Date: Tue, 21 Jul 2026 17:18:49 +0200
Message-ID: <20260721152538.180642419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index d54273c3c9ffd3..c81e48badae93d 100644
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



