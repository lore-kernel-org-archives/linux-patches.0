Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070DA3AFD15;
	Sat, 12 Sep 2026 09:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203976; cv=none; b=TQ9jMaHeEJB6PA4bPKI5E52KGJQuwHoKZQML+kSaJIqe+UeuknE0oeNErAxonvsvC8wxKSG7YpFaLYJA8HhArccf2Tg5ITEee4VL1mxFrHk8FZGjZGjxVdw23+CmUDMVKKcTXboK7JMqxgYMNTuNtx+Aw80WHbipSSBOGq+VjS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203976; c=relaxed/simple;
	bh=/5mo7dy3FLHvzR0HMxtD28vinCE8ftdy0jsp5+5KSYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGmKJIjb8M2f6ai6zsxsDXS5gOxcjFeICmcDoE6Amd06UzClkvJ4xPcjccFLqOOZ9ZJwN6fMjA1r525ViCigegB3O8axOoAfAUqadkEEVSWdZE5Cdq/7sIMu9bp8zykZULhqU2yovELuKcBYeingdlLAGfsc06xW4z1hufdyxC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDFhL676; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDFhL676"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD42E1F000FF;
	Sat, 12 Sep 2026 09:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203974;
	bh=2uydaxjgK8A3IDKZPs0OF6IJnjlAHG/Yjd24Fh2rm/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDFhL676VIruUkh42X7T6I6U8TYcbXavp2IIxnGJIjpL9yWMyKD9xkbTCeFEByIg1
	 /BJf0c0ljcpLX28nGFGmENHcNK4HLdhpKXN/Qo9JGzqrjKkeYY5ed9A9zUNynB9mmj
	 LkKslRfT4L79vKUzFmCmNVD1U0/OXwzsKUHzgBwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1519/1815] smb/server: preserve error status in smb2_handle_negotiate()
Date: Sat, 12 Sep 2026 08:54:29 +0200
Message-ID: <20260912065724.662036410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index dabf0a72a237a..843a353b4f882 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1576,7 +1576,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 				    KSMBD_DEFAULT_GFP);
 		if (!conn->preauth_info) {
 			rc = -ENOMEM;
-			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 			goto err_out;
 		}
 
@@ -1673,7 +1673,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	ksmbd_conn_set_need_setup(conn);
 
 err_out:
-	if (rc)
+	if (rc && rsp->hdr.Status == STATUS_SUCCESS)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 
 	if (!rc)
-- 
2.53.0



