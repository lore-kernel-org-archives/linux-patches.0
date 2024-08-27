Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AE41C57B3;
	Tue, 27 Aug 2024 14:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770178; cv=none; b=Q7rFIAFRQJDUO/VXwnaNG5+Kbbra2PLfF6xfZ2r68V1xDQH15kqyYEiyq9vQTRfz5hYw6byWhqp5HbpBcpS9Q8MQSlEAHiq4NDDBlz95Tl08W78yg0zLSkhA7GVUqYWck/W1KtcpoGJ+VWM742kP4eNgvXDJqbbpS5WuehMH71k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770178; c=relaxed/simple;
	bh=uFgy+9Zx+e5cdRQxzHYoHAGTdkyqfpDwUFyIcoQQbXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOTat3l1jtjGYFpaFQqy80FiDkaU7HUqmjDvOzCwOS8j/p3+POVmU+D1Dtcd14kpXxfvlhLlqff44+OMwtojVWQ1DdeD0OxiyK+rhG95lLPpVEPeQ0ClG0obXytbOIUIszt1Z9It8nTn7qddPVldiD/bEDU/lXKPVLi7HA4DTXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCDcUeup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCDcUeup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB90DC4AF53;
	Tue, 27 Aug 2024 14:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770178;
	bh=uFgy+9Zx+e5cdRQxzHYoHAGTdkyqfpDwUFyIcoQQbXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCDcUeup8BASc1utgp1z2C29k1x8eE5ew+TAZeE6+3Ol5TRZYCfPl2tMjqRVinzcY
	 xS2Lyl1tMw9gdTcYf5TRK4rJGxA1R7WfnVnFY5MPT2VTWcuDirmxdxrwVfAr/pKttI
	 +093rpXlbSONcKu3ybROpCugY0WT1oEPQJISu3a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/341] evm: dont copy up security.evm xattr
Date: Tue, 27 Aug 2024 16:36:20 +0200
Message-ID: <20240827143849.089902369@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Mimi Zohar <zohar@linux.ibm.com>

[ Upstream commit 40ca4ee3136d2d09977d1cab8c0c0e1582c3359d ]

The security.evm HMAC and the original file signatures contain
filesystem specific data.  As a result, the HMAC and signature
are not the same on the stacked and backing filesystems.

Don't copy up 'security.evm'.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/evm.h               | 6 ++++++
 security/integrity/evm/evm_main.c | 7 +++++++
 security/security.c               | 2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/evm.h b/include/linux/evm.h
index 01fc495a83e27..36ec884320d9f 100644
--- a/include/linux/evm.h
+++ b/include/linux/evm.h
@@ -31,6 +31,7 @@ extern void evm_inode_post_setxattr(struct dentry *dentry,
 				    const char *xattr_name,
 				    const void *xattr_value,
 				    size_t xattr_value_len);
+extern int evm_inode_copy_up_xattr(const char *name);
 extern int evm_inode_removexattr(struct mnt_idmap *idmap,
 				 struct dentry *dentry, const char *xattr_name);
 extern void evm_inode_post_removexattr(struct dentry *dentry,
@@ -117,6 +118,11 @@ static inline void evm_inode_post_setxattr(struct dentry *dentry,
 	return;
 }
 
+static inline int  evm_inode_copy_up_xattr(const char *name)
+{
+	return 0;
+}
+
 static inline int evm_inode_removexattr(struct mnt_idmap *idmap,
 					struct dentry *dentry,
 					const char *xattr_name)
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index ff9a939dad8e4..2393230c03aa3 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -864,6 +864,13 @@ void evm_inode_post_setattr(struct dentry *dentry, int ia_valid)
 		evm_update_evmxattr(dentry, NULL, NULL, 0);
 }
 
+int evm_inode_copy_up_xattr(const char *name)
+{
+	if (strcmp(name, XATTR_NAME_EVM) == 0)
+		return 1; /* Discard */
+	return -EOPNOTSUPP;
+}
+
 /*
  * evm_inode_init_security - initializes security.evm HMAC value
  */
diff --git a/security/security.c b/security/security.c
index dd26f21b2244b..b6144833c7a8e 100644
--- a/security/security.c
+++ b/security/security.c
@@ -2539,7 +2539,7 @@ int security_inode_copy_up_xattr(const char *name)
 			return rc;
 	}
 
-	return LSM_RET_DEFAULT(inode_copy_up_xattr);
+	return evm_inode_copy_up_xattr(name);
 }
 EXPORT_SYMBOL(security_inode_copy_up_xattr);
 
-- 
2.43.0



