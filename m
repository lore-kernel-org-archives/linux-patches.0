Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6DF482C2;
	Wed, 20 Dec 2023 16:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKhhvlEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72DCC433C7;
	Wed, 20 Dec 2023 16:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088980;
	bh=b4A7TqhvpDdQvjZxRzn1tsOOEF/SIc5HaJV5s3t9EPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKhhvlEzkkjwV3G2v/VzQloUB4/0TnMPrQAY8E8+6vkdQAvMIGUr8Cv6Va4ZxyBVT
	 ZhBAqWeVsA+vWNA/nLLtjBH/vUhmn9IYWLmI1hxe+J1EhImhob5eWrf+CgaeDn1iJF
	 m7vMXwX+AyrNSibul1N7njgD+K9oVeaJhRYw9aRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 097/159] ksmbd: call putname after using the last component
Date: Wed, 20 Dec 2023 17:09:22 +0100
Message-ID: <20231220160935.879886675@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 6fe55c2799bc29624770c26f98ba7b06214f43e0 ]

last component point filename struct. Currently putname is called after
vfs_path_parent_lookup(). And then last component is used for
lookup_one_qstr_excl(). name in last component is freed by previous
calling putname(). And It cause file lookup failure when testing
generic/464 test of xfstest.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -86,12 +86,14 @@ static int ksmbd_vfs_path_lookup_locked(
 	err = vfs_path_parent_lookup(filename, flags,
 				     &parent_path, &last, &type,
 				     root_share_path);
-	putname(filename);
-	if (err)
+	if (err) {
+		putname(filename);
 		return err;
+	}
 
 	if (unlikely(type != LAST_NORM)) {
 		path_put(&parent_path);
+		putname(filename);
 		return -ENOENT;
 	}
 
@@ -108,12 +110,14 @@ static int ksmbd_vfs_path_lookup_locked(
 	path->dentry = d;
 	path->mnt = share_conf->vfs_path.mnt;
 	path_put(&parent_path);
+	putname(filename);
 
 	return 0;
 
 err_out:
 	inode_unlock(parent_path.dentry->d_inode);
 	path_put(&parent_path);
+	putname(filename);
 	return -ENOENT;
 }
 


