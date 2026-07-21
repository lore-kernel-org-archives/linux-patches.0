Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0394EA37A;
	Tue, 21 Jul 2026 15:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647792; cv=none; b=ch2gs/hTpDeSnYJJ7ljeLFnFHjfCYbeiEvxkHJJBisfM1sw7KwvJENX3cHgyR+jMlqFy6dajyopYn9dVQX0NkK+KD79VECnpBcHqJ83cALVutyyeZKXp7OT9ErY/WX1wOERbov/lAtU8HTvlaR/HNjxFr6cqWKXPeDrJ2E8ZlWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647792; c=relaxed/simple;
	bh=6fEghSmqWxHvOh0qrebeZNtmcc0dL2jz5JbtPkDkHyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TB/X9oe6B9VMVzS/fefxm1KFWcXsmr72AFqgOnLv/qMAWU75me1Rxycbhk7WZfPwBhE8H5iPKTNxQsPFgsyY6+c6kmjHXnOJWCjLESGnenDcJx+67h+/kV4n76RtKszW3gEm0FvkLyDfeUXh/pCP8ewciDizFnYQC/KeobCKPeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbHDAwNH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbHDAwNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09E91F00A3D;
	Tue, 21 Jul 2026 15:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647791;
	bh=xJ9yi1XQ7jbtCnPdTDwIxEa+Q1Co4EahT9ZrdgYx040=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FbHDAwNH+K9Tk98m65mu6+fiI/3l+u8HTemF+xdE+sSwEneb+xTr0r1eGcVF3ScHm
	 fJW17LqDER0dbHGNSTV/aiexulHogffoW9fcLmxdoXwgumOBm/5XNgiPD4wYwwZ6JJ
	 akbsXFVTzyze0yq7x8glZqdbleDXiIT02vsiWC7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0001/1276] smb/server: do not require delete access for non-replacing links
Date: Tue, 21 Jul 2026 17:07:24 +0200
Message-ID: <20260721152446.104584711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 851ed9e09639e0daf79a506ce26097b296ed5518 ]

Reproducer:

  1. server: systemctl start ksmbd
  2. client: mount -t cifs //${server_ip}/export /mnt
  3. client: touch /mnt/file; ln /mnt/file /mnt/hardlink
  4. client err log: ln: failed to create hard link 'hardlink' =>
     'file': Permission denied
  5. server err log: ksmbd: no right to delete : 0x80

Fixes: 13f3942f2bf4 ("ksmbd: add per-handle permission check to FILE_LINK_INFORMATION")
Cc: stable@vger.kernel.org
Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2fd1fb03c01e21..f1cadc029677e8 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6526,16 +6526,18 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 	}
 	case FILE_LINK_INFORMATION:
 	{
-		if (!(fp->daccess & FILE_DELETE_LE)) {
-			pr_err("no right to delete : 0x%x\n", fp->daccess);
-			return -EACCES;
-		}
+		struct smb2_file_link_info *file_info;
 
 		if (buf_len < sizeof(struct smb2_file_link_info))
 			return -EINVAL;
 
-		return smb2_create_link(work, work->tcon->share_conf,
-					(struct smb2_file_link_info *)buffer,
+		file_info = (struct smb2_file_link_info *)buffer;
+		if (file_info->ReplaceIfExists && !(fp->daccess & FILE_DELETE_LE)) {
+			pr_err("no right to delete : 0x%x\n", fp->daccess);
+			return -EACCES;
+		}
+
+		return smb2_create_link(work, work->tcon->share_conf, file_info,
 					buf_len, fp->filp,
 					work->conn->local_nls);
 	}
-- 
2.53.0



