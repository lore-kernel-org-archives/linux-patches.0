Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E8F4E77FA;
	Thu, 17 Sep 2026 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668441; cv=none; b=R1WzOGQAvKNBAPkFW45VE57yg1NdXK4wyPyFJpPQEpJ2z94L7QnEhjQ8r40xYgX27Jzhg3wH3h6rHhqgNL+NkjHcv4FV4ZSNoykqf2QgvXgHM3q1qQYtZ+7AZmJHlV2pQgG8AkSUg1TTGHAjrlCVYE27+e5V5xLMJLCZQDFjnPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668441; c=relaxed/simple;
	bh=DSL1+on25vU+3+lvbTxeu7mapFHwrMIGEHbNFhI/PQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WwUDkuXPtQorO3WTfnueIMlzyMJbPvGmhkEcWTSBrWT7OsFueI7IzMgbrv9w3usMvnJ1vM2j+WdLLTU7Olj1wiIEUQIvhCRGpEew1vzWQYyOh4Uk4uMJInDEucdnPrGmW+/hDr2EDbScHeOrqTjZpWVeoi5FgJdWjpMOCK+yJa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMAfvjb7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMAfvjb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32021F000FF;
	Thu, 17 Sep 2026 18:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668440;
	bh=g1D18dXORf5Q378HZ677tb7LJ7zLdtZW2qpXlW5TUXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zMAfvjb7carPG8vxQ+iwZ5lI6NM+g9+LYUT9sTTeFEoOMqeBM+NYcr2Q4PKnYKHgF
	 61fu3XbVdz27YZQVVCzO8BLsWD3yDIFiISW0zjoNAnry5Lf/qnR+BNpk0dP+M0y9UI
	 AaK0t4Jgc0ODnr4U6JdlgR4plQb4rKz8YtO1xRbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0409/1102] cifs: Fix support for creating SFU fifo
Date: Thu, 17 Sep 2026 16:05:52 +0100
Message-ID: <20260917151549.932346741@linuxfoundation.org>
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
index 7d91bde2fcaa3..70f2ea70fb3c7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5221,10 +5221,8 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
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



