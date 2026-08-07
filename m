Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D765331578E;
	Fri,  7 Aug 2026 14:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114177; cv=none; b=KS0jcJ1c9mCuLWILMK8UssRCQ96/MWZqZfDsh4PZ79eW4+dzn3q4B7uoYgJiVn1wMNTYIxqUhtjmFsztMPJmASv1BxxZbqmlnPagJoN3GEAmLhtRem9Z2WR9PdS9e6K4RzagthDIrYa7iuT1u76t0Z6hhOxCpibM427zCY5AiWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114177; c=relaxed/simple;
	bh=EdXnvCsSdF116YsiqsrBlygYRfIZcXxAYLU33FFkKc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9vznxEPp5yw7Z7j90SVKimMgdzC+aP0/OesspzNb7Y35rtsL3j2P/xU4soAf9+QXWmGM3dyfa3yiYUmx3OnuyJdskWsOu3Tj8C9J9E63Qt4o7NtfLzde/126JOOdooSc3bXkfHeABVtbsBcTa4wqVbKxO48Nn7jjKvjzEXg+0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oR+VmX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oR+VmX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E1251F00A3D;
	Fri,  7 Aug 2026 14:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114175;
	bh=CrVD6ma67ONA7ay1GmJT2Do7f+AQv93T92wRNYB0nT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2oR+VmX7zQy2hdD16fv3BkozNf7dNXYD0ozu8cecqHsNfxPz+B1XanME52hF7EcOG
	 JPVlromhCBjQ/on0gMkCg6As6DHxiBe+yiP2pmUGr9H4K+T6AkNQCJXtHS+BkJ10XH
	 nvLMiLhW4uxWCTGlhnNr0Uke1e//B9xdcVyfQcI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yunseong.kim@est.tech>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/337] ksmbd: fix use-after-free in __close_file_table_ids()
Date: Fri,  7 Aug 2026 16:35:30 +0200
Message-ID: <20260807143421.286681747@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
index 0d3341927b483..51e37e89d1aa5 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -502,6 +502,8 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
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



