Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3629151B171;
	Thu, 17 Sep 2026 17:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664848; cv=none; b=P0uGJYzRC5vvbsBwDqKHAV6qfeHFTkNEkkqBYyyf1krdEWpAJNrPAsTGJ83hO1+WXiMxiDcdcKuI5fBhN4SU8/JtCuTxKcj9z0+SUd+irYGlxmm66ATZFNS09oFVRuqTtEGoH7v6ow0Ts8s4rTHTasO3X9kOWQKdde6Ns8kg5io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664848; c=relaxed/simple;
	bh=Gh/WglrI5pYd5kbW3qsMULqYXizG1Wr9OCr3oHaCPxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jYHqP2TciC6os+z11iG/NkN4rgOvI/O++lDtyrnpNIgrTgLe7YulKyN1AoVZ3OgzaI7m2D+dV28+RbnmbL4dKQXhHi1YqMCF/jziQu8HnzvkzY58O2ai9qQ3yVGyrrZHTRI2Y7DYdspvUzWOVEz76nBp7yuexXlVUnBfF9soh24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/yFFjuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/yFFjuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590D71F000FF;
	Thu, 17 Sep 2026 17:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664846;
	bh=39NBHjOjCpmpWlfT764ZEjulwSVBMx+YxfLz7WTr630=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/yFFjufYkikiPsohhs0safHT9RR45p8hVrXiyycIuJwv7Xc8+GXQC0oatSpbfBIH
	 FuhtV0/vkBDHHfcEgB06M8L5rabbn2yHRZUeyZUIRZisg20Z4xcGwiauTPZo4pZUry
	 Y41I2GBYRUAgVtY/YXAph0yEC3e61spV5eScLUbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0507/1250] cifs: Fix support for creating SFU socket
Date: Thu, 17 Sep 2026 16:05:02 +0100
Message-ID: <20260917151605.701998579@linuxfoundation.org>
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
index 2607d4a02a497..cd3694f7179d2 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5345,10 +5345,9 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
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



