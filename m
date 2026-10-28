Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215572;
	b=BA03k+2ms9KRrLsLgROATK5e3GG2xCe6ar34W0nQ4/o4KU1Zgva9fFAB/Hjb6m7E5tDz
	 6HauiUMx7/VFdDS/mWYxe4UQ3PWyySUFa9gXy3nGaN9GXt1g96NyR/+7sBmCjet3T9c/j
	 QNf0ZeCjzfYfoi4oP1c0ud7prIrFOUEsCidVwNTZE7caEmnaWyqGSpAUnL0avhCKUfsSB
	 d1x+GUacqZo6Gz5A5rCUu1qH25dLR7OqKItYR5g3O8DJUM1kk96F0Y/tyLYPCaCdKPZiY
	 +htbPuWapQqB1IwnrnfIHlwThFwg4oSAW04QS9HHYtP1j/p2VfJv4S29lW9L/V+wTLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K2lNDccByDLoRPP/cnxZ/cbog8eqqCtF1t9cHj751Fw=;
	b=iiCu0zB2doCgDp86BINHXbtLTNOewzMJwHxxkagvk86PC4Rp9eeQlhOUroKC6pg1ZXFt
	 3Jf5jrtQ+7yeFr9Yx1IPX1ig60CxWYjI4fKLaeotM2DGSzXCr9L7Ao9VV6htTEBTlVsym
	 gw0mqkibC+4zi8wFbrPnaojbeso61Q4UyUGD/FnqFl/QO1tpwP20HSIZaHD30x0yZfs/x
	 nmwfKP7cE+aVH8dHtNX+miffGWYyfWmCMkEK++Nu1vJ/k5E+62wqGOqhLB2cUgt7IzDV0
	 MbDjB/fGcJi3bvRZhousdsrgyjJCIEiEs1ozJLc8E16TH3A5yVttDH+v/O32EvDqkEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mX+vhKRm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8235F606A31C;
	Wed, 28 Oct 2026 19:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mX+vhKRm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14EE1F01825;
	Wed, 28 Oct 2026 19:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215572;
	bh=K2lNDccByDLoRPP/cnxZ/cbog8eqqCtF1t9cHj751Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mX+vhKRmWjqfuhfx5paiQluk1btY61idybXqAvhZUBaJldealfgxFZ8esnTnyIzXt
	 dfCqG+AFUnvf1T+YMbnLdXgxSR0SaTTtqmoqVEHNXX7ZwLLGl4Ip8wzyal+ytLI9VX
	 29NSoyoKa7N7iZq8HpAVq8ovCDl8vQu6FuKWVsCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1256/1887] ext4: fix kernel BUG in ext4_write_inline_data_end
Date: Wed, 28 Oct 2026 17:55:52 +0100
Message-ID: <20261028170528.007626436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

[ Upstream commit ad09aa45965d3fafaf9963bc78109b73c0f9ac8d ]

When the data=journal mount option is used, the ext4_journalled_write_end()
function incorrectly calls ext4_write_inline_data_end() without checking
if the EXT4_STATE_MAY_INLINE_DATA flag is still set on the inode.

If a previous attempt to convert the inline data to an extent failed (e.g.
due to ENOSPC), the EXT4_STATE_MAY_INLINE_DATA flag is cleared, but
the EXT4_INODE_INLINE_DATA flag remains set. In this scenario, the next
call to ext4_write_begin() will not prepare the inline data xattr for
writing, but ext4_journalled_write_end() will incorrectly attempt to write
to it, triggering a BUG_ON(pos + len > EXT4_I(inode)->i_inline_size) in
ext4_write_inline_data() since i_inline_size was not expanded.

Fix this by ensuring that ext4_journalled_write_end() only calls
ext4_write_inline_data_end() if the EXT4_STATE_MAY_INLINE_DATA flag is
set, mirroring the behavior of ext4_write_end() and ext4_da_write_end().

Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260608065227.3018-1-aditya.ansh182@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f9e9264a825a3..25b3844073d44 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1451,7 +1451,8 @@ static int ext4_journalled_write_end(struct file *file,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied, page);
 
 	if (unlikely(copied < len) && !PageUptodate(page)) {
-- 
2.53.0



