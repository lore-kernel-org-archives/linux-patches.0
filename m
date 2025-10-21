Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE7A350A07;
	Tue, 21 Oct 2025 20:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076861; cv=none; b=N3jTyTT60kmzSLSxNJJWgNvkgFPit7fDTOvdhIeLk9e0r+c7v8lju6mtXaqvCH4otkzf1v1epcLcprVYLia8lkgMEvaOl13U2AY8wIYov5Qf3I6getyrHX7JLVk4+RasDetu6pLL7gwZ/WEEj4UuWtW6jFfKPfIcxPZQHnAeIhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076861; c=relaxed/simple;
	bh=3/KOt74qayBq2ioE/1Enlk16UEQuUSk32hWDUOW+8AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQvs31wi1UmXf3vjSmJMjyJGXoLjyQlZ9jQ+/BR5mInBzOYARAl74+6ngbyIo9S98jfnm7uHfw9tymozG9XtnrLXpaWJKT0h9r1QeJHz8wqVPsN/Yov39xylgn+6WpbJgkoqnUIxZF6tlIGU6RaduYe3Mg/hMIGEWeVBSErLeHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXdWLTDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXdWLTDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F847C4CEF1;
	Tue, 21 Oct 2025 20:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076859;
	bh=3/KOt74qayBq2ioE/1Enlk16UEQuUSk32hWDUOW+8AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXdWLTDhNqSvjbKhbowLze6iu0YAsyrZyO2tihjAg0aq3nM4Ay6Lrjx7Uf4MDC4mX
	 TudprOwuuA95ihqKJiMQdRg1Ll/PzHH4hBJpUklojnIsy0+T2XevxU4hjzXGPYwHbU
	 uMXdLJWzy4u76ljFma2nmXfFzvKzU+eGaretAVtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/136] tls: always set record_type in tls_process_cmsg
Date: Tue, 21 Oct 2025 21:50:49 +0200
Message-ID: <20251021195037.444792252@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
index 0acf313deb01f..e52e4c91c9091 100644
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



