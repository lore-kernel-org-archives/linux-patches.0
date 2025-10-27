Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EFA3328F3;
	Mon, 27 Oct 2025 18:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591570; cv=none; b=OBMPedjk9k8LDlac0YxH77aE2wzRU5V4O30sG5wfMni7PYc/bRCQ0msUUNWF37VDnGvBr8SAvRuz245AioVE5o+EtvupUBzX1TQ0M0S5UBkTtJ/hKseV8pYsDEko6cu+xO+CetdtdlIXHpqOkr2i75iiVB2vKD+JU0qeLHSZHMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591570; c=relaxed/simple;
	bh=g6nFd/P2qZA9lf+/hQc+oV6FtMN3AsQWYpFzwwT9ymA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWUOL6Hb9tiHURaHruWVLyPIGIU9bjng0aDYKlkRVOOb1Vyx69pPaXleDX4XYpjQi1nqqCmBoAelTbKvMXEChkTZCpOYDc2b/qw2fZBflde+wOK3BqEMS54aWVkhFlwpFR8AkBjwDVPq5oeEiVMLCCSk6/j3QGOoeG+YotZpzSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaXszIKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaXszIKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CFBC4CEFD;
	Mon, 27 Oct 2025 18:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591569;
	bh=g6nFd/P2qZA9lf+/hQc+oV6FtMN3AsQWYpFzwwT9ymA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaXszIKkR7Fdex1Epi+oCXkAhL0xKlYzRHpp6mrEAy/5RKpiYPdvbwF72biz6/JfO
	 F5zTPwfnb83mIaEv2cWwJqEJW3uBlFdqbiOWQUOHkeXjsODAZENyjqQcUQojUyNmRS
	 K2vfgJlyAiYZYQJbYQgsfbz5ADV8F7HOWjX4ivlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/332] tls: always set record_type in tls_process_cmsg
Date: Mon, 27 Oct 2025 19:35:00 +0100
Message-ID: <20251027183531.360065442@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 63517995c692a..f22b32b4c8022 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -185,12 +185,9 @@ int tls_proccess_cmsg(struct sock *sk, struct msghdr *msg,
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



