Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7870D15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zm2i2iWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88A6C433C8;
	Mon, 23 Oct 2023 11:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061085;
	bh=bN5rKRHxN9ejW1pnP6IkPGZ/3UNFZCPu5KF5nP20i/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zm2i2iWu2PBLVLBgKxNZ3JkOHXTBSEPd4mOXLnC4G1r4qpXlCuMNM4KWg2OUsoz7k
	 66THqupcng1iJFaBEbB7HcKuGUMGMfTSjYXp0/0PzfNXYs9/TOd50rXn+KhZgdTSy7
	 i6S9I9P9SzYuBHH7u4/n9XR0dpjekJiIde3FL/WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/137] ksmbd: not allow to open file if delelete on close bit is set
Date: Mon, 23 Oct 2023 12:57:04 +0200
Message-ID: <20231023104823.216046930@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit f43328357defc0dc9d28dbd06dc3361fd2b22e28 ]

Cthon test fail with the following error.

check for proper open/unlink operation
nfsjunk files before unlink:
  -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
./nfs2y8Jm9 open; unlink ret = 0
nfsjunk files after unlink:
  -rwxr-xr-x 1 root root 0  9월 25 11:03 ./nfs2y8Jm9
data compare ok
nfsjunk files after close:
  ls: cannot access './nfs2y8Jm9': No such file or directory
special tests failed

Cthon expect to second unlink failure when file is already unlinked.
ksmbd can not allow to open file if flags of ksmbd inode is set with
S_DEL_ON_CLS flags.

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/vfs_cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index 0df8467af39af..b67ce2d52ceeb 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -105,7 +105,7 @@ int ksmbd_query_inode_status(struct inode *inode)
 	ci = __ksmbd_inode_lookup(inode);
 	if (ci) {
 		ret = KSMBD_INODE_STATUS_OK;
-		if (ci->m_flags & S_DEL_PENDING)
+		if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
 			ret = KSMBD_INODE_STATUS_PENDING_DELETE;
 		atomic_dec(&ci->m_count);
 	}
@@ -115,7 +115,7 @@ int ksmbd_query_inode_status(struct inode *inode)
 
 bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 {
-	return (fp->f_ci->m_flags & S_DEL_PENDING);
+	return (fp->f_ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
 }
 
 void ksmbd_set_inode_pending_delete(struct ksmbd_file *fp)
-- 
2.40.1



