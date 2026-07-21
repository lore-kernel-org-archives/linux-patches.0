Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD78135C69F;
	Tue, 21 Jul 2026 21:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668652; cv=none; b=OHCNYaBauOe77Qs2PG2l7JERe+U7Sp8jpsTraAoDV5cYOwM9lYb4HJN5/IuAl+tSwv+2MlA0bGVGAFP+DY5SsyDXuv/+Ah+Yx7X1S84R7eBImMINNHkZXJFr47wJfrOMacu/zg4mBcRaEs3G0UaiqJUaIrVMVHdzQ/RXJW1rM74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668652; c=relaxed/simple;
	bh=kVvTmeVPWsXOPzvUhpz0Vqf2uwrKNLt2y9uWDl8TilU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cbi+8bG3HNR/zIU6z+73Ebb+T04GdPCIUoy7OUZxNmcVoXcqVl0wQtfm+T+OCLn8n+CzgOwBZHBPGk3ws92+iJIVICU/y5EutwpZeZJHlDLSZMkYO55x8AQMHAggNqO+GPLC71wFoYsWynAiNvabktrW9Z3PVwFXV7jY1b3X4Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxLmNEgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxLmNEgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F0F1F00A3A;
	Tue, 21 Jul 2026 21:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668641;
	bh=UlRdDlnRIfozzVm6mlxlSaeqoYAIUu788/KnwkVhxF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BxLmNEgc8y1gwJnWIi5YwMSL/fKnOU81Y2JeA5rAesmmhPeciIwRlw94ZvEmgSjpq
	 a4YFqJAVsHA50GSdJyE4GBbPDpijc/aXiwwxWjhd2r33UyIDJT9b1Kn8+O7aGP604E
	 uwRLKVZcCrqeYEfuFQztOj3YtZxuMCilkSXqSn40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0254/1067] smb/server: do not require delete access for non-replacing links
Date: Tue, 21 Jul 2026 17:14:15 +0200
Message-ID: <20260721152430.280158396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7bf915e08f909e..09b896739e74cd 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6060,16 +6060,18 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
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



