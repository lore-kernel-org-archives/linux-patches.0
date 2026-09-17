Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C871D54FA;
	Thu, 17 Sep 2026 18:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668382; cv=none; b=e/aLLg/DH3fPGBOsdy59rHF0BatemW0VZrGOgj2/engwfD9AeI4VwZij5W3zP7oyWJy6+tI1BiiGoy8pgdj1kRPHxcp2HPEZX1sqanhR1lS299vLh4xi/Hgd9f8BrqIdD9SRxEqu0OyfqP360L8Px/Tr8WHzTry22R+UpXSA/DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668382; c=relaxed/simple;
	bh=Se4WeI4enNKwg1kXmwpzSFYSfmPpE2ZfMkSpzHOEGhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KLDf1nDKT4Ygi48vb+hhzpyYJeILAh3beJyrpkhO8ERkoQ4dFk4MYN9In/Q6yHdM9uIcHEkU7Y9N/W+A7/64ZvMz8vp9/e3mO7s+sp8W6cetvpU7ekIuyiXTXKDHvEi38ShXWQrirWH37NSIRO2frOQBgTCKSuaq7flsd2P90ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUiDA68L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUiDA68L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9A61F000FF;
	Thu, 17 Sep 2026 18:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668380;
	bh=pL2Xa8xjDAzowK62mX9j6I45XSNri/dKkBNxHOR2WXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUiDA68LOlNiLfODMd+qCMognq9h8t14bnlfjHwd/2ieJ8xwNASkhhLAr2u66+mjb
	 caGM8Ft43GBhKvkXfV6GJJ/3868RIBMJAA5T/wjJvW6gW32VPHNnwJWSo2oOmgsic5
	 z8fyXWDZK7Lw9eG17rjX93NKZAYWPdkhlr447xnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0404/1102] cifs: Fix support for creating SFU socket
Date: Thu, 17 Sep 2026 16:05:47 +0100
Message-ID: <20260917151549.804974186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit dde3929e8d901ae9a7c29d0577ce9ca5cb4db35d ]

SFU sockets are natively supported by Interix 3.0 subsystem and also by
later versions. It is part of Microsoft SFU (Windows Services for UNIX) and
Microsoft SUA (Subsystem for UNIX-based Applications). They can be created
and existing (stored on local disk or remote SMB share) can be recognized.

SFU sockets are recognized also by NFS server included in Windows Server.
Windows NFS server versions since Windows Server 2012 uses new reparse
point format for storing new sockets, but still can recognize this old
format (also in the latest Windows Server 2022 version).

SFU-style socket is a regular file which has system attribute set and
content of the file is one zero byte.

These SFU-style sockets are already recognized by Linux SMB client.

But Linux SMB client is currently creating new SFU socket in different
format which is not compatible with all those SFU applications. Fix this by
creating new sockets in correct SFU format which would be recognized by all
SFU, SUA, NFS and existing Linux SMB clients.

This change affects only creating new sockets when mount option -o sfu is used.

Signed-off-by: Pali Rohár <pali@kernel.org>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3119d664e8684..0c5ea91077b90 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5216,10 +5216,9 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 		data = (u8 *)symname_utf16;
 		break;
 	case S_IFSOCK:
-		type_len = 8;
-		strscpy(type, "LnxSOCK");
-		data = (u8 *)&pdev;
-		data_len = sizeof(pdev);
+		/* SFU socket is system file with one zero byte */
+		type_len = 1;
+		type[0] = '\0';
 		break;
 	case S_IFIFO:
 		type_len = 8;
-- 
2.53.0



