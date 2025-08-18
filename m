Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F47335BA3;
	Mon, 18 Aug 2025 13:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523993; cv=none; b=kAhffTV/BHTpnvySsTNhPYcPxIB3slTbj9nR7t3yOHakO6Xw48xLwOeC5khs2Yx/W88UO5e5fQpaIkEveeAhwHFybmYlBn3RzlFL5SuGASMtskV7acIVwc3qsQv1YYUAtS644qkVdXtGJfAve+dLGnqTCTlMjTlFb8o0yVLgHMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523993; c=relaxed/simple;
	bh=7VS534ik33nZd3E51QLILRFLf1n2v/NH0I8Pns+6sqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtnqW6O2oT/ZnFNOW45RU9stqGVAWaynDilLDK1Cf85uKim2aMTXXwlo8ssrzWt/wHN1XGnT+eN5DMvFODsqGo4Pu3hGjXEMjAUQ6ftI4nBiThhO68wtbRrnhbgN9atzuWgTwUUCp2wuGLphWBzOqLfgwxNF+yEIXQxaj2JxfkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PC79cFD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PC79cFD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F338C4CEEB;
	Mon, 18 Aug 2025 13:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523993;
	bh=7VS534ik33nZd3E51QLILRFLf1n2v/NH0I8Pns+6sqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PC79cFD7FrsAInph8Mufbbgg6yJCgOpt3Q71HC2ZYUS//JnCDiZQYbz8F3ilUMhrX
	 p/gUQSn6+bphQTTOvVTAlyNW5qKYzJKA9ZvCelvFJtI4m5/IrwNup0EDHUvuL0+U7i
	 yxF57P7m0WrZ/xWBsmkJ8jokn9HshVWvutXpye70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+544248a761451c0df72f@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 336/515] ext4: do not BUG when INLINE_DATA_FL lacks system.data xattr
Date: Mon, 18 Aug 2025 14:45:22 +0200
Message-ID: <20250818124511.371625252@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 099b847ccc6c1ad2f805d13cfbcc83f5b6d4bc42 ]

A syzbot fuzzed image triggered a BUG_ON in ext4_update_inline_data()
when an inode had the INLINE_DATA_FL flag set but was missing the
system.data extended attribute.

Since this can happen due to a maiciouly fuzzed file system, we
shouldn't BUG, but rather, report it as a corrupted file system.

Add similar replacements of BUG_ON with EXT4_ERROR_INODE() ii
ext4_create_inline_data() and ext4_inline_data_truncate().

Reported-by: syzbot+544248a761451c0df72f@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index f27d9da53fb7..372058706cce 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -303,7 +303,11 @@ static int ext4_create_inline_data(handle_t *handle,
 	if (error)
 		goto out;
 
-	BUG_ON(!is.s.not_found);
+	if (!is.s.not_found) {
+		EXT4_ERROR_INODE(inode, "unexpected inline data xattr");
+		error = -EFSCORRUPTED;
+		goto out;
+	}
 
 	error = ext4_xattr_ibody_set(handle, inode, &i, &is);
 	if (error) {
@@ -354,7 +358,11 @@ static int ext4_update_inline_data(handle_t *handle, struct inode *inode,
 	if (error)
 		goto out;
 
-	BUG_ON(is.s.not_found);
+	if (is.s.not_found) {
+		EXT4_ERROR_INODE(inode, "missing inline data xattr");
+		error = -EFSCORRUPTED;
+		goto out;
+	}
 
 	len -= EXT4_MIN_INLINE_DATA_SIZE;
 	value = kzalloc(len, GFP_NOFS);
@@ -1904,7 +1912,12 @@ int ext4_inline_data_truncate(struct inode *inode, int *has_inline)
 			if ((err = ext4_xattr_ibody_find(inode, &i, &is)) != 0)
 				goto out_error;
 
-			BUG_ON(is.s.not_found);
+			if (is.s.not_found) {
+				EXT4_ERROR_INODE(inode,
+						 "missing inline data xattr");
+				err = -EFSCORRUPTED;
+				goto out_error;
+			}
 
 			value_len = le32_to_cpu(is.s.here->e_value_size);
 			value = kmalloc(value_len, GFP_NOFS);
-- 
2.39.5



