Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20B31B21B4;
	Mon, 23 Dec 2024 16:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970434; cv=none; b=I0dJp84guaaPlLasdCAyAmObd9LDTR5udWTMMGhRPPQrMGOVkmOhf+4EJyC5UqmjhVNQpCnDzgd2Jo/jlORLFmJXxPl0HYxTFGYdETXINU0+O+4hJ0Gj+Q6H48xWzqg0603qFo5EboYqEoNmFcNX39ktVMPwxkhz2GLcF+A1LFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970434; c=relaxed/simple;
	bh=oKM+WRZJSmeP3rPY8xckTEA8svq1Adzyx9+tVob43K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hc086ewlP0elhxKuUdpgQEGs+HrV3g93ZPAbckWy7g8HM1K+hnPsFBavMktzWbAfdjCNoeejMo+NlJXjwN84zK7+WXolMJACiwwxABVn+Md3OpI0O3Nju/K4EKAzDuC584MQOywfe745Hmz61VZKJfA5Ja3Fpg2opHBXQaUB+vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vu55OAz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vu55OAz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A33C4CED3;
	Mon, 23 Dec 2024 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970434;
	bh=oKM+WRZJSmeP3rPY8xckTEA8svq1Adzyx9+tVob43K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vu55OAz6RTuisK8g6/HaLSTFewD7bx4NOmrwHAJuXG7c5EBp1xt1dhT9KiIW+5mUs
	 nRSNz2ELhmdI7xYs2dXKFJTV35A36FQIXvdkleAVb885KadNmvX2lIhXuRwVNkslJ3
	 OxHwB2h3FKNW3BuL6pUBfMml/E/6J2u+E4isPxAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 065/116] efivarfs: Fix error on non-existent file
Date: Mon, 23 Dec 2024 16:58:55 +0100
Message-ID: <20241223155402.089551632@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -47,7 +47,7 @@ struct inode *efivarfs_get_inode(struct
  *
  *	VariableName-12345678-1234-1234-1234-1234567891bc
  */
-bool efivarfs_valid_name(const char *str, int len)
+static bool efivarfs_valid_name(const char *str, int len)
 {
 	const char *s = str + len - EFI_VARIABLE_GUID_LEN;
 
--- a/fs/efivarfs/internal.h
+++ b/fs/efivarfs/internal.h
@@ -50,7 +50,6 @@ bool efivar_variable_is_removable(efi_gu
 
 extern const struct file_operations efivarfs_file_operations;
 extern const struct inode_operations efivarfs_dir_inode_operations;
-extern bool efivarfs_valid_name(const char *str, int len);
 extern struct inode *efivarfs_get_inode(struct super_block *sb,
 			const struct inode *dir, int mode, dev_t dev,
 			bool is_removable);
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -107,9 +107,6 @@ static int efivarfs_d_hash(const struct
 	const unsigned char *s = qstr->name;
 	unsigned int len = qstr->len;
 
-	if (!efivarfs_valid_name(s, len))
-		return -EINVAL;
-
 	while (len-- > EFI_VARIABLE_GUID_LEN)
 		hash = partial_name_hash(*s++, hash);
 


