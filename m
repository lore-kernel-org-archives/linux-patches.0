Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8B115CAB
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FE6C433C1;
	Tue,  8 Nov 2022 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915187;
	bh=yiIzXuZM9GjgS4fZj8vRVtLtXLlHE/SbAOL9ivkoV98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAXFhWfGSUcth5rFAWFxHFeIgF9tJ9nN9Jm6i1pvQeMQN8IJkRFhjVmQtYBImQ/aY
	 uRvu1Y7RmfIE/h7MBw/T0/5+VZri6LIxOTmPjBHK1e6PYmhICTs8ad3r8gyA+a5FZl
	 gMfe4p81UojFb9bi1bi7EW7TUur5H7CvnNDb6Tj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Serge Hallyn <serge@hallyn.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 4.19 36/48] capabilities: fix potential memleak on error path from vfs_getxattr_alloc()
Date: Tue,  8 Nov 2022 14:39:21 +0100
Message-Id: <20221108133330.808108524@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 8cf0a1bc12870d148ae830a4ba88cfdf0e879cee upstream.

In cap_inode_getsecurity(), we will use vfs_getxattr_alloc() to
complete the memory allocation of tmpbuf, if we have completed
the memory allocation of tmpbuf, but failed to call handler->get(...),
there will be a memleak in below logic:

  |-- ret = (int)vfs_getxattr_alloc(mnt_userns, ...)
    |           /* ^^^ alloc for tmpbuf */
    |-- value = krealloc(*xattr_value, error + 1, flags)
    |           /* ^^^ alloc memory */
    |-- error = handler->get(handler, ...)
    |           /* error! */
    |-- *xattr_value = value
    |           /* xattr_value is &tmpbuf (memory leak!) */

So we will try to free(tmpbuf) after vfs_getxattr_alloc() fails to fix it.

Cc: stable@vger.kernel.org
Fixes: 8db6c34f1dbc ("Introduce v3 namespaced file capabilities")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
[PM: subject line and backtrace tweaks]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/commoncap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -397,8 +397,10 @@ int cap_inode_getsecurity(struct inode *
 				 &tmpbuf, size, GFP_NOFS);
 	dput(dentry);
 
-	if (ret < 0 || !tmpbuf)
-		return ret;
+	if (ret < 0 || !tmpbuf) {
+		size = ret;
+		goto out_free;
+	}
 
 	fs_ns = inode->i_sb->s_user_ns;
 	cap = (struct vfs_cap_data *) tmpbuf;


