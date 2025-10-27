Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487B835965;
	Mon, 27 Oct 2025 19:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592289; cv=none; b=V9XQX7/KzUgYAY9PPtWd+2S1GbBeF0tdgDC/gnjJbektSpjhdZSETD6kHh+jhrrZqUwXRiQMeSZ9Stin3hPUJPcGFXSqlv3wOYs1atwGTQmkqlSDcRXhQEU52ObPXoOTsWl3gY6qeJiedVeZGLxUx5Y8Sk3WZ8WBHr8557ePsmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592289; c=relaxed/simple;
	bh=eKQ1Jm+IiFj4CzIAFwfC0ivVdCZ/f2myOCVVaEsWpso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0+A3eeCJhxNpS/NDyQFjBenayb6Ao66/35U+CooMjzxcU7t5KizgvfG+fuP59XeWo5PGNDziSRClTxFgCGmmtnTRj1zTZ1ylALfuZOfnwnH6AEK0YxKE96CMlWBHhqoagqV71kGCN2b7Tq4mlxNB+QkEH5T56MeOKPWswy5Rmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaOPQUFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaOPQUFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7F4C4CEF1;
	Mon, 27 Oct 2025 19:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592289;
	bh=eKQ1Jm+IiFj4CzIAFwfC0ivVdCZ/f2myOCVVaEsWpso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaOPQUFZwPLlypSZe1roC/G+lWxHu7qI/84SwUcRc41PVBspe8lKzS58RcARa5Bqk
	 L76QE/F9Vk1qMr95iXk4NRIcpbDK2s5U8jzq6gC79ZqWcQMJdO7o9rraIShuUqPK5O
	 ZMqSTabtBxmWBHDmiHKwHoYf2w+d69JwtiS+Gnv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/157] tls: always set record_type in tls_process_cmsg
Date: Mon, 27 Oct 2025 19:35:08 +0100
Message-ID: <20251027183502.556307891@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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
index 14d01558311d2..4797f68b9ec80 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -208,12 +208,9 @@ int tls_process_cmsg(struct sock *sk, struct msghdr *msg,
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



