Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A1A3D9DC0;
	Sat, 12 Sep 2026 11:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211459; cv=none; b=JPMawp1u6v+YXwqkUDbaUgTauNjcaagcsJnXBVtrg8o5mRWeUvOSUQmrnhNSfxa482oaT0EvcvPz6ePMRDcHjWJQGKvVXXMTzk8pEMXJgGzMwjg0X8ZTDD9A6rs8EUdkQ4HxRZ12Hwd4sH3PuNLB+TyB6J7k6AesSrGNaMQMd0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211459; c=relaxed/simple;
	bh=FFnIrnNb5OAp4h0sWADCd49jUCKXcOg2ngUcst/JhiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGQ9Yc0kKpQz7iDyPm3/kvReiU1Ml1nJ202rqIwsuTIqZJmv6kfhKbDwStu7Zy8Frcpq/zbhhIDU1FESgB89SB3h1ZatIxa6uo8CuQjQfZKrVbvVMVuoONX0pol8XUj0uaCy/WuedYTkr0RYf+jDRRC7PLv8AjslvdPuPYLgTDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BToncT3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BToncT3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5841F000FF;
	Sat, 12 Sep 2026 11:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211458;
	bh=WyqhlDFkT2lbT2NZv+37urPt1cl726+hYlrNBlBXF4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BToncT3AyW66gU1xWPpJKzca8JdWkWPpYr59EzCVocDlQkdvWIXT4KrerEGcxomH3
	 Z+Lw6xppXBscQe4OA5Lr6UMMZmiZ0VEMYs65UnVuZ23FiFthxkJG53ityr84PWv7M9
	 z1EtNY0dyv23KwMrY8DlJa4KS1O7815iOdx0J11k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1233/1518] smb/server: preserve error status in smb2_handle_negotiate()
Date: Sat, 12 Sep 2026 08:56:42 +0200
Message-ID: <20260912065651.398320879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 696d4473b7f13..89febfb8fc906 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1170,7 +1170,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 				KSMBD_DEFAULT_GFP);
 		if (!conn->preauth_info) {
 			rc = -ENOMEM;
-			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 			goto err_out;
 		}
 
@@ -1267,7 +1267,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	ksmbd_conn_set_need_setup(conn);
 
 err_out:
-	if (rc)
+	if (rc && rsp->hdr.Status == STATUS_SUCCESS)
 		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
 
 	if (!rc)
-- 
2.53.0



