Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEB04F68CC;
	Thu, 17 Sep 2026 18:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668647; cv=none; b=pTJYE2FitTS6xIiFGRCjFc1E/mb6Edij5q43eyU5VMeVKzug6DwGm7Gq8lUfeWddAeKdWeUpQdbLj9+ICs6jZUVR/iEx0GUdmK0LPQsifNefiWvbRhhc0vfjFV0sv2ToFlb9X7eLyXj14uXioRzh6ztpQhoihsrL8z3zADw+nWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668647; c=relaxed/simple;
	bh=ZNWD8nXq/x7dc/F5qy+yK4R6Ein/6ZpsSkz1HsIXYyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY5sdSyL+dXmbS9CXv7HtsbuOBlM2UGguA+RExKietwSN8wLGavzOkYNuaxDSxu49nJI6yUy5FDlPtwhLKJi4HDjgA7xOgo4IQPYvsgg3BSuqC7wY3SPwMMrDQ4O6LQeT9BZU741ESGoBEM0Ey/MMzXD/7KhgxGQGnWO2CJySc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yG9PXy9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yG9PXy9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10A51F000FF;
	Thu, 17 Sep 2026 18:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668645;
	bh=gpOa5+es791hEsiHjM6GA0ceMRk9tNcstmUKMz40fMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yG9PXy9LeLvZI5LvUF+lLs/x8PXMMzxvOOOM1HcGlK9FI4vZEoBrnVE/yTPNV7kM8
	 drz/T2mL9b79i2TmdsodH73PIPuEV6W76IA0xpI9dC54hU2X+mQl67Z1E2QB3v5h5c
	 WHOll9su2wcll+gBEDV/6uu3DJM3xqVPc2FKFH0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samu <nomomentomori@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0493/1102] ksmbd: use memcmp() to compare ClientGUIDs
Date: Thu, 17 Sep 2026 16:07:16 +0100
Message-ID: <20260917151552.095077626@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 464970f3af7c3..fc5689b2ea152 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1761,7 +1761,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (strncmp(conn->ClientGUID, sess->ClientGUID,
+		if (memcmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
 			goto out_err;
@@ -8132,7 +8132,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 		goto err_out;
 	}
 
-	if (strncmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
+	if (memcmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
 		ret = -EINVAL;
 		goto err_out;
 	}
-- 
2.53.0



