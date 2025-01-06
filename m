Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C261482F2;
	Mon,  6 Jan 2025 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179171; cv=none; b=D9DxRjCDEWhe+uE8gbj/dXdQCWwVhRHbmzgER0I7kU9zpDvDjEGlm5eeuSyEDwrL5lkgYzVYb80g3EiaBBQmGoeiyuq1yiiA87kICsoIEgNKUZMRsazsX247/dj1m2n1y7W/dEz2Nm/xjizkBsgPJ6gjdP5D8DrfxBWpvpYuyAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179171; c=relaxed/simple;
	bh=nBTZVHp65eOEUq6XZ8MVHLkB6E905vDAMt6u8/jg9XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDqNwon86SB7yFrxBzI42lKcZSusvkld7GgZ4BsLzwpdrP2+uPk+Fu4oPIwxV2HtBuWC3ttMJdsy8A1+xJYAGo8QMwD2LAF3M3qZDQH3+ztk2/xqzRowdp3/Iofu/OEc29b424wNpa8UuQGK3a9ds4fobYMCzYpo+zZ5dcy6xAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4mKkqWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4mKkqWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0A6C4CEE1;
	Mon,  6 Jan 2025 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179171;
	bh=nBTZVHp65eOEUq6XZ8MVHLkB6E905vDAMt6u8/jg9XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4mKkqWjYhVHh52SCY/wcbtZSem00U1F74Oki5zrOw6jdwfb95r6mF6Mb1YTEJvpQ
	 kDuHxstvLh9MSdqZHiUcTskvj7vpFqjJrBLD3Sxr/FaHxeCvfVuGV8SI5T7+MfJ0UX
	 viL1PpCbs54BMND9gxhvRXRRaXl+i6gk7t880UJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.4 18/93] efivarfs: Fix error on non-existent file
Date: Mon,  6 Jan 2025 16:16:54 +0100
Message-ID: <20250106151129.391075440@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 2ab0837cb91b7de507daa145d17b3b6b2efb3abf upstream.

When looking up a non-existent file, efivarfs returns -EINVAL if the
file does not conform to the NAME-GUID format and -ENOENT if it does.
This is caused by efivars_d_hash() returning -EINVAL if the name is not
formatted correctly.  This error is returned before simple_lookup()
returns a negative dentry, and is the error value that the user sees.

Fix by removing this check.  If the file does not exist, simple_lookup()
will return a negative dentry leading to -ENOENT and efivarfs_create()
already has a validity check before it creates an entry (and will
correctly return -EINVAL)

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <stable@vger.kernel.org>
[ardb: make efivarfs_valid_name() static]
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/efivarfs/inode.c    |    2 +-
 fs/efivarfs/internal.h |    1 -
 fs/efivarfs/super.c    |    3 ---
 3 files changed, 1 insertion(+), 5 deletions(-)

--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -43,7 +43,7 @@ struct inode *efivarfs_get_inode(struct
  *
  *	VariableName-12345678-1234-1234-1234-1234567891bc
  */
-bool efivarfs_valid_name(const char *str, int len)
+static bool efivarfs_valid_name(const char *str, int len)
 {
 	const char *s = str + len - EFI_VARIABLE_GUID_LEN;
 
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -10,7 +10,6 @@
 
 extern const struct file_operations efivarfs_file_operations;
 extern const struct inode_operations efivarfs_dir_inode_operations;
-extern bool efivarfs_valid_name(const char *str, int len);
 extern struct inode *efivarfs_get_inode(struct super_block *sb,
 			const struct inode *dir, int mode, dev_t dev,
 			bool is_removable);
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -63,9 +63,6 @@ static int efivarfs_d_hash(const struct
 	const unsigned char *s = qstr->name;
 	unsigned int len = qstr->len;
 
-	if (!efivarfs_valid_name(s, len))
-		return -EINVAL;
-
 	while (len-- > EFI_VARIABLE_GUID_LEN)
 		hash = partial_name_hash(*s++, hash);
 


