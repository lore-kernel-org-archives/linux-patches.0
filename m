Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9EE1422DD;
	Mon,  6 Jan 2025 15:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178250; cv=none; b=Nx/3rBbFRtOg9aEcH+sKIHGgnmuISSZFQC1yaInGu8e55t1gLAftYKT61Fr6tCxEe4A/99Ht3Uof7eQDbRZVa6RA5mT7Luiy1acjhmILU+4jVUaMUFtZPp2h+RWbZM7sGyG3w7JaomRkkBPBskXH6pusfvH1305YP0+g9k4a/DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178250; c=relaxed/simple;
	bh=rMABV6ILjEKPwbhmk3JC/9UCzOiszQ5odkRVtGen90E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LW1w97H+ycGcQIP4Wk47yMTxY+qT0qvcxGd56QrQK2ZplHUpEvSGvOPuSwnyvHrsXVy5UlpQLAWmP0v/ZaUzHN80NLms9tIsVChVDNVnoGa2UXPdMdu2pH812RHsa2BAatKPIp7EvRyMiFi/ic3sTf5xoms7TEqeT8rqo6ydC9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyaPq1s3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyaPq1s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6127CC4CED2;
	Mon,  6 Jan 2025 15:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178249;
	bh=rMABV6ILjEKPwbhmk3JC/9UCzOiszQ5odkRVtGen90E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyaPq1s3r9Mk8E59V492gRVVfeVG3Q0IN7bWcEi25qOfhEEYzHj6KF3MXT/boy/Ic
	 ipqzcSHElf+E9jGk8KR2/egohlH1o5k/ns3GJBxUEWGpiLU8ulnFesw/xxp22qS/1f
	 JBMT6vGYJKOd9+kBTFo1OgkY4E123vlJPv1DQKXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 024/138] efivarfs: Fix error on non-existent file
Date: Mon,  6 Jan 2025 16:15:48 +0100
Message-ID: <20250106151134.136111939@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -64,9 +64,6 @@ static int efivarfs_d_hash(const struct
 	const unsigned char *s = qstr->name;
 	unsigned int len = qstr->len;
 
-	if (!efivarfs_valid_name(s, len))
-		return -EINVAL;
-
 	while (len-- > EFI_VARIABLE_GUID_LEN)
 		hash = partial_name_hash(*s++, hash);
 


