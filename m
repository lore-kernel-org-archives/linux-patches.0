Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275D83644B3;
	Tue, 21 Jul 2026 19:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663341; cv=none; b=gD0Tvqh/v1tluXAKYlgBRWSByUAINVqipSsd2JH2O8fSqEjqvcVLSg5SiL97B60nIBNsARiMuNfI6XtdBSdD+6xbTIc2uT6tlKYhydMijCA4uY9EnLAhni6lGR+WdPE/dxz7UdE0ixiDiPXEFahqGO2FyKmno9XgeEdVaCp/EtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663341; c=relaxed/simple;
	bh=3+sHxDScKvBeH+pkxDICHbw/5kfl4r9K8BJryw6a0pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIK6ZLdIiF9hPNyx1cJIjHoMlQNfFFa/JWf8h6InfqkM4UjQYvdRyoHc5aXA8ERQE7IwI7rHmyVAPIYd2aPMXLyVRwn6NGr+u+pl6F7GrTluceg5JOkDZI+QaVuuHWP3eHcWOt91i9XuZsk/fIjhzpBegMIi7/VApZgk13D5zG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPRsTazV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPRsTazV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D8D1F000E9;
	Tue, 21 Jul 2026 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663340;
	bh=VIQE82lak8tewqIlXXPpBZOY8TTlWHsVnRrzeMck+oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pPRsTazVHeOFMWgc/nK9nhl/JNovKe8hrEK8dhSr20AXPngpT9CmVrgi6v+SHOIk+
	 E7lhuydHNcEYbVT97Ajz2xrQbG4Ol1O27O25HSQY8zqB3DrVdW6GIgx57ZZjL2IFDn
	 j/CVR6LNSaCUQKZd/x0ffHmC7+w7qmquCcTOZg+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0743/1276] minix: avoid overflow in bitmap block count calculation
Date: Tue, 21 Jul 2026 17:19:46 +0200
Message-ID: <20260721152502.707486170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



