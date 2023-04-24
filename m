Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC4D2108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4954C433D2;
	Mon, 24 Apr 2023 13:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343498;
	bh=bPAgZwE/5D21mB31uoUwQmkOzveDTZ4x/oF0Avqsaf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ynuzlg7cnH+6H92qICgMzaXbXveSK5Jik4J/prlldUCsDdnUnwEc7mfs/C6Dw+Ll/
	 sNfpRFa01A8SB2vjO8zkkfwQG9OSKGAizNNVCCPe1k6JQB7Msw97T3qugmWY7nOINP
	 Bre/CpEMVqy1QuZ5BTO9DXHl0zVh753MmisjHpG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, joneslee@google.com, Tudor Ambarus" <tudor.ambarus@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 4.19 19/29] Revert "ext4: fix use-after-free in ext4_xattr_set_entry"
Date: Mon, 24 Apr 2023 15:18:46 +0200
Message-Id: <20230424131121.787207430@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.155649464@linuxfoundation.org>
References: <20230424131121.155649464@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tudor Ambarus <tudor.ambarus@linaro.org>

This reverts commit bb8592efcf8ef2f62947745d3182ea05b5256a15 which is
commit 67d7d8ad99beccd9fe92d585b87f1760dc9018e3 upstream.

The order in which patches are queued to stable matters. This patch
has a logical dependency on commit 310c097c2bdbea253d6ee4e064f3e65580ef93ac
upstream, and failing to queue the latter results in a null-ptr-deref
reported at the Link below.

In order to avoid conflicts on stable, revert the commit just so that we
can queue its prerequisite patch first and then queue the same after.

Link: https://syzkaller.appspot.com/bug?extid=d5ebf56f3b1268136afd
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2214,9 +2214,8 @@ int ext4_xattr_ibody_find(struct inode *
 	struct ext4_inode *raw_inode;
 	int error;
 
-	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
+	if (EXT4_I(inode)->i_extra_isize == 0)
 		return 0;
-
 	raw_inode = ext4_raw_inode(&is->iloc);
 	header = IHDR(inode, raw_inode);
 	is->s.base = is->s.first = IFIRST(header);
@@ -2244,9 +2243,8 @@ int ext4_xattr_ibody_inline_set(handle_t
 	struct ext4_xattr_search *s = &is->s;
 	int error;
 
-	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
+	if (EXT4_I(inode)->i_extra_isize == 0)
 		return -ENOSPC;
-
 	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
 	if (error)
 		return error;


