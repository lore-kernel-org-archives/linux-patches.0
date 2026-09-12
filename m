Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4154532E757;
	Sat, 12 Sep 2026 16:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231615; cv=none; b=uOP4x34zHGfQJaY/VU0M2RVNwpThCFCG+V2ZdxgczTcHGL8zvN+bddU7MIAtOPeJCrRh1YZ6va/hRkE+cHa84fatUWf5Yz/HhydP0EC2I5tWwxeL+5v2frnE5b0SYsEnlsqeWeggNzXR3W4f+V75NvMMBLI5IbVZWrqlGrRVzgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231615; c=relaxed/simple;
	bh=4Ss4X6phAa0JQy/emGujbuGYhuAQ2f3cXFFk2j2nZQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3Hg4ExEfjRnpYRliY2VuCQjObMi5KQhTwFkgMO1qWQ0U6nyon7oqYth8PoGVFdPQqG2G7fm5sLa5lr0R5G9LSQgDykhL0CQ/VOeywAdnqKT7AbIGTSke86IIGr9W5zxbgI0rGuXn4Y9dAO2J1ApoNgiYfvHT1+okXrTG+oPynE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9IDoYPq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9IDoYPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C2A1F000FF;
	Sat, 12 Sep 2026 16:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231614;
	bh=rMz8i+tRQGtj0ghM4eMFt4UpSQ/uH7mLh1fEEZh5XJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9IDoYPqmgmbOVEZLHFLBMsVYA3Mhk+h5VGLAN+Z3r9AM9GrTv6+9a+u/XXaoezEs
	 H4xVYqaGvL0xWo3BMxo9UcEYuFU4TLBD3wgGpUkwA6dhbqwGqav1i2KnXjbQ7hwhWi
	 Pw7fqId2txy0U2vHUDPX/DwG7p5O+LF+aCQ2endQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1035/1191] smb/server: preserve error status in smb2_handle_negotiate()
Date: Sat, 12 Sep 2026 09:02:43 +0200
Message-ID: <20260912065611.428026175@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit 73541bd2bab77e7e8e89b1edb5d342f4190dd4d0 ]

smb2_handle_negotiate() records specific failures such as
STATUS_INVALID_PARAMETER or STATUS_NOT_SUPPORTED.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bddf03ec337ee..7d47f7749cdc9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1175,7 +1175,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 				GFP_KERNEL);
 		if (!conn->preauth_info) {
 			rc = -ENOMEM;
-			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 			goto err_out;
 		}
 
@@ -1271,7 +1271,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	ksmbd_conn_set_need_negotiate(conn);
 
 err_out:
-	if (rc)
+	if (rc && rsp->hdr.Status == STATUS_SUCCESS)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 
 	if (!rc)
-- 
2.53.0



