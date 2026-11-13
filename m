Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591080;
	b=liEIljB3XNsYbk/ec+gfY2DIysK/fReesUOa4mpChC9HvcsKJSzybsnb+sUFYe/ixksD
	 FYGUSQMsTRtRaDeGkKehk+4ri/yxo0EoSnoAPjxz4AXrR4VcAj060Z650SHKyruY5fEP9
	 WuXE4qGzGwrJMaUFOMHaL9GZdOvMky+UWVfhdOYruHq3FvC8PscID5QVlj5iNBl7+7CQ2
	 j22vblNndPluQdcH5+hFMBGOYu86Jp74T8rYxrC9TwO8/yiKwRUgK5NTTUcm8Kzvq5DfC
	 IsCJLfnW6PWuqQ1CPd1RKe8S8OmyDkMDS7lyZpOxiWCMqDjFMownutM3lDZbq5crqZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3DL9qEl3jUI/MpZnDIvIIfOSXTfpOef7de7dicUf3fY=;
	b=VTlqU26hvEj7I740e0tQpD4pCoQUTdi6dTeFhNJMxOnmw9JPN4bpYQqkFIKTH5qqELjo
	 RWDarx7ZmUKTfKi3AuAeIy4ox0DfSClDNYixqZ5SiTGQ9yirY2CfKaI4KFC55Sw6zzTH8
	 yKDOaUwIkx6MkDMhYAaytgU7qsf7oiylYLgD3iSYDCz01J0QTbvQUuclmq8qX0Hlo9/4B
	 LGJiwjhUa7lE+l+rSZwiLmUsTERqKLqi45D1QlnCy+A0qe7B7QUwoifQT2O5Ho7Xen7va
	 CtmsTihdQaAJueZ4Affhz1Luaj/XpsCWniHk46sHIeVn7mvZF5X6Y3aWPiHMiUQXm4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKLkfK06;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590216073228;
	Fri, 13 Nov 2026 17:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKLkfK06
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049871F000C5;
	Fri, 13 Nov 2026 17:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591080;
	bh=3DL9qEl3jUI/MpZnDIvIIfOSXTfpOef7de7dicUf3fY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKLkfK06br6lBDMmLbBmR6moxpRN85rN95T+X9gQ2/bdAkM2h2oqWHRaiY6u864MQ
	 iJKIFc/t98KOOlFY6Y6P91m8xlzMd38eSZWdaXAhGA8QQKHQVjFbtJYc4xo1z/hTUF
	 FSLNxSxQ+NPEEIMkJHMhlwXUjwbl1XcXxwOg6Ewc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/670] ext2: preserve completed DIO bytes when buffered fallback fails
Date: Fri, 13 Nov 2026 10:46:39 -0500
Message-ID: <20261113153819.821621566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit cbf04dde8b3c5a7e043e91cefad68b8980ea0d18 ]

ext2_dio_write_iter() can complete part of a direct write before
falling back to buffered I/O for a hole inside i_size. If
generic_perform_write() then fails, its error overwrites the completed
direct-I/O byte count.

For example, on a full filesystem, an 8 KiB write to a file with an
allocated 4 KiB prefix and a 4 KiB hole overwrites the prefix but returns
ENOSPC and leaves the file position unchanged. GNU dd with oflag=direct
consequently reports zero bytes written.

Preserve a positive direct-I/O result and return the buffered error
when no bytes were direct-written. This restores the fallback policy of
generic_file_write_iter(), which ext2 used before its iomap conversion.

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Link: https://patch.msgid.link/20261102061555.55183-1-dennylin0707@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 908d4849874da..0f047c33e0feb 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -254,7 +254,8 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		pos = iocb->ki_pos;
 		status = generic_perform_write(iocb, from);
 		if (unlikely(status < 0)) {
-			ret = status;
+			if (!ret)
+				ret = status;
 			goto out_unlock;
 		}
 
-- 
2.53.0



