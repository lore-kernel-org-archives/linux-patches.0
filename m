Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68745490C15;
	Sat, 12 Sep 2026 19:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240267; cv=none; b=SZrraMhU7Ju7UDxCoTwePYxZBnx7Gvo1TEonmXtSfN/TYppGFdIV3Uk8m+PDudXHmaX07SCvJ05r2AlI2jRMefWtOSxtxe/olsYIs8cRvE/ySdL4TFVB91I/p5NTFhlnB1zYZnBKhb6N7bX1R/+VsGFjTR6VrtkoQK5CHCznZhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240267; c=relaxed/simple;
	bh=ZMJBDxlTrprvcNwpYcUZ9qBOcZuXNRBw1zzLiZL8c0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rjlq3mlMTXXv6BIo/GkiI4/4WO60hogfu917taOlH8Y/VIKmXnauN8nPyohCJJ/M6MV+Qmp6KMya/HYZ61TMNj1nJwGHSD/+kdMovMIbVbn868cDcl10adtaKkzljuPerjrE4eYBnwhiob48kxFOOk1h4bH+0K/PI8hTtBVF+6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJO2ACy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJO2ACy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6B61F000FF;
	Sat, 12 Sep 2026 19:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240264;
	bh=ozjjUaLusWiHzP57Gw2h0B8mVeVK1SmY2bLYsG5SLmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJO2ACy3FgFd0D7DMe0EypEg4PRRYzCcEA8fds8MLVr5LBFubRYMAeVYa9X44tVSG
	 rLLt7QvcCZMDI3JStg5vSTynNK/pRbAPtvpLM5Ppfaf3zH2gvzSriN431TZnHFd4Nn
	 txKjg6K5wuNiX1eTkCjputkN8TO0vqMxp2FeIklA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 833/935] smb/server: preserve error status in smb2_handle_negotiate()
Date: Sat, 12 Sep 2026 09:04:23 +0200
Message-ID: <20260912065545.928637425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 2ffd78ef7da26..31b198b3f01df 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
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



