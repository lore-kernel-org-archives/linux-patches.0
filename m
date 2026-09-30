Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6469D51614B;
	Wed, 30 Sep 2026 17:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788124; cv=none; b=Ggwy/xvka4DDArDyu+6r7LmZ5VOnur9nIXczljF63f8Tfksu1uwV1Vb92oJhQxvzs5sKbu8XZpuErCe+PMphpMkp+GfW/mJJ8BWy7u1u420l1txshzoK+syxSTLMbnMUBjbd9dbaOzlMB9U2oRcB5u9JizvvuGjeOHeviiGzkzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788124; c=relaxed/simple;
	bh=Fv131u0jMzgEfzTIU/kseoV5fIuKKpC7PsGvUCowubU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bsI6MHZFZfDes0v3mSibD8H5PHF6508ph3vnFiBUWJpYxIsFdImhZt9Hgz8RFBA29kChNjlRIlQF0ot99NDIk/ksER66A1MhheMVLlKOQ7nSSZuMhfzGUhr9NoYP/ts9Ie1Eri6eJYgfcXMuZgoZmk5UK2b5jjdezwnG0aUNJoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhvPoljq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhvPoljq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A731F000FF;
	Wed, 30 Sep 2026 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788123;
	bh=LiU/SBYrcmnIsfqWDAeU7r37gTlQFxDSHBCiQkdfgJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhvPoljqH25zblBlIKEuRHd74l6VpXv3SsCU6P8Ioqx+l/cyk8cvvsvKujJXHoeVj
	 Jrl+1Cugl/asA21oJCVPJeQ1CGi5VJ7vshQIWOpEOZe69brK/MWP1icLer4gEOJViv
	 RzGvuAi6rvr6c3BRWTbNHrd9gZpR+mND2TDqqTx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/877] landlock: Fix TCP Fast Open connection bypass
Date: Wed, 30 Sep 2026 17:15:14 +0200
Message-ID: <20260930152414.818487527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Buffet <matthieu@buffet.re>

[ Upstream commit 33cb713db0161b54f04fe830e062c9e102c29a04 ]

The documentation of the socket_connect() LSM hook states that it
controls connecting a socket to a remote address. It has not been the
case since the addition of TCP Fast Open (RFC 7413) support, which
allows opening a TCP connection (thus, setting a socket's destination
address) via the MSG_FASTOPEN flag passed to
sendto()/sendmsg()/sendmmsg(). The problem then got duplicated into
MPTCP.

Landlock did not take it into account when its TCP support was added,
leaving a bypass of TCP connect policy.

Ideally a call to the LSM hook would be added in the fastopen code path,
in order to fix this generically. But connect() hooks are designed to
run with the socket locked, unlike sendmsg() hooks.

Closes: https://github.com/landlock-lsm/linux/issues/41
Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
Signed-off-by: Matthieu Buffet <matthieu@buffet.re>
Link: https://patch.msgid.link/20260701214628.33319-1-matthieu@buffet.re
Cc: stable@vger.kernel.org
[mic: Wrap commit message]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
[mic: Backport: adapt the TCP Fast Open check to the TCP-only network
hooks]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/net.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index 9c9608924fbdb..c5c26e9029924 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -193,9 +193,23 @@ static int hook_socket_connect(struct socket *const sock,
 					   LANDLOCK_ACCESS_NET_CONNECT_TCP);
 }
 
+static int hook_socket_sendmsg(struct socket *const sock,
+			       struct msghdr *const msg, const int size)
+{
+	struct sockaddr *const address = msg->msg_name;
+
+	if ((msg->msg_flags & MSG_FASTOPEN) && address)
+		return current_check_access_socket(
+			sock, address, msg->msg_namelen,
+			LANDLOCK_ACCESS_NET_CONNECT_TCP);
+
+	return 0;
+}
+
 static struct security_hook_list landlock_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(socket_bind, hook_socket_bind),
 	LSM_HOOK_INIT(socket_connect, hook_socket_connect),
+	LSM_HOOK_INIT(socket_sendmsg, hook_socket_sendmsg),
 };
 
 __init void landlock_add_net_hooks(void)
-- 
2.53.0



