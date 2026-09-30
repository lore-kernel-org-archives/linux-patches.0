Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD69651B178;
	Wed, 30 Sep 2026 17:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791132; cv=none; b=u8La24tlzL54UN+kBeIV8e8/IV3moXu65G7XCVVfxGnSm0Se9hbSKD3C5s1NZfbBcCnSg4Dc0yUcbhkGPth7XgvGJ3q8iZWGggzKir+pQLcZt/N6F4D5ceduCR7eXriczc01I6t+L9AQ/6kNOSzX8h3c8vzkUOp/yE1JPuTR6wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791132; c=relaxed/simple;
	bh=MX2yjRlqkL5rgUquKwpqlKvUscH+OgQdPfSIADmIidw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3mXVe2kz4YSuYJhF9SN7XDot1+iW8Y/EQ7Uv2zgVnPIpFpZZHYwtWemwsXnCuGWeqqdynN9tg0YpFJiRO4Dwl1EHBAalNAkg0J1AvBPxbnJ7xpaieHC8BonjvvapyeC/RHQSn6QcQfPtsKKUUd1TrfGyleNL+7mMOCN5R20Gk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxxNK6Uw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxxNK6Uw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435841F000FF;
	Wed, 30 Sep 2026 17:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791130;
	bh=ieXzl+EjyDS4nrmbll309psNH03BFMRrl5WBGYGyE8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxxNK6UwFv/dMsVBYOcaxjahYV78pbBzhezWCRmHaKUuXL2oImZJJAWkxvhguxU1q
	 4OHS2IMckbBiyyrszE1UGzo5G9OrvjbY8MYPH0l0Y8bJFyXKuk4W/0MIUeRMx077cg
	 s6YnNMWXUro8hKXqeZ5F5849n5T8cX2EZXwITcg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/752] ksmbd: find bound sessions during reauthentication
Date: Wed, 30 Sep 2026 17:21:05 +0200
Message-ID: <20260930152402.437417234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit faf8578c77f3d846aca9cd882c293e03eafcc6df ]

A session bound to an additional connection is stored in the session
channel list, but it is not added to that connection's local session table.
After the binding exchange completes, conn->binding is cleared.

A later SESSION_SETUP reauthentication on the bound channel only searches
the local session table. It fails to find the session and returns
STATUS_USER_SESSION_DELETED instead of processing authentication and
returning STATUS_LOGON_FAILURE for invalid credentials.

If the local lookup fails, look up the session globally and accept it only
when the current connection is registered in its channel list. This keeps
unbound connections from using the session while allowing reauthentication
on an established channel.

This fixes smb2.session.bind_invalid_auth.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 67f0a91530572..be8a541b694f1 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1795,6 +1795,13 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	} else {
 		sess = ksmbd_session_lookup(conn,
 					    le64_to_cpu(req->hdr.SessionId));
+		if (!sess) {
+			sess = ksmbd_session_lookup_slowpath(le64_to_cpu(req->hdr.SessionId));
+			if (sess && !lookup_chann_list(sess, conn)) {
+				ksmbd_user_session_put(sess);
+				sess = NULL;
+			}
+		}
 		if (!sess) {
 			rc = -ENOENT;
 			goto out_err;
-- 
2.53.0



