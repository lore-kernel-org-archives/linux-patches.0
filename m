Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A30450E5BA;
	Thu, 17 Sep 2026 17:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665116; cv=none; b=iOOgk13JCBfxD5gtLpWZ3AYbpQIsgaTjKtTljggGQg7ZTGvXiiLj1b77fe7LsehNtAxl5YTOTEoZZQ9RPo40THcMl89sGdMLa4Sus0VtzQERjv1V1MpeWdl+zY/uxkdGqRgrMAXK2UBTHmmDZYL8EZlN7KBH44oC7/lnZZgbP3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665116; c=relaxed/simple;
	bh=0yyVcWCmnGxx9zr0Gd06LiHi9RrfXzgmOjTfKBDJdqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQVdmIPjVwF4XymWUXPyDFcgg7EqaIX3CdYuFvqseNoA9SmiOChB/dkiNHlHKwND80uU8Un6ux9w4vK7bcY24uWVYK5WCb67RZHUSMrUoPfck7w8lFHj6CPjF2przR8sA5EZrZgJI4/HxksFmbdyyZ7XiQ/ZdBy7zX0A/njmdno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ibFLIeZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ibFLIeZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060BF1F000FF;
	Thu, 17 Sep 2026 17:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665114;
	bh=fxdD2QXfkjZ9Tgs4B98l4fkARN+1Fb0akQ1xJLif7tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibFLIeZZai8GYPjGzQUNS+EW+KDfZ5fM3J5QRHDMTbGXZIPcrymX9E1gbFnqs5JhH
	 vTrCzTQ0zHL/KJ1Fm9CH0zshdnboD2RnYmhQA1yJHpaaDNL+A1IluWZ8AgbLqobnYP
	 BAFd6K+JgNpXzP4NXetYSnNviN9V28WnqFIEI5uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samu <nomomentomori@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0595/1250] ksmbd: use memcmp() to compare ClientGUIDs
Date: Thu, 17 Sep 2026 16:06:30 +0100
Message-ID: <20260917151608.009140989@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e8bb506e6ef749ac0336f3e579d8d02396b7d832 ]

ClientGUID is a fixed-size binary value and can contain embedded NUL
bytes. strncmp() stops comparing at the first NUL byte, so different
ClientGUID values can incorrectly be treated as equal.

Use memcmp() in SMB3 multichannel session binding and
FSCTL_VALIDATE_NEGOTIATE_INFO to compare all SMB2_CLIENT_GUID_SIZE
bytes.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Samu <nomomentomori@gmail.com>
Suggested-by: Samu <nomomentomori@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f2a53841e8a81..88e4176dd97ac 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1752,7 +1752,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (strncmp(conn->ClientGUID, sess->ClientGUID,
+		if (memcmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
 			goto out_err;
@@ -8170,7 +8170,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 		goto err_out;
 	}
 
-	if (strncmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
+	if (memcmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
 		ret = -EINVAL;
 		goto err_out;
 	}
-- 
2.53.0



