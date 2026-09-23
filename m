Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFED2372EF5;
	Wed, 23 Sep 2026 14:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172500; cv=none; b=FRYwcOVWt/W0bXCPUtBCCTAnEjsvD5agBM8mquxD2RSwi6NFJofM4UNhTkq4qrPshcZcZqedd2k3OTphkBokhD1Xewsh6GxHPVURILHFU/4dIwA9kZefkJ2PLbzmymsZBNoe6u52/hZgFs85DY3qOnhRS6xMBSHnwzsknTQDjis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172500; c=relaxed/simple;
	bh=kkXr2lSBRtZljYShYFaSX2Pyk9FlrMmjJyrWAcg0pog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hFkGcNilS8iFJu6IwQezZlPnjc0dbwA53MkywZJwsLd6IFAtzU8J1uKcPHnWykPl4BoxUFR4NPh9JRCi7QYqHN9ikF+FXJeG1i0sj6Tzqkp+aWotpVjTVfHsR762MAfJqnTRu3WLoKPHMRpRycfV4uvigfLdNNL179CqLuTNdds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boz4Tg0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boz4Tg0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E62C1F000FF;
	Wed, 23 Sep 2026 14:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172498;
	bh=c/pmD0QeQUd7w1YrbXM2hB1oXlevsaIiGt8rqg4unm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boz4Tg0oC2t+P8/gATG6Hir3DylhqqGXnIXDFrB/SN2zjswEVMz0EMg3DLrPvSfLD
	 vIHq0w8/GlssaJQ25owx04krNaA9L8tN7xfflL28fZ0Bqr3WM0lXOmvjAHEZoDXBjs
	 vBCEzNOottdjRxD7sXYuVG/WXZ9mZ0aoyWanvdys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/398] landlock: Fix TCP Fast Open connection bypass
Date: Wed, 23 Sep 2026 16:01:16 +0200
Message-ID: <20260923140643.509320892@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7ae97dec04342..9224d9b26429f 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -235,9 +235,23 @@ static int hook_socket_connect(struct socket *const sock,
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



