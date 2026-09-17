Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C566395AD4;
	Thu, 17 Sep 2026 17:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665009; cv=none; b=Bu/NoHAB6krvXecUcbQvHdNJACgkSZnVBabu7c58dX0NORAwI4ULyOZ5y1Sh4UVhXHM2kdeFAHLpKyIIHVwjHgEI9LtqzEmL3q5Gj0HxOFZK8B+kxs4StZzSOc5a7IZIpxB1pzJJFbVTdnzyvy8EmQjP6EvGI5Np0h0aqMjnL74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665009; c=relaxed/simple;
	bh=eCq9RFV6fbJ+3IGom1a+Pm6m/0Ccfzycami8qSfVDr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xi1O0I171ubGUCXZlZ0MyApRy5ApJfvKa/gcYp6fzziAWdI3OGNXpEQOmLFPkZtjW7FwdG07yJ7yA6ds94AZ3X3VtOB0VygjkRaFljeKKVwCAAM3qvIxwqfk6qkRHXIcPkRYL/iqtYs26pnLsWlQGuznCe30Fu9stLOJbnUYvUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5xkYjh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5xkYjh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E061F000FF;
	Thu, 17 Sep 2026 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665008;
	bh=bCpLM/3NGUDW6dPvixcrOaGYmuMLvrxR3S051jJvkzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5xkYjh/ukKuDaQU6iqxbP4LqklGIKwDK6PA+3qUX3r5xOZ0JZxtGUqWu9Gud7mkE
	 FBmL5Q1KqY8TaiUl+3o7dfQh7vjrURfvwbT0cwLUv+QfO0To/NrJBtI58RvpUaJsCU
	 u1kFgICFq3dOn658bnouCJd6blsMbq6KR0qPPhMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0512/1250] cifs: Fix support for creating SFU fifo
Date: Thu, 17 Sep 2026 16:05:07 +0100
Message-ID: <20260917151605.837612197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 608362facd2d0f2667f68b7f42207707d59a0071 ]

SFU fifos are natively supported (created and recognized) at least by:
- Microsoft POSIX subsystem
- OpenNT/Interix subsystem
- Microsoft SFU (Windows Services for UNIX)
- Microsoft SUA (Subsystem for UNIX-based Applications)
- Windows NFS server (up to the Windows Server 2008 R2)

Windows NFS server since Windows Server 2012 uses new reparse point format
for storing new fifos, but still can recognize this old format (also in the
latest Windows Server 2022 version).

SFU-style fifo is empty regular file which has system attribute set.

These SFU-style fifos are already recognized by Linux SMB client.

But Linux SMB client is currently creating new SFU fifos in different
format which is not compatible with all those SFU-style consumers. Fix this
by creating new fifos in correct SFU format which would be recognized by
all those applications and also by existing Linux SMB clients.

This change affects only creating new fifos when mount option -o sfu is used.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 248ad60586e2e..1af1789bec5a5 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5350,10 +5350,8 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 		type[0] = '\0';
 		break;
 	case S_IFIFO:
-		type_len = 8;
-		strscpy(type, "LnxFIFO");
-		data = (u8 *)&pdev;
-		data_len = sizeof(pdev);
+		/* SFU fifo is system file which is empty */
+		type_len = 0;
 		break;
 	default:
 		rc = -EPERM;
-- 
2.53.0



