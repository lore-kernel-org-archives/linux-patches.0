Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33833AF674;
	Wed, 30 Sep 2026 18:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794663; cv=none; b=iZbbCPCMJCNbcgu8vfA1nnXAGBzbRhSFEX5qR7jD/LoKTQ7M4LvtdyL7XemAq3hWy7JFTyHV2xn6FSUya3JCfSaJRaCtTOosRllvM2/eltDp6ouq4uBpezEEdWEP443eTu/SeusRTRSF1Yx0J0gb0j7RR/JeWklBtxGkj8LZQcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794663; c=relaxed/simple;
	bh=R0ZcxA9jJtqlex0y7J3uo93FMka8nCSHAWINPaTp0ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVYI/DotJDMsLgCKtCRBpDjJM3hlVk6en5VVNQuQ8/l6JMrwmHtyxGu7bm0w5i0kz3uC3osqFB8NtQ7nY4avgEwQaodNC/qdkg2uzVp9RfRYGR84vKv6ZG6Jbjy/L8QOkxn/oZh+62gKpvqIF9lDigmYwt7EW7HVIGQqCgShBY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/hdNB3u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/hdNB3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0671F000FF;
	Wed, 30 Sep 2026 18:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794662;
	bh=9o5MjXpS4nVN5Www6M5JTmKtxs4eMHsXqBQ/htQRVo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/hdNB3urEecKEGzkFj7qRbkfuKQ76hFJUIWH5pDssc7Ojm755sUcyR4vxL23A0Te
	 u6NhVVmgVJS91Ym98QxtwHEKWDyIw25QfO4K6o+/twcVqYqA7f1SPr/UwE0FD9TkmI
	 R8f3esn6TfK0IAeJ4FKsf1iqxLqZcMfXt7QOWDhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0291/1193] ksmbd: find bound sessions during reauthentication
Date: Wed, 30 Sep 2026 17:16:15 +0200
Message-ID: <20260930152440.626725829@linuxfoundation.org>
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
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e9a3fed457c38..293ebee718912 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1784,6 +1784,13 @@ int smb2_sess_setup(struct ksmbd_work *work)
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



