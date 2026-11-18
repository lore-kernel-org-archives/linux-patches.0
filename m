Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028426;
	b=3Yuiz5TS7qdO6nDOkXvXYPH/UfORvoYmRQUI4Gxwyd8UltbzyQPu0aNGuoogHb9KIKbq
	 o4vvUHIZb28MWhhnHC22F//Ex3xr06jkYlbzpbvHt1xeMDlI2g3WtsjVUGwQBwuvtwGCU
	 g1ccJSDBW5Rb0K8dBceKA6DU0uHQR2XlFSoKSkp/uHB3hCrK1t+iI9LEW6yyQYMrLeVt0
	 v8eKKJNMxfSl7aqWfeAcLxeRDbJd+215rCpU1UaXboBt5UwpqieCSN3yt4Q22F5byHpNm
	 nopYxqPhrAw67rDGw2FswzjtSW78NTtkQYp9DrdpV3lkP216mHZmmcZmgxDDmg5AMvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=idyWzYQeBkVX/HpgG2AOryIQzGLXbPJ0yCgFYkfiRvI=;
	b=ujofRRE8HchhEDsD1sgUeUHPU+z5BnVMbLNsKl+uqyyM5lWPAy3TAOAOzRcCJtiNbutN
	 6wuTuE7UK0QH5uvrajo/kyyHZwTk9ewas188qFBQxubGub/SXk2zsXL+zoYz3hCRPcQ+a
	 MJFOtWX5PHtuuQy79sb048mulc5p1BlyyboQG0qzdHxaVz9QTtejXcgkND7OwS1M6tpYA
	 +ykM/x5Sgbna2sD9dkXwOb+BY72VJKqz1ajitw/NHihhBmhVtI6rpNn0L7RNcOA6szGzf
	 bkZoyjKeIAxQpx3ugBdoBL+XP7JL38ZM2rkGwXbh9Y4a8krc98hppNw6U8yS+5+7YwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nT2YVMIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D647606A334;
	Wed, 18 Nov 2026 19:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nT2YVMIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1021F000C9;
	Wed, 18 Nov 2026 19:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028426;
	bh=idyWzYQeBkVX/HpgG2AOryIQzGLXbPJ0yCgFYkfiRvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nT2YVMIglTcwCCjCRadYL+Elbq/oGrw5gPeBX5YfoDl9iMs17Arg4ncV6164vnQYy
	 COkAEG1GL9WSP8va4R097OvK7wFxnF4Z8oKFMW2X+B8uwU/gvCs4gzikRCR3CLu2z2
	 ziVFSyF8oOYVpl8V4uHU8SXgPED7k4L6nvZaf4Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5af33dd272b913b65880@syzkaller.appspotmail.com,
	Szymon Wilczek <swilczek.lx@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.18 2141/2151] fs/ntfs3: fix deadlock in ni_read_folio_cmpr
Date: Wed, 18 Nov 2026 16:04:36 +0100
Message-ID: <20261118150239.663137426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Wilczek <swilczek.lx@gmail.com>

commit e37a75bb866c29da954b51d0dd7670406246d9ee upstream.

Syzbot reported a task hung in ni_readpage_cmpr (now ni_read_folio_cmpr).
This is caused by a lock inversion deadlock involving the inode mutex
(ni_lock) and page locks.

Scenario:
1. Task A enters ntfs_read_folio() for page X. It acquires ni_lock.
2. Task A calls ni_read_folio_cmpr(), which attempts to lock all pages in
   the compressed frame (including page Y).
3. Concurrently, Task B (e.g., via readahead) has locked page Y and
   calls ntfs_read_folio().
4. Task B waits for ni_lock (held by A).
5. Task A waits for page Y lock (held by B).
   -> DEADLOCK.

The fix is to restructure locking: do not take ni_lock in ntfs_read_folio().
Instead, acquire ni_lock inside ni_read_folio_cmpr() ONLY AFTER all required
page locks for the frame have been successfully acquired. This restores the
correct lock ordering (Page Lock -> ni_lock) consistent with VFS.

Reported-by: syzbot+5af33dd272b913b65880@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5af33dd272b913b65880
Fixes: f35590ee26f5 ("fs/ntfs3: remove ntfs_bio_pages and use page cache for compressed I/O")
Signed-off-by: Szymon Wilczek <swilczek.lx@gmail.com>
[almaz.alexandrovich@paragon-software.com: ni_readpage_cmpr was renamed to ni_read_folio_cmpr]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/frecord.c |    2 ++
 fs/ntfs3/inode.c   |    3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2119,7 +2119,9 @@ int ni_read_folio_cmpr(struct ntfs_inode
 		pages[i] = pg;
 	}
 
+	ni_lock(ni);
 	err = ni_read_frame(ni, frame_vbo, pages, pages_per_frame, 0);
+	ni_unlock(ni);
 
 out1:
 	for (i = 0; i < pages_per_frame; i++) {
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -761,9 +761,8 @@ static int ntfs_read_folio(struct file *
 	}
 
 	if (is_compressed(ni)) {
-		ni_lock(ni);
+		/* ni_lock is taken inside ni_read_folio_cmpr after page locks */
 		err = ni_read_folio_cmpr(ni, folio);
-		ni_unlock(ni);
 		return err;
 	}
 


