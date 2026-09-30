Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE11851DAEB;
	Wed, 30 Sep 2026 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784738; cv=none; b=fD+QBFPO9ID5c5xg9DA7hSFGDH5O8o39jALCQrrFEBNMBEjRNNTNaPy07C1MOzA0zWixIr26bTtzSYm4X0HxgwewelM63igAixh5ijx+ltY8i5RGdEMbsHK3Sxg4MMMVZWafoit/dYzRC8BIp5CWqzvFaAJJiYrGbjVrTBpKKAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784738; c=relaxed/simple;
	bh=Qn2L7TD/Jv43dm3iwC2FtCh/nQBFpR6TecHWFPep6T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Veu4KJvO6c2MJZ2eI7++7ZMh8yA1hya7GSgJUlDR9jLPereJFB/9SiWeQPmV59znfXMJ9swJHPkX3tplLnaN0oVK8W46gG2tSRCns6K4Cf4J/So1FtPmGbmu7zkz4kRkroAditQinqMnZXYXuM7t6e45jirYng67E3OChIVLCX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJ6ZqqRH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJ6ZqqRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7561F00893;
	Wed, 30 Sep 2026 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784734;
	bh=+eXWMwSiya3bP540hs3fQUHRkxGSOJhpj8SXNrbRwJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJ6ZqqRHD7il5T7k86eh8Ga29M/P0fmtyy7n1pSGM6mbODQzKVrLvSgPjP5q7VBIQ
	 EE/3cIbAEhY7JhAviZ2OJcUqMz6Rt8vv4nEf7r+KKdEL8pZiWwYe8uonfWtKb90F/K
	 sVIlJMUoKGLoaN3mhvMqx3vRN6JMbVoAyo4ewNIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 253/982] ksmbd: mark invalid session responses as signed
Date: Wed, 30 Sep 2026 17:16:29 +0200
Message-ID: <20260930152422.230313485@linuxfoundation.org>
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

[ Upstream commit 9e8ad620ddfde5a5f4ef58372e3805e9388cb0f4 ]

When a signed request uses a session that is not registered on the
connection, ksmbd returns STATUS_USER_SESSION_DELETED before reaching the
normal response signing path. The response therefore lacks
SMB2_FLAGS_SIGNED.

Clients that require signing check this flag before handling
STATUS_USER_SESSION_DELETED and replace the server status with
STATUS_ACCESS_DENIED when it is absent. The protocol permits this error
response to skip signature verification because the connection has no
matching session key.

Preserve SMB2_FLAGS_SIGNED on the early error response when the request was
signed. This lets the client propagate STATUS_USER_SESSION_DELETED.
It fixes smb2.session.bind2.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/server.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index ac7477edc62f2..a5e9bb40e2191 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -195,6 +195,12 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 				else
 					conn->ops->set_rsp_status(work,
 						STATUS_USER_SESSION_DELETED);
+				if (conn->ops->is_sign_req(work, conn->ops->get_cmd_val(work))) {
+					struct smb2_hdr *rsp_hdr;
+
+					rsp_hdr = ksmbd_resp_buf_curr(work);
+					rsp_hdr->Flags |= SMB2_FLAGS_SIGNED;
+				}
 				goto send;
 			} else if (rc > 0) {
 				rc = conn->ops->get_ksmbd_tcon(work);
-- 
2.53.0



