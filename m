Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7A92108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C76C433D2;
	Mon, 24 Apr 2023 13:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343373;
	bh=oBs1hXH8QmhYkd0mPE6a4KRBrhihszqtOVLQYTJUVtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYq7knmfgqkitE68Qgo9MUQFslNKDW8CToQ9cRnXt/hHpaSGunWx12VBwuddphGet
	 ed4H7HFCf+dphsstNAO5YBzoq7j+kEeH3UR2Uzc5CbKNo3dmAYZaez4AjA3DWd7XtR
	 2sk8w0ACwzO/Gb1yGwiJABHqiUpRniTlEu217wGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Yang Bo <yb203166@antfin.com>
Subject: [PATCH 5.10 52/68] fuse: fix attr version comparison in fuse_read_update_size()
Date: Mon, 24 Apr 2023 15:18:23 +0200
Message-Id: <20230424131129.655076027@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miklos Szeredi <mszeredi@redhat.com>

commit 484ce65715b06aead8c4901f01ca32c5a240bc71 upstream.

A READ request returning a short count is taken as indication of EOF, and
the cached file size is modified accordingly.

Fix the attribute version checking to allow for changes to fc->attr_version
on other inodes.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Yang Bo <yb203166@antfin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -782,7 +782,7 @@ static void fuse_read_update_size(struct
 	struct fuse_inode *fi = get_fuse_inode(inode);
 
 	spin_lock(&fi->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size &&
+	if (attr_ver >= fi->attr_version && size < inode->i_size &&
 	    !test_bit(FUSE_I_SIZE_UNSTABLE, &fi->state)) {
 		fi->attr_version = atomic64_inc_return(&fc->attr_version);
 		i_size_write(inode, size);


