Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB32A35CB60;
	Fri,  7 Aug 2026 15:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117065; cv=none; b=M5fc7dylP381696OM7ZA13ntv7KCQyvxCLZW60eypoq+j+/VgMrb8uPJP4zilAjuTWMckqeQNw/AszDstLRwL8qpdv/nF3kUOC05h0TRv9fVH9r0y5p55lK1yLotpIrDNSwol97FggcgxI8onlMMELb6be5yyY5kOC8PhDtl41M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117065; c=relaxed/simple;
	bh=+GqawOJ7803Rv3mLE64hW8hTU7IyVo8yo3ZsSYUvWZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnIH3UGCAKM8t5IURRKrwUTeCVPQxdqE1aJqPG+c6u+UKDgser0dZtgsIkT0LxR9upXIXTTd+rGpqAoyX0uDes0ssQO/eKjTYmaAFXSr7Umt39JQlyxgn1hQoWG7CEGuWOtZXtJNRbMAanNzHEOHroeP7kk3XBe5T+8dunQZbBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF2WOJYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF2WOJYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BBD1F000E9;
	Fri,  7 Aug 2026 15:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117064;
	bh=7tR83qAVQmDWY4D1TuaAOtp2f7xWn1++KUl6PUd6g+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vF2WOJYiRohzbfGS7Y3MmUBpstPJEtv0h5i8md2/XNtUGEpc4Cs3bkYDXYNag7hcK
	 Y6gvpUivQ56GE34BaGp11RJRGxqOmOaFHE+cMeUp4KuWToYQwjVHYQwNHEBknLwxJS
	 PeKmP21c+8qFqTb6k29sAF6OYnUW+fnvVuUMisvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yunseong.kim@est.tech>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 188/438] ksmbd: fix use-after-free in __close_file_table_ids()
Date: Fri,  7 Aug 2026 16:36:24 +0200
Message-ID: <20260807143432.039521762@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e7188199eff46a636f3436356f0aae039be6dd66 ]

A ksmbd_file can remain alive after logical close while another session
holds a temporary reference obtained through ksmbd_lookup_fd_inode().
ksmbd_close_fd() currently marks the file closed and drops the idr-owned
reference, but leaves the pointer published in the closing session's idr
until the final reference is dropped.

If the foreign holder performs the final ksmbd_fd_put(), __put_fd_final()
supplies the foreign session's file table to __ksmbd_close_fd(). The object
is then freed without being removed from its owner's idr, and the owner
session later dereferences the stale pointer during file-table teardown.

Remove the volatile id from the owner's idr while ksmbd_close_fd() still
holds that table's lock, and clear volatile_id before dropping
the idr-owned reference. A later foreign final put then only performs
physical destruction and cannot remove the object from the wrong table.

Fixes: 8510a043d334 ("ksmbd: increment reference count of parent fp")
Reported-by: Yunseong Kim <yunseong.kim@est.tech>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index b12c0bb527e41..c7d49aac7470a 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -595,6 +595,8 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 			fp = NULL;
 		else {
 			fp->f_state = FP_CLOSED;
+			idr_remove(ft->idr, id);
+			fp->volatile_id = KSMBD_NO_FID;
 			closed = true;
 			if (!atomic_dec_and_test(&fp->refcount))
 				fp = NULL;
-- 
2.53.0



