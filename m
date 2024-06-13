Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6274A3209;
	Thu, 13 Jun 2024 12:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281151; cv=none; b=s2PK+GKxsGpvpMT5m1mJTRtx9D+DpwgDtB0UmSx0XAj31g5UFREb4KeFTDhUu5sf0REqH8/WCgU//+wl12U7QQGVfKtC8oN3nO57iGcsvV7XLaLYvWWHet6qiABJw3aNKz7ZFmG5LAPjBgkHBtG5n51fblQaP3WORF9C6qrRiXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281151; c=relaxed/simple;
	bh=fpF410tvaVqHY3CDQvuhUidwBSQXcgwYMdCc0pxHoXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4WI6vAZBF9JyjHXx8rly/PYK7cGrZRaenmKZ5ibb1VGenRtHz04HWRLUf1g5UNaT/oeiU67tHjW+Ivrxjkloa3ve2KOXAjNQV6TLu/jv44s8XpTp5sAwOANkBOXZ11rSg+hKqGtQvwx2ruQA9vW8hYNHxRc+ug1683OT4eCCFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNoJPeMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNoJPeMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67A7C2BBFC;
	Thu, 13 Jun 2024 12:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281151;
	bh=fpF410tvaVqHY3CDQvuhUidwBSQXcgwYMdCc0pxHoXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNoJPeMNhjcSkdSPmzCTCWu4LtgHhjYzACEVFPmz0WjHld6nIqpzg8d6BxD0+vRGV
	 PpltaLh+j3yJOk+6THOooM8EG4DsrTY31zK/RNvbt1ZmgzLhpOogaK0msTSaPpquUr
	 kvjXfqr5ZFvtX/JUEjiJUZuLvFukTl8niAA47pJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/317] f2fs: fix to force keeping write barrier for strict fsync mode
Date: Thu, 13 Jun 2024 13:32:55 +0200
Message-ID: <20240613113253.636070152@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2787991516468bfafafb9bf2b45a848e6b202e7c ]

[1] https://www.mail-archive.com/linux-f2fs-devel@lists.sourceforge.net/msg15126.html

As [1] reported, if lower device doesn't support write barrier, in below
case:

- write page #0; persist
- overwrite page #0
- fsync
 - write data page #0 OPU into device's cache
 - write inode page into device's cache
 - issue flush

If SPO is triggered during flush command, inode page can be persisted
before data page #0, so that after recovery, inode page can be recovered
with new physical block address of data page #0, however there may
contains dummy data in new physical block address.

Then what user will see is: after overwrite & fsync + SPO, old data in
file was corrupted, if any user do care about such case, we can suggest
user to use STRICT fsync mode, in this mode, we will force to use atomic
write sematics to keep write order in between data/node and last node,
so that it avoids potential data corruption during fsync().

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 278a6253a673 ("f2fs: fix to relocate check condition in f2fs_fallocate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9023083a98a64..02971d6b347e0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -297,6 +297,18 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
 				f2fs_exist_written_data(sbi, ino, UPDATE_INO))
 			goto flush_out;
 		goto out;
+	} else {
+		/*
+		 * for OPU case, during fsync(), node can be persisted before
+		 * data when lower device doesn't support write barrier, result
+		 * in data corruption after SPO.
+		 * So for strict fsync mode, force to use atomic write sematics
+		 * to keep write order in between data/node and last node to
+		 * avoid potential data corruption.
+		 */
+		if (F2FS_OPTION(sbi).fsync_mode ==
+				FSYNC_MODE_STRICT && !atomic)
+			atomic = true;
 	}
 go_write:
 	/*
-- 
2.43.0



