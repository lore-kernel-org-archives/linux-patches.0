Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1028DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9yH8yQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5DAC433C8;
	Mon, 16 Oct 2023 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468013;
	bh=6iS6nIiJBEZPCKHsKcwneuovDYQC1qi5NaY1p/zRrL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9yH8yQElBMsLwfN8PFp36q20f0BcVwMbATDXtSm50NBmrwIpRZQx1Q7GwIB1oKSC
	 Nevnkphd0Q7Pqi+2OIHybY4ID/FqXzExiJ1rciy6nT83ELu9yIQ8TbjxtfVBYLUB9Q
	 /+rRjQfyLKGkHg+S6/YGR4kK7OiTvNNVYB5km1SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.5 135/191] ksmbd: not allow to open file if delelete on close bit is set
Date: Mon, 16 Oct 2023 10:42:00 +0200
Message-ID: <20231016084018.540956363@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit f43328357defc0dc9d28dbd06dc3361fd2b22e28 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -106,7 +106,7 @@ int ksmbd_query_inode_status(struct inod
 	ci = __ksmbd_inode_lookup(inode);
 	if (ci) {
 		ret = KSMBD_INODE_STATUS_OK;
-		if (ci->m_flags & S_DEL_PENDING)
+		if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
 			ret = KSMBD_INODE_STATUS_PENDING_DELETE;
 		atomic_dec(&ci->m_count);
 	}
@@ -116,7 +116,7 @@ int ksmbd_query_inode_status(struct inod
 
 bool ksmbd_inode_pending_delete(struct ksmbd_file *fp)
 {
-	return (fp->f_ci->m_flags & S_DEL_PENDING);
+	return (fp->f_ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
 }
 
 void ksmbd_set_inode_pending_delete(struct ksmbd_file *fp)


