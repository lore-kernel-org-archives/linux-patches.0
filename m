Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945855111AE;
	Wed, 30 Sep 2026 16:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784885; cv=none; b=ChvSbe8KBrYARSElGKCOrnIOLKxJdP+6cu4C5sIpC/FKolS9K2i8fiebJRyotR7I8eWq7ZsZp+C8IWAmle8pGtxtJmQKx89v1wprhIuYscbgOkAb2qKs8rDjZ1k7uzm/mdMXGzoa5LNWo8+87nfU7W7EQzMQzbndV6CGW4N4e+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784885; c=relaxed/simple;
	bh=Uc9nmm5GZI0ba7bm6kuN+kBQeZbLuwFHZmLK7gY+Rm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuDxWI4oagTFogQUUWPtJgsdWw/gd/2XBQPNcDJmMzSDmUkAIpD5tiR7D0a5bNFA3A3iL8JqVReZJL/XEpmfecjH4ve33QeyccwepaxlRhPD0x+Z5vy1X8C6U/DYwQ/i52oESR1yK1DIR+UCjVs4UYQiJGr37OugaVYlBa6ePl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGks9aoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGks9aoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03F41F00898;
	Wed, 30 Sep 2026 16:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784881;
	bh=Q32kZJmX37DxLSkNXJY48yTwGM/T49sPjf5V0azQB/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGks9aoo3f+hFhpogXgLYxkoTRItcn4KRJuLJUYrc8FB3+xS4aikmDc+OhS/HwLJC
	 gtzY9B5gl85D+LcTwP3D9yQtX3K0FDSa+yM/GGTojJ3+qMveNTfHkK/xQzqQpYuh5T
	 bwnFEosHnhGURu6m48C8nGuM6xIpTA/222aXRhvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samu <nomomentomori@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 313/982] ksmbd: use memcmp() to compare ClientGUIDs
Date: Wed, 30 Sep 2026 17:17:29 +0200
Message-ID: <20260930152423.542121652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index b5861e830aba3..f30866efe2f4f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1745,7 +1745,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (strncmp(conn->ClientGUID, sess->ClientGUID,
+		if (memcmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
 			goto out_err;
@@ -7632,7 +7632,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 		goto err_out;
 	}
 
-	if (strncmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
+	if (memcmp(neg_req->Guid, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE)) {
 		ret = -EINVAL;
 		goto err_out;
 	}
-- 
2.53.0



