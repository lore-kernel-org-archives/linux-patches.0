Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7133F9D2;
	Tue, 12 Aug 2025 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023079; cv=none; b=Rj1GEJBYaRmAGc+fP/xy/GB4dsAiXJzZ3+VLXzBvQeAju/RHP87T5O3D4wytaCXqe4H8RRlAxCxuhVIh71u3cRvbeC5zySp+2+jrRYWUSBbtLuiTAIAQevvyb6rNxo/m/lBbvG7x5ZgvUoUPQsiwzOSAKTTXLk3HX8HOHt9MKv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023079; c=relaxed/simple;
	bh=hHJMDxR41SQpo8UPDoLUCG+T9NdnjTuw/ED8FG7MoJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNxsvb0EMuMHv5Nk0mWSlp1tRx474/vbgLYIGLB6KKBeaqBLvJhPQfTAlMbYD9bI2pm1Arnq3aXwoErBfEYS/33kVo2fVBGv54QNLURPo9f7O8p4R4IwR9SxcDJErfqyWNPTc8tuzbiRGrmMn8nRmImdFr1JKGFGaVKBgmdfqbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQx6dcwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQx6dcwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1902C4CEF0;
	Tue, 12 Aug 2025 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023079;
	bh=hHJMDxR41SQpo8UPDoLUCG+T9NdnjTuw/ED8FG7MoJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQx6dcwJ3pCIbsi0QdSJD3gaMLkh8ma9KtPfq1c3O5upuiI4+hcNcqw78hACyccQq
	 nTTqYDusLImMPMBzVTAnNhq+U8Hyl4tn5UwIw1YwGX6drRWB6Z8djoSW7PMfQ0x+N+
	 H/LBSSK6IjQrQS4wHYFBjspOKvEhpDz05D5paE0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 343/369] ksmbd: fix corrupted mtime and ctime in smb2_open
Date: Tue, 12 Aug 2025 19:30:40 +0200
Message-ID: <20250812173029.602302692@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 4f8ff9486fd94b9d6a4932f2aefb9f2fc3bd0cf6 upstream.

If STATX_BASIC_STATS flags are not given as an argument to vfs_getattr,
It can not get ctime and mtime in kstat.

This causes a problem showing mtime and ctime outdated from cifs.ko.
File: /xfstest.test/foo
Size: 4096            Blocks: 8          IO Block: 1048576 regular file
Device: 0,65    Inode: 2033391     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Context: system_u:object_r:cifs_t:s0
Access: 2025-07-23 22:15:30.136051900 +0100
Modify: 1970-01-01 01:00:00.000000000 +0100
Change: 1970-01-01 01:00:00.000000000 +0100
Birth: 2025-07-23 22:15:30.136051900 +0100

Cc: stable@vger.kernel.org
Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -563,7 +563,8 @@ int ksmbd_vfs_getattr(const struct path
 {
 	int err;
 
-	err = vfs_getattr(path, stat, STATX_BTIME, AT_STATX_SYNC_AS_STAT);
+	err = vfs_getattr(path, stat, STATX_BASIC_STATS | STATX_BTIME,
+			AT_STATX_SYNC_AS_STAT);
 	if (err)
 		pr_err("getattr failed, err %d\n", err);
 	return err;


