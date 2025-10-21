Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CDA25A355;
	Tue, 21 Oct 2025 20:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077402; cv=none; b=fVt6EP6QJxHNZ2RZkHRziOFTKjC0jzxKl9TOgWIHa6SjFhRqy6bTjgVMuN9dJtQIET7YV2bdiBSeJ0IH75QffnyDZUxEJXva7PF4Pr5YNSdLs3wSLpSiuFCi/NsKV0Bj1FKKbtiL8T6MjHS0oMnunql2y4XT41nzri9Bfhx6oIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077402; c=relaxed/simple;
	bh=2wqH0yk7xD6qO3BlSB6QxpoF9e759tbSwB/ecke7808=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDvOC3mSMFhVK4o6AtfM3BvN4PRxrTNTDIBltLZw9vrmgbiaV+jK/CrQFer6he6t+9Aw6RgCkQ7xR6vqne6HLHJ0+tJ9yZ5VCjO3caOdIhNNU7NHwy9Vzqg3n9+AIR4NCvNPyVo1FlfWcCIOdt/UN5UuIGXAp1B0ANo0H9ebiik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLEI9HaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLEI9HaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6F7C4CEF1;
	Tue, 21 Oct 2025 20:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077402;
	bh=2wqH0yk7xD6qO3BlSB6QxpoF9e759tbSwB/ecke7808=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sLEI9HaIlwBRo2gboeVNZDBLh3p9mWiq/IGfSMzWZkuloKpNIi1+dClariTY6ur2P
	 K3ZBKUALt0qDdPnub0jylGfN8dr62G8bwpPgCWnvPXxujV4edn6p0LXsQXOl4ofSn7
	 hpnHeVq9jvbLI/LS2Z+APo5E8Vmj2ux3It+5DYm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 087/159] tls: always set record_type in tls_process_cmsg
Date: Tue, 21 Oct 2025 21:51:04 +0200
Message-ID: <20251021195045.280882879@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b6fe4c29bb51cf239ecf48eacf72b924565cb619 ]

When userspace wants to send a non-DATA record (via the
TLS_SET_RECORD_TYPE cmsg), we need to send any pending data from a
previous MSG_MORE send() as a separate DATA record. If that DATA record
is encrypted asynchronously, tls_handle_open_record will return
-EINPROGRESS. This is currently treated as an error by
tls_process_cmsg, and it will skip setting record_type to the correct
value, but the caller (tls_sw_sendmsg_locked) handles that return
value correctly and proceeds with sending the new message with an
incorrect record_type (DATA instead of whatever was requested in the
cmsg).

Always set record_type before handling the open record. If
tls_handle_open_record returns an error, record_type will be
ignored. If it succeeds, whether with synchronous crypto (returning 0)
or asynchronous (returning -EINPROGRESS), the caller will proceed
correctly.

Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption of records for performance")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/0457252e578a10a94e40c72ba6288b3a64f31662.1760432043.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index a3ccb3135e51a..39a2ab47fe720 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -255,12 +255,9 @@ int tls_process_cmsg(struct sock *sk, struct msghdr *msg,
 			if (msg->msg_flags & MSG_MORE)
 				return -EINVAL;
 
-			rc = tls_handle_open_record(sk, msg->msg_flags);
-			if (rc)
-				return rc;
-
 			*record_type = *(unsigned char *)CMSG_DATA(cmsg);
-			rc = 0;
+
+			rc = tls_handle_open_record(sk, msg->msg_flags);
 			break;
 		default:
 			return -EINVAL;
-- 
2.51.0



