Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D780331A68;
	Mon, 29 Dec 2025 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025574; cv=none; b=hV8O1QRB7dpamrEInjmM2gkHVd/z/O6ynkI1FF6UXwJpqDdHbrz/0LtWbJVFqPzJOk9q6HhncuprXoKtGXAItlKYdpu/Ud55JM6cBpq1taSE9Is1z4xkEKcrcSxAEaA6yFhJGJDKnNlX6V3ILSHBmRSSKAb5bSoiTjc7+yAtwIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025574; c=relaxed/simple;
	bh=dKBL9UFgt8xGf60O388QABozsllI2grZt6ME2mR7GjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5nAYjYm0nvGnC/ZKN+UlF4Ot4W5FtHdxUIiTWY0k8zGYDWTBztUaNOfhqomnLsgiTCT6Y6jULrHWZF4/fFuEdY3wXJOw/XXTflyoAb6w86SFivLHHuOaUrVaaF3Z/4olu4CgYrCCcFO20RoEPes5EN/j3uZCR2ooTRiheOLd8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3jGGhLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3jGGhLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EBAC4CEF7;
	Mon, 29 Dec 2025 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025574;
	bh=dKBL9UFgt8xGf60O388QABozsllI2grZt6ME2mR7GjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3jGGhLwH8A2F4brH3GnLGawZLFplZ0CMNbycjAxNW5Lr/AyD9tL6PQt+H0aZ+nZq
	 y5sDhFY87cj3lm6aayGeTTIGbFZYmFwzfu1iJPJdhVNrKkpoNSRF9+QRIyV+fX6ib+
	 x/CigegB2jJTgQt5PgE7gnT1p0TK06goe/26Tvvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Karina Yankevich <k.yankevich@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.18 261/430] ext4: xattr: fix null pointer deref in ext4_raw_inode()
Date: Mon, 29 Dec 2025 17:11:03 +0100
Message-ID: <20251229160733.960032255@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Karina Yankevich <k.yankevich@omp.ru>

commit b97cb7d6a051aa6ebd57906df0e26e9e36c26d14 upstream.

If ext4_get_inode_loc() fails (e.g. if it returns -EFSCORRUPTED),
iloc.bh will remain set to NULL. Since ext4_xattr_inode_dec_ref_all()
lacks error checking, this will lead to a null pointer dereference
in ext4_raw_inode(), called right after ext4_get_inode_loc().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: c8e008b60492 ("ext4: ignore xattrs past end")
Cc: stable@kernel.org
Signed-off-by: Karina Yankevich <k.yankevich@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Message-ID: <20251022093253.3546296-1-k.yankevich@omp.ru>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1174,7 +1174,11 @@ ext4_xattr_inode_dec_ref_all(handle_t *h
 	if (block_csum)
 		end = (void *)bh->b_data + bh->b_size;
 	else {
-		ext4_get_inode_loc(parent, &iloc);
+		err = ext4_get_inode_loc(parent, &iloc);
+		if (err) {
+			EXT4_ERROR_INODE(parent, "parent inode loc (error %d)", err);
+			return;
+		}
 		end = (void *)ext4_raw_inode(&iloc) + EXT4_SB(parent->i_sb)->s_inode_size;
 	}
 


