Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24C43AF674;
	Wed, 30 Sep 2026 18:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794666; cv=none; b=FCg0jwdaCEnEyDKcYxOnVXvXdpAbBnpdhnWLMjPjFL32D8QGBZtrOkZ6RNBFGzbvLtuRK4pbXWb+7Vrs4ka0uZLahjoC4vwgwvVHbdCejSfMF3JvVNH3WmbgFGUHksnKjN3kJNxhq6UQL+1mLZduE0X4LTUgRpyhxKdVgKlNYCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794666; c=relaxed/simple;
	bh=+qqzV/IxM/lhF8P7AnP3/4788om6tbiytyzVPTrgrjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qVpWR24p7k/TPNu4wC6itRpeOAIYqIVdLmOhlw84R2YeMRVFAKBUvFtGF+zXIjopJ30h7UDRaPB9sj5km3/eIh68BiZIsokym2rl/ptELuWCyctX3XvUDYBwzltxpA4q6uS6+CaVRLDkRePb1q0wkrL1SeeDKmel+p5lo7R0p84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MP1VB/lQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MP1VB/lQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1051C1F000FF;
	Wed, 30 Sep 2026 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794665;
	bh=6CWI4ydQzMkqzkS1KauDyZ+VltV87tFFd9b+8QEton8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MP1VB/lQxiWH2QimuPfChlej8J84KfAEkjzAaM27QCpyT1E6mNqWlY57B4ga1By7+
	 BkJeNcl8Yda0qeLgi/afKxYqaM/Te4UbQLcpbPEJgpMTgAaOlW+kmZmIjQRqgCfKGC
	 CroC7SDXm2m65q3slack73nb/Xry0a/YkvrAdROE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0292/1193] ksmbd: mark invalid session responses as signed
Date: Wed, 30 Sep 2026 17:16:16 +0200
Message-ID: <20260930152440.651022958@linuxfoundation.org>
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
index 247595d8cb90b..8666ff471b39f 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -197,6 +197,12 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
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



