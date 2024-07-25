Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8823E19D081;
	Thu, 25 Jul 2024 14:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918702; cv=none; b=kyt8rAWk9YKC6kQRmPGtuJnqV/w793uHpeL9TK0AIdNPOLFubPiL9bKwPSPGUqD8qlLNOEVPeX/6/eLOlSUuviYEs+qlBM+57zEYDnlh/zG8QQhz18RhH76OPyvJjRm8Lp58ZNEJCVhqOKy8rZKvnIp/hH89DQCzzBYVVrPxHDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918702; c=relaxed/simple;
	bh=KS4g2uXAkgNUuzmxyayYQOeXt2zR2RMS2QZpZbANOAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARhLm7as/nzjmq5Vgf+OK9fAErxwF7UVul/0BSm0fgP0h/P5TA8ZybEl4/XgzVusyTOxsPXzl+8iMBn7hBpUzLv7SQvMMRLPYV8Mja3OAyK2FCfdUHgawI+ndidglcaSrObXUS6VAAMBEN4psgT3VhfwF7VvaH8URXNbYrlEJaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZigqKDV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZigqKDV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2EDC116B1;
	Thu, 25 Jul 2024 14:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918702;
	bh=KS4g2uXAkgNUuzmxyayYQOeXt2zR2RMS2QZpZbANOAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZigqKDV2PQGlZJO4zC8YpzOlvAVUJUPbXjoGJbPJyGJN8Ee6FyTI4KiiTygGnt+I1
	 l/w95gAQOJgA+oIP8BSDlSDlFL4LqSD3WhlUavOSRWzAIAMQGStfDfqxrppzpkg0oH
	 pSJHxEgYxFhWgTlJ6i1Ax+ZMu0a87TM3U1796VCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 6.1 04/13] jfs: dont walk off the end of ealist
Date: Thu, 25 Jul 2024 16:37:13 +0200
Message-ID: <20240725142728.200427513@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: lei lu <llfamsec@gmail.com>

commit d0fa70aca54c8643248e89061da23752506ec0d4 upstream.

Add a check before visiting the members of ea to
make sure each ea stays within the ealist.

Signed-off-by: lei lu <llfamsec@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/xattr.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -797,7 +797,7 @@ ssize_t __jfs_getxattr(struct inode *ino
 		       size_t buf_size)
 {
 	struct jfs_ea_list *ealist;
-	struct jfs_ea *ea;
+	struct jfs_ea *ea, *ealist_end;
 	struct ea_buffer ea_buf;
 	int xattr_size;
 	ssize_t size;
@@ -817,9 +817,16 @@ ssize_t __jfs_getxattr(struct inode *ino
 		goto not_found;
 
 	ealist = (struct jfs_ea_list *) ea_buf.xattr;
+	ealist_end = END_EALIST(ealist);
 
 	/* Find the named attribute */
-	for (ea = FIRST_EA(ealist); ea < END_EALIST(ealist); ea = NEXT_EA(ea))
+	for (ea = FIRST_EA(ealist); ea < ealist_end; ea = NEXT_EA(ea)) {
+		if (unlikely(ea + 1 > ealist_end) ||
+		    unlikely(NEXT_EA(ea) > ealist_end)) {
+			size = -EUCLEAN;
+			goto release;
+		}
+
 		if ((namelen == ea->namelen) &&
 		    memcmp(name, ea->name, namelen) == 0) {
 			/* Found it */
@@ -834,6 +841,7 @@ ssize_t __jfs_getxattr(struct inode *ino
 			memcpy(data, value, size);
 			goto release;
 		}
+	}
       not_found:
 	size = -ENODATA;
       release:
@@ -861,7 +869,7 @@ ssize_t jfs_listxattr(struct dentry * de
 	ssize_t size = 0;
 	int xattr_size;
 	struct jfs_ea_list *ealist;
-	struct jfs_ea *ea;
+	struct jfs_ea *ea, *ealist_end;
 	struct ea_buffer ea_buf;
 
 	down_read(&JFS_IP(inode)->xattr_sem);
@@ -876,9 +884,16 @@ ssize_t jfs_listxattr(struct dentry * de
 		goto release;
 
 	ealist = (struct jfs_ea_list *) ea_buf.xattr;
+	ealist_end = END_EALIST(ealist);
 
 	/* compute required size of list */
-	for (ea = FIRST_EA(ealist); ea < END_EALIST(ealist); ea = NEXT_EA(ea)) {
+	for (ea = FIRST_EA(ealist); ea < ealist_end; ea = NEXT_EA(ea)) {
+		if (unlikely(ea + 1 > ealist_end) ||
+		    unlikely(NEXT_EA(ea) > ealist_end)) {
+			size = -EUCLEAN;
+			goto release;
+		}
+
 		if (can_list(ea))
 			size += name_size(ea) + 1;
 	}


