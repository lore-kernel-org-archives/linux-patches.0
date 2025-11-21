Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8F7347BC6;
	Fri, 21 Nov 2025 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732944; cv=none; b=hvR91Zp+Om9KI01inL2OvQ4GsdE1fZp6QEquuQR3ii6ianeBJXE0s7LyLAJfOO2HOALnnGjvaQO22r2c+EJssQkrsI3/K0gLmtM0CiizvHhdGt0uBK2cJOtj3v47K7s3j3InZHMxY4fc5OdbUrrsIb0c+BeYf3RzLk3c704CGJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732944; c=relaxed/simple;
	bh=gwd7rz7o/jL9vQ0gLxxKi9LJBNzg2l3x2y2lOAtjz8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EU6D2ECZLDGg1xfIMXJsVmzd/aagwTSxdPAdH1YtsALzwMJpgp2yxSc2UcrXI8UNqwiRkD75mp/Fcj+u/PTyqRqWoIhQ29K+KbF3PYjO24E9O60KAmwmQc5jysYslyPuBNaDvJMiBEwGlby7Hm2UThyg4HEOdMBoTyaF76d2qjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzXuWxtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzXuWxtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831DEC4CEFB;
	Fri, 21 Nov 2025 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732943;
	bh=gwd7rz7o/jL9vQ0gLxxKi9LJBNzg2l3x2y2lOAtjz8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzXuWxtDI8MR6j/YYEH1up7Tt68+7A6wnfOj/rff8QYIxAQFKwCm9E5Jip9evyjEb
	 n9uIRrDS1zzT97qH4SEnEx7gihy5KM8I3JP7JNs6RvC+EJkvo0jwT99vR9nAuSeLU0
	 MgWM5T2m/qYv/aGg2saX4jwVidsmrT79nrsHLJNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Coiby Xu <coxu@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 297/529] ima: dont clear IMA_DIGSIG flag when setting or removing non-IMA xattr
Date: Fri, 21 Nov 2025 14:09:56 +0100
Message-ID: <20251121130241.594435986@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Coiby Xu <coxu@redhat.com>

[ Upstream commit 88b4cbcf6b041ae0f2fc8a34554a5b6a83a2b7cd ]

Currently when both IMA and EVM are in fix mode, the IMA signature will
be reset to IMA hash if a program first stores IMA signature in
security.ima and then writes/removes some other security xattr for the
file.

For example, on Fedora, after booting the kernel with "ima_appraise=fix
evm=fix ima_policy=appraise_tcb" and installing rpm-plugin-ima,
installing/reinstalling a package will not make good reference IMA
signature generated. Instead IMA hash is generated,

    # getfattr -m - -d -e hex /usr/bin/bash
    # file: usr/bin/bash
    security.ima=0x0404...

This happens because when setting security.selinux, the IMA_DIGSIG flag
that had been set early was cleared. As a result, IMA hash is generated
when the file is closed.

Similarly, IMA signature can be cleared on file close after removing
security xattr like security.evm or setting/removing ACL.

Prevent replacing the IMA file signature with a file hash, by preventing
the IMA_DIGSIG flag from being reset.

Here's a minimal C reproducer which sets security.selinux as the last
step which can also replaced by removing security.evm or setting ACL,

    #include <stdio.h>
    #include <sys/xattr.h>
    #include <fcntl.h>
    #include <unistd.h>
    #include <string.h>
    #include <stdlib.h>

    int main() {
        const char* file_path = "/usr/sbin/test_binary";
        const char* hex_string = "030204d33204490066306402304";
        int length = strlen(hex_string);
        char* ima_attr_value;
        int fd;

        fd = open(file_path, O_WRONLY|O_CREAT|O_EXCL, 0644);
        if (fd == -1) {
            perror("Error opening file");
            return 1;
        }

        ima_attr_value = (char*)malloc(length / 2 );
        for (int i = 0, j = 0; i < length; i += 2, j++) {
            sscanf(hex_string + i, "%2hhx", &ima_attr_value[j]);
        }

        if (fsetxattr(fd, "security.ima", ima_attr_value, length/2, 0) == -1) {
            perror("Error setting extended attribute");
            close(fd);
            return 1;
        }

        const char* selinux_value= "system_u:object_r:bin_t:s0";
        if (fsetxattr(fd, "security.selinux", selinux_value, strlen(selinux_value), 0) == -1) {
            perror("Error setting extended attribute");
            close(fd);
            return 1;
        }

        close(fd);

        return 0;
    }

Signed-off-by: Coiby Xu <coxu@redhat.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_appraise.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 870dde67707b1..0acf7d6baa37f 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -671,6 +671,15 @@ static int ima_protect_xattr(struct dentry *dentry, const char *xattr_name,
 	return 0;
 }
 
+/*
+ * ima_reset_appraise_flags - reset ima_iint_cache flags
+ *
+ * @digsig: whether to clear/set IMA_DIGSIG flag, tristate values
+ *          0: clear IMA_DIGSIG
+ *          1: set IMA_DIGSIG
+ *         -1: don't change IMA_DIGSIG
+ *
+ */
 static void ima_reset_appraise_flags(struct inode *inode, int digsig)
 {
 	struct integrity_iint_cache *iint;
@@ -683,9 +692,9 @@ static void ima_reset_appraise_flags(struct inode *inode, int digsig)
 		return;
 	iint->measured_pcrs = 0;
 	set_bit(IMA_CHANGE_XATTR, &iint->atomic_flags);
-	if (digsig)
+	if (digsig == 1)
 		set_bit(IMA_DIGSIG, &iint->atomic_flags);
-	else
+	else if (digsig == 0)
 		clear_bit(IMA_DIGSIG, &iint->atomic_flags);
 }
 
@@ -770,6 +779,8 @@ int ima_inode_setxattr(struct dentry *dentry, const char *xattr_name,
 		digsig = (xvalue->type == EVM_IMA_XATTR_DIGSIG);
 	} else if (!strcmp(xattr_name, XATTR_NAME_EVM) && xattr_value_len > 0) {
 		digsig = (xvalue->type == EVM_XATTR_PORTABLE_DIGSIG);
+	} else {
+		digsig = -1;
 	}
 	if (result == 1 || evm_revalidate_status(xattr_name)) {
 		ima_reset_appraise_flags(d_backing_inode(dentry), digsig);
@@ -783,18 +794,20 @@ int ima_inode_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		      const char *acl_name, struct posix_acl *kacl)
 {
 	if (evm_revalidate_status(acl_name))
-		ima_reset_appraise_flags(d_backing_inode(dentry), 0);
+		ima_reset_appraise_flags(d_backing_inode(dentry), -1);
 
 	return 0;
 }
 
 int ima_inode_removexattr(struct dentry *dentry, const char *xattr_name)
 {
-	int result;
+	int result, digsig = -1;
 
 	result = ima_protect_xattr(dentry, xattr_name, NULL, 0);
 	if (result == 1 || evm_revalidate_status(xattr_name)) {
-		ima_reset_appraise_flags(d_backing_inode(dentry), 0);
+		if (!strcmp(xattr_name, XATTR_NAME_IMA))
+			digsig = 0;
+		ima_reset_appraise_flags(d_backing_inode(dentry), digsig);
 		if (result == 1)
 			result = 0;
 	}
-- 
2.51.0



