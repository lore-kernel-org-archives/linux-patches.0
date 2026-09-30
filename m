Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E633CE4B9;
	Wed, 30 Sep 2026 19:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794886; cv=none; b=EvhdoldKZvLugvlY5P/W+k4UWJb0J/0027tdsZdnIjymc2cLGxzSW7FfAjZGXj/PvXb+SZGUTa/DmIWx8x6Zc1WlHzuNqB3oV0N1iNKfJxYGJizMYioDf+/x6LlqNG59QvsNYOwJDanIHn9CvHCpTwr1D7uw7W1y5u5bmBWsph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794886; c=relaxed/simple;
	bh=704E0emm0JdKUHwkY64OhGlrn3KUVjgncqY6Ytb/MSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTYDt3+wrspDmT2pKiSwybOKR1eY+FhNroCoyS8iWAHweavuB4VAyPI8uEGLvxHduX5TWfG80D41BUhuVQNJvatAUPZrP9FAUAi3Ju8iL8Dvyg4B1J2lBH9i44feAGIuq65UgfJtyCDCpYzrx0IqMn9N7uG+m5EwtgvYax1DWtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sG6fjc4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sG6fjc4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C3E1F00898;
	Wed, 30 Sep 2026 19:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794884;
	bh=QE+7ccT0VagYoV9LZOqLgh+MnzXyh254iFf6vMvJhZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sG6fjc4KA+WFc7Kx5ji9X04wGceizO5BRgcddz9jMf63f91l1fC6ooOUHkY5GqaaU
	 bJnwKu7uLeMU0e65G3fBPLn15ITn1QHtfvUJbVrnj+Y4Qs6VrwZxC9rW78iF3IIobi
	 RMJp1v7GxODDRHz76m8SD++gSsIpcBhokLvm2XH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samu <nomomentomori@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0365/1193] ksmbd: use memcmp() to compare ClientGUIDs
Date: Wed, 30 Sep 2026 17:17:29 +0200
Message-ID: <20260930152442.286508077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 293ebee718912..6fd7efe45fef0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1741,7 +1741,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (strncmp(conn->ClientGUID, sess->ClientGUID,
+		if (memcmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
 			goto out_err;
@@ -8106,7 +8106,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 		goto err_out;
 	}
 
-	if (strncmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
+	if (memcmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
 		ret = -EINVAL;
 		goto err_out;
 	}
-- 
2.53.0



