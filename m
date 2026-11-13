Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590844;
	b=ohEQYwi2aUlENensuq7cZMLEtCWUaU8liLm9cX7MvasxnhzAf0M75Sh+e6sSQ9Q88sgO
	 tjD82g1nV3M19tSPC5eT0iRGwAqfJcM6s9w2JEJ/FfxtsN2AqNzmzjzMg2Tcd30mifpcK
	 gQAr9d43FgVydd8QiMu8cT9TAtl0nCqxCpx4UwCEQU3FE8uTxYc1Xe1YgUpwhgTmOQr5K
	 y7qUdHFIetoH3M62Rf4PeITP/ZKEkeHEIKPY9qEBVlym0bFK15n3JShcdiPOVdIxIbDaA
	 3ZVSvZ01pT1PRyVmvvgOckQTTScKX0x54Lij39b4LhPnUxkxVW9gEZmN2WrNr1TH2sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ehmp69jLea8+Fs+wrLFaNnE2wuUH0Yjxav5n6GVBeE=;
	b=YNKOlIF9dXjHcc8lUfRu3gNBMqFksexbTkK59rQW9I9WO2WNRc+gDvJSNYvABE+cdX2M
	 VB1jbeGuZDPwni2Bt9WK8juhk1ILuw9aTvjsRAM2GUQhFN/9eG//EeJ2NQniBoB82R1VY
	 LPyu5C8MP6BoBqWNpONdx6PclF+69F7zt3Zdv/n2upibrkT3areFCoS4SSPhfHu6Kwb/M
	 gTY1ihanUzk7vJqy7PtHJLXkx038asBBRYfGB4pkxk4XvCNX38LJFS16dYNItPnC5Jvhq
	 k2PH+R1MJwim56zjKmWfTxV42KfCv2sqSxHxau0YqiN4+PHSUgsXtzXbvfgPHiRsGOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5joQsWp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE61606D48E;
	Fri, 13 Nov 2026 17:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5joQsWp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD81F000C4;
	Fri, 13 Nov 2026 17:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590844;
	bh=3ehmp69jLea8+Fs+wrLFaNnE2wuUH0Yjxav5n6GVBeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5joQsWpG+nXtVeRPsPesnk+LJ+lEWufUDxWZOLdszfqM+IPDxszd3dVc+6+Dw7pe
	 dx9gwJQPOgUtbIIFbCaJQAjGX1VSRhnJhhDx2ruSWZiCBdrzBEm+RS3y+dICbuwibE
	 gCP0XeBidMuRsp2hd3B1RYIlFp9dG6HNqsMLcJF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gael Blivet <gael.blivet@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/670] ksmbd: look up stream size by exact xattr name
Date: Fri, 13 Nov 2026 10:43:29 -0500
Message-ID: <20261113153812.752952237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gael Blivet <gael.blivet@gmail.com>

[ Upstream commit 10ea20d6584ecdaf2f7505855412a856a88d8934 ]

get_file_stream_info() walks the xattr list from a single
ksmbd_vfs_listxattr() and sizes each stream it finds with
ksmbd_vfs_casexattr_len(), which matches with strncasecmp(). Linux
xattr names are case-sensitive, so two streams differing only in case
report each other's size.

The loop already holds the exact name, so query it directly with
ksmbd_vfs_xattr_len(), which is what casexattr_len() calls once its
search succeeds. Make it non-static and declare it in vfs.h, and drop
the comment above it, which describes a different bug and no longer
matches the code.

This also drops a full listing per stream: casexattr_len() runs its own
listxattr on every call, so enumerating a file with N xattrs cost N
listings instead of one.

Fixes: 689f1eb3719d ("ksmbd: report actual xattr value length in stream enumeration")
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: adapted ksmbd_vfs_xattr_len() to accept a non-const struct mnt_idmap pointer ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 13 ++-----------
 fs/smb/server/vfs.c     |  4 ++--
 fs/smb/server/vfs.h     |  2 ++
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 4e0f43051d9e0..1ed32310c73a5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5275,17 +5275,8 @@ static int get_file_stream_info(struct ksmbd_work *work,
 		streamlen *= 2;
 		kfree(stream_buf);
 		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		/*
-		 * stream_name_len is the byte length of the xattr's *name*,
-		 * not its value -- same class of bug ksmbd_stream_eof()
-		 * (smb2pdu.c) already fixes for EndOfFile/AllocationSize on
-		 * a stream handle; this enumeration path needs the same
-		 * real xattr value length, not the name length reused as a
-		 * size.
-		 */
-		slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
-						path->dentry, stream_name,
-						strlen(stream_name) + 1, NULL);
+		slen = ksmbd_vfs_xattr_len(file_mnt_idmap(fp->filp),
+					   path->dentry, stream_name);
 		ssize = slen < 0 ? 0 : (loff_t)slen;
 		file_info->StreamSize = cpu_to_le64(ssize);
 		file_info->StreamAllocationSize = cpu_to_le64(ssize);
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index dafb92aa39a6c..9aee0214e8fdc 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -943,8 +943,8 @@ ssize_t ksmbd_vfs_listxattr(struct dentry *dentry, char **list)
 	return size;
 }
 
-static ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
-				   struct dentry *dentry, char *xattr_name)
+ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
+			    struct dentry *dentry, char *xattr_name)
 {
 	return vfs_getxattr(idmap, dentry, xattr_name, NULL, 0);
 }
diff --git a/fs/smb/server/vfs.h b/fs/smb/server/vfs.h
index 397dd2dd09886..1ca170dfb349d 100644
--- a/fs/smb/server/vfs.h
+++ b/fs/smb/server/vfs.h
@@ -106,6 +106,8 @@ ssize_t ksmbd_vfs_getxattr(struct mnt_idmap *idmap,
 			   struct dentry *dentry,
 			   char *xattr_name,
 			   char **xattr_buf);
+ssize_t ksmbd_vfs_xattr_len(struct mnt_idmap *idmap,
+			    struct dentry *dentry, char *xattr_name);
 ssize_t ksmbd_vfs_casexattr_len(struct mnt_idmap *idmap,
 				struct dentry *dentry, char *attr_name,
 				int attr_name_len, char *actual_name);
-- 
2.53.0



