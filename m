Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691D814532F;
	Thu, 23 May 2024 13:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470775; cv=none; b=XtOOU6OYYrzI6Se2wjGI7r8RkHW9ytHUjS2GpauHhf8cc0OE6kFth+Ic6e8vrQiWZEQp+y28vht1K/tk4yq6c3oDS0zj/xdYDuqEFrPz3UJFigAc+zh0NePGSX/pF4qbGj8kKNZgRlCmp6vnTNsXbAX45VDnOsbG4e4uk/8uFLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470775; c=relaxed/simple;
	bh=yr7mGFKKZmUqj4O8InPltfkbiWnfMg3BPXIXpOqKgV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpg1LwUQhMJDM8Q7mk8/MgZjSsCMkdCd5rOigDPRqi3ltY61mkDIN48GFUcTaaUq4O/u08qhC5kw9RZyIWOWZ964rll2deD9sh1t9IjVZs2mpKubjVuGquhFC9HaB5bM1G6uOUip2BpkKLO+A3FKG9a7Iy6wiAuQ9RGO8fYvaNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vI9PIMYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vI9PIMYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7177C2BD10;
	Thu, 23 May 2024 13:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470775;
	bh=yr7mGFKKZmUqj4O8InPltfkbiWnfMg3BPXIXpOqKgV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI9PIMYdt9ziJegWrROvVYBeN9Ysutn1F6ra+uqukBA51hYTit5u86CPOoTY8UaK6
	 ap80EX7L94yG2FUcuU/uN5Skj+qH+dli+u6cG7Pjcy3rab3Zqaef4oLESEeF7C0J6U
	 fMMDBOuveIAXjv5JkE3tBYtqpsqrav6OlJ3VCRNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/102] smb: client: set correct d_type for reparse DFS/DFSR and mount point
Date: Thu, 23 May 2024 15:13:18 +0200
Message-ID: <20240523130344.465297334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 8bd25b61c5a55bc769c6608e9ce95860759acdcb ]

Set correct dirent->d_type for IO_REPARSE_TAG_DFS{,R} and
IO_REPARSE_TAG_MOUNT_POINT reparse points.

Signed-off-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 29a47f20643b1..a0ffbda907331 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -482,34 +482,35 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 		switch (le64_to_cpu(buf->InodeType)) {
 		case NFS_SPECFILE_CHR:
 			fattr->cf_mode |= S_IFCHR;
-			fattr->cf_dtype = DT_CHR;
 			fattr->cf_rdev = reparse_nfs_mkdev(buf);
 			break;
 		case NFS_SPECFILE_BLK:
 			fattr->cf_mode |= S_IFBLK;
-			fattr->cf_dtype = DT_BLK;
 			fattr->cf_rdev = reparse_nfs_mkdev(buf);
 			break;
 		case NFS_SPECFILE_FIFO:
 			fattr->cf_mode |= S_IFIFO;
-			fattr->cf_dtype = DT_FIFO;
 			break;
 		case NFS_SPECFILE_SOCK:
 			fattr->cf_mode |= S_IFSOCK;
-			fattr->cf_dtype = DT_SOCK;
 			break;
 		case NFS_SPECFILE_LNK:
 			fattr->cf_mode |= S_IFLNK;
-			fattr->cf_dtype = DT_LNK;
 			break;
 		default:
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		return true;
+		goto out;
 	}
 
 	switch (tag) {
+	case IO_REPARSE_TAG_DFS:
+	case IO_REPARSE_TAG_DFSR:
+	case IO_REPARSE_TAG_MOUNT_POINT:
+		/* See cifs_create_junction_fattr() */
+		fattr->cf_mode = S_IFDIR | 0711;
+		break;
 	case IO_REPARSE_TAG_LX_SYMLINK:
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_AF_UNIX:
@@ -521,10 +522,11 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 	case IO_REPARSE_TAG_SYMLINK:
 	case IO_REPARSE_TAG_NFS:
 		fattr->cf_mode |= S_IFLNK;
-		fattr->cf_dtype = DT_LNK;
 		break;
 	default:
 		return false;
 	}
+out:
+	fattr->cf_dtype = S_DT(fattr->cf_mode);
 	return true;
 }
-- 
2.43.0



