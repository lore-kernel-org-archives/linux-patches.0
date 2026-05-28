Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B4E33987F;
	Thu, 28 May 2026 20:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000558; cv=none; b=SNF1XN6naPm/kYJUTE2tItGgkag2SIkaLAJOGFVzr9dciamobjFNLtTHqvMIQaNEnU5zN5Xew3K3Xxu/tI61H3bswiUDTzPGwa0YGVFzYzAVQYVFX84sNM+kWtNxpOFqrFFWel+lLL+rNBlggJEMk42ReJxRwXsNuFv8xLD5N14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000558; c=relaxed/simple;
	bh=HEICKYx83VMsPog9LTdtD2bn5hZ+UHFv03fLzhYVu/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bkl8ysg+pFb1cMpxDujvumiuamUM6vhjfz/MlekJ2W0kmJrkeMIqJFDg9fj/vvFlMdcRI0tWGyg55esKGVyw6BWKvk4uEI7oiKY9jedjJbaVtBqYb+saJ2u+MSDt11vUtnpjUD1qAryW0ZJE1VUojTrl5bZ+G7Xz6lH8SGDCXW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qv2ULM4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qv2ULM4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F6B1F000E9;
	Thu, 28 May 2026 20:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000557;
	bh=rjT6RhniKKTdDEjISCnv0Og9dm1JQj7yhKIhqHxKdUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qv2ULM4XFWCwIP4QY2XtIOPT7aqGZDVtnFaeFSwSWd9qSN37bnSelw2PTpSVTUMXY
	 qy37f08sJtOB+z+nIXN0AoGxWG42RKElugyTRlMeb9/OucazD3ozMBgOTrHRQ8nfcz
	 3kMa9/CqCCRkaCtGQgAUGvY7/SBfGP2R4LRgUf4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.12 050/272] smb/server: promote S_DEL_ON_CLS to S_DEL_PENDING when close
Date: Thu, 28 May 2026 21:47:04 +0200
Message-ID: <20260528194630.783993399@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

commit 4ec9c8e023c79f613fe4d5ad8cc737112efb2e44 upstream.

Reproducer:

  1. server: systemctl start ksmbd
  2. client: mount -t cifs //${server_ip}/export /mnt
  3. client: C program: openat(AT_FDCWD, "/mnt", O_RDWR | O_TMPFILE, 0600)

Do not treat `FILE_DELETE_ON_CLOSE_LE` as delete pending while files
remain open.

This patch fixes xfstests generic/004.

Cc: stable@vger.kernel.org
Link: https://chenxiaosong.com/en/smb-xfstests-generic-004.html
Co-developed-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Tested-by: Steve French <stfrench@microsoft.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -118,7 +118,7 @@ int ksmbd_query_inode_status(struct dent
 		return ret;
 
 	down_read(&ci->m_lock);
-	if (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS))
+	if (ci->m_flags & S_DEL_PENDING)
 		ret = KSMBD_INODE_STATUS_PENDING_DELETE;
 	else
 		ret = KSMBD_INODE_STATUS_OK;
@@ -134,7 +134,7 @@ bool ksmbd_inode_pending_delete(struct k
 	int ret;
 
 	down_read(&ci->m_lock);
-	ret = (ci->m_flags & (S_DEL_PENDING | S_DEL_ON_CLS));
+	ret = (ci->m_flags & S_DEL_PENDING);
 	up_read(&ci->m_lock);
 
 	return ret;
@@ -302,12 +302,20 @@ static void __ksmbd_inode_close(struct k
 		}
 	}
 
+	down_write(&ci->m_lock);
+	/* Promote S_DEL_ON_CLS to S_DEL_PENDING when close */
+	if (ci->m_flags & S_DEL_ON_CLS) {
+		ci->m_flags &= ~S_DEL_ON_CLS;
+		ci->m_flags |= S_DEL_PENDING;
+	}
+	up_write(&ci->m_lock);
+
 	if (atomic_dec_and_test(&ci->m_count)) {
 		bool do_unlink = false;
 
 		down_write(&ci->m_lock);
-		if (ci->m_flags & (S_DEL_ON_CLS | S_DEL_PENDING)) {
-			ci->m_flags &= ~(S_DEL_ON_CLS | S_DEL_PENDING);
+		if (ci->m_flags & S_DEL_PENDING) {
+			ci->m_flags &= ~S_DEL_PENDING;
 			do_unlink = true;
 		}
 		up_write(&ci->m_lock);


