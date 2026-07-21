Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FCB397E9A;
	Tue, 21 Jul 2026 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653717; cv=none; b=IiI30wO9jfn/0Po01lrWdV9+jkO3qzsbUNOK7RbYcRknCRpUZCf1HAewCIfq8Y52UzGaAuU3yo99xLFirVhW7w9oMA4AoizuOXFwe4ewlT8llexI+pHF5pLHp+XLhi4t7J49B9sRRobiXrrk2BEuVzSRM1G1ZYLdSIECosAczow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653717; c=relaxed/simple;
	bh=HcdMhnch9536vyAkK3O+o+e2xiscewQ+zeNkoVfvBho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBZM23DndCzwkBwcLj2LZj5wQwKBM+Rc0fD/Jmr/tKxvF8uYWjaipalB/zK1+aAun99zL2oC+UdRZrOWGe0aOycW9vPz5JgDGUJYJ4tSLuOBxMsOiLHQ1/D9su+TEdJ39+q2D7L8bS69OPqLTJoFBHxMJlIBmMc65JgDcInd58U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gfh98zev; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gfh98zev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780991F00A3A;
	Tue, 21 Jul 2026 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653716;
	bh=VlgFrSO98SwhItALuSwRgObZZ4vTyg4QIGPulHcGYkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gfh98zevCrwvv4z43SL+yG4paBFtgW/MKdKTc15+y7sOuSqxqUoFTYzNEcms3MTXX
	 fh55frqRnkCyXJNY+y8v84N4HPtCroJ3phkzlgHf46Sap3QMhgdKkADGhD0UchywFE
	 pfJ7QA+AOOqpK7Ac2Id5V5Iyx6YiLjVd3FL9sDS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1389/2077] minix: avoid overflow in bitmap block count calculation
Date: Tue, 21 Jul 2026 17:17:42 +0200
Message-ID: <20260721152625.577260126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f2025c9b58252f..9e52d4302f0d2e 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -97,7 +97,7 @@ static inline struct minix_inode_info *minix_i(struct inode *inode)
 
 static inline unsigned minix_blocks_needed(unsigned bits, unsigned blocksize)
 {
-	return DIV_ROUND_UP(bits, blocksize * 8);
+	return DIV_ROUND_UP_POW2(bits, blocksize * 8);
 }
 
 #if defined(CONFIG_MINIX_FS_NATIVE_ENDIAN) && \
-- 
2.53.0



