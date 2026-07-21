Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35B14F7978;
	Tue, 21 Jul 2026 15:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647845; cv=none; b=UEFzwFwu6oqOgI/n6eTuTX/szhWdo8QeL45gzNTTYkeMwDM/xnfgquxOagWwOd9tFZioviWW2MhM59/IQR3GX6pEkAEvPt/raYhC2327pYsBz9T2wRZB4DysvcirLTYcVD+dKxykgwNoGjgc59MdTgXdvfDz0n7Roa9QPzk6Lbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647845; c=relaxed/simple;
	bh=Z7229DfM3fD7t+TaNQ/6XYYKF2pY4rb7I8LDDlm1wcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz+aXcqbsntlJzsax6U0myqayg2xMQRyI9mvZMtkVDWtjTFa6NIhQs5s44b1XteUc72KmRIdqTaO8ldhvFYQdrC9qPyzi8VJ+7QZ3emmfBfzM3ttBjVe83/z9emKRLZiYxUEG++2uf6+dzTBnDchICbmEq4aaWHDufe1YOkIbnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aiQ43IaM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiQ43IaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B27E1F000E9;
	Tue, 21 Jul 2026 15:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647841;
	bh=ImuZJ6OGFxqxqDylec+tbIB9fMmNoRCA1fU/CWWCYew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aiQ43IaMQwXiR34TFjJHm0FrDdbfelwDyRiJtTiRGAurRlsrnhYEyJ7aGX8CG2nlx
	 uIJ52G8duzCXqI2pryfd7ZgZgzO4xpeeEiUPt2BWPFxf8zWatkICdvfjQ8hSUvwNqv
	 vqtatQHgVmcWR91VdvxcV7YlU+Bddxsj0Pg0n5aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0002/1611] smb/server: do not require delete access for non-replacing links
Date: Tue, 21 Jul 2026 17:01:58 +0200
Message-ID: <20260721152514.819788524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 50e36050f9ea3c..44b87196c5afca 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6572,16 +6572,18 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
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



