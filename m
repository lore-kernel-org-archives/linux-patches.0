Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916582EAE6;
	Mon, 23 Dec 2024 16:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969861; cv=none; b=uJ9Qc0dGmq/B5/JTPWfjFK1J7LN0Rd8+Av+Acgw9QxO6hX8SzEwRCIXjC1z/o/DGbqdmjfbE2aAX9xxt7Y4eckHhjXx+wiVDWltIPBpESSLY50TI8mkdD8nyWdSsAMZTTgO1H6NBueDW+HKXkSmEAkRxZx0SbLxIiGguVQhDxvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969861; c=relaxed/simple;
	bh=uKn40OM2WZzfJ7VclY+hruiL887rJCEtydJr327J0RY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHzwS96SzCXVlpSC0+XsYCC0Z+NdvxUB0j3a1jJfdJ0P6zAQQfYVYucwxVVVuWUwFcXuqUoYzGYSj/iDlj0oQEGntdcm63ZT+MSSqXsQRU8Tc4/TQ4JL0habKrNTgblNjFHEe3gpD0H6LVcJQVXfDSVqkfzhy13v6tA2tgk5RVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQ8Xb5C4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQ8Xb5C4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A61C4CED3;
	Mon, 23 Dec 2024 16:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969861;
	bh=uKn40OM2WZzfJ7VclY+hruiL887rJCEtydJr327J0RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQ8Xb5C4mjyUVsgyPXxh1rxo8abgQmfNljbvgDSQVuN+nzNlo+Klzv4+lvKpJwfDW
	 0G1Y/L8L47j75aM3yEZTk3ZKtQeT4azolgrg9nPHTiAjeKOGMLnLkSD2t7TnGrNLL0
	 LvtXp+pDrdmn1b69ovcmsegro5J9rVyyrvXG/9js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.12 074/160] efivarfs: Fix error on non-existent file
Date: Mon, 23 Dec 2024 16:58:05 +0100
Message-ID: <20241223155411.546174684@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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
@@ -51,7 +51,7 @@ struct inode *efivarfs_get_inode(struct
  *
  *	VariableName-12345678-1234-1234-1234-1234567891bc
  */
-bool efivarfs_valid_name(const char *str, int len)
+static bool efivarfs_valid_name(const char *str, int len)
 {
 	const char *s = str + len - EFI_VARIABLE_GUID_LEN;
 
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -60,7 +60,6 @@ bool efivar_variable_is_removable(efi_gu
 
 extern const struct file_operations efivarfs_file_operations;
 extern const struct inode_operations efivarfs_dir_inode_operations;
-extern bool efivarfs_valid_name(const char *str, int len);
 extern struct inode *efivarfs_get_inode(struct super_block *sb,
 			const struct inode *dir, int mode, dev_t dev,
 			bool is_removable);
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -144,9 +144,6 @@ static int efivarfs_d_hash(const struct
 	const unsigned char *s = qstr->name;
 	unsigned int len = qstr->len;
 
-	if (!efivarfs_valid_name(s, len))
-		return -EINVAL;
-
 	while (len-- > EFI_VARIABLE_GUID_LEN)
 		hash = partial_name_hash(*s++, hash);
 


