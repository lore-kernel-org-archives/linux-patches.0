Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6E5281369;
	Fri,  7 Aug 2026 15:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116021; cv=none; b=UG8KcyXhysW2YEX3PtIIlMS9U8I/j0aOwKK5cHm7SK/TRcKOjATbEdFonQtTSEhCmvOA8hlv0I8WUtq6kIFsnqTqSpNpHEEBThY11I2vDcZhEdiw1WknwNCMu2DbaJ00adhBMSR3tmfS76Z/Piq9y9PBVvYKQK2fa/GiFfrFDrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116021; c=relaxed/simple;
	bh=fbMn/5wxM6yx5+SrCTGl6V+sHIKFrCxd4Ue1hZXiKR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aj2joKck5DgPQ+/qYetyVMLSnMW3Hpe9WdxY6XDG3aiVEyHYpFWXbybMhq0fssnsLbJ85PlXvO/DPOfD+eiJUvxGe6DAZOfvW7MvrpTlf5/0wOLEr9Sx4PzDvD6C/X/PsnHA2xOICo8vPaZfLKmrUqrKpc8SJ/OJB0UIjE3CeSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBTfljNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBTfljNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E2C1F000E9;
	Fri,  7 Aug 2026 15:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116020;
	bh=PuS8empqJzEBhqLaGlMKbO/Sqsg8zY+U0Vy+eBuPY5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBTfljNrviognRj7NIHDaZh5iC0JDodhhZNRSsi/p1u3JgsJOuqWEDyc6aIWtZ1i4
	 1wLfTD4iCYkLadHCIshnfOZBODW/keqKGmtIZO17qPfX+lrC/6xTzLNls5oPhQoUs0
	 gfwH2qT/YXZANqUPvXnSnuoGfLw//KG0QG/B0zpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunseong Kim <yunseong.kim@est.tech>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/261] ksmbd: fix use-after-free in __close_file_table_ids()
Date: Fri,  7 Aug 2026 16:37:22 +0200
Message-ID: <20260807143417.220407599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 320d467d46ca8..a15c427248494 100644
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



