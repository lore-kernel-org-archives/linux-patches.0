Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C38415B7B;
	Sat, 12 Sep 2026 09:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205427; cv=none; b=uNZMkntJVAff5chgQvgwEGJEWw3xk1+ETnQhknUfqHtPbNByiieqXsDGTcL+tWR5RkHU7cBLkGOrX6OcQYc7z1o2h/TBvWoqRk/3KmWSsXmsDiBNGipyKZVWVmjC6iV0Oabah2nDThCaGhK3dp1te6aS4k9QgsInJcxomKAjRfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205427; c=relaxed/simple;
	bh=cyM2iUAVxgZZwX9c53ne0OaJj72RhiEA9R94lBYRg5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH10IpVm+sEV3rO+MS0C8/8U6gK4mjrdpg5XZRtVkNU5Xi6/It9G+FEuxl3lTF3OUYYyrEJvEXGTtbDL3K6Gc29WJgxOksVaUAa2z1L2YKYzLnQtCM8A6GFzlmEzfDQfOyW+dEs7G6/I6LIb1yUojy7jekgCq4sNRj6deMsjRFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqDRoh+1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqDRoh+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81CE1F000FF;
	Sat, 12 Sep 2026 09:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205425;
	bh=0+xpW+5GFTIeymlM9P7fH4zlPMMIWukS5dxKabUUzZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aqDRoh+18rhsH0cq+z5M5HZKa3U6FITTw3S6vUfpmWM+f+lM+V+mrY3dfP+U91/tj
	 VCGIKZxuX8ay7GFC0vsLuVoAT1lq8yaBVbTA8Bxgy6quH8HcFHfOmBZ4hPt4HesNSN
	 avdIAdCMnlgxpruJGwhsXNI78UsmAZEu4oKmD/Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1814/1815] tcp: reject non zerocopy devmem tx
Date: Sat, 12 Sep 2026 08:59:24 +0200
Message-ID: <20260912065731.628554985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 125755776bc6d4dd53eaf551c87e3d460625d638 ]

Devmem tcp tx doesn't work without zero-copy, however it's not currently
enforced if NETIF_F_SG isn't present. In this case, tcp_sendmsg_locked()
will try the copy path and try to copy data from an iovec which consists
of offsets into the dma-buf and would normally fail. Moreover,
d9c56501c72fd ("net: tcp: block mixing readable and unreadable frags")
relies on that and assumes that the devmem binding is present IFF we're
using the zero-copy path, which can be used to mix net-iov and pages in
a single skb, and break invariants. Let's reject devmem tx without
zero-copy.

Note, the parameter check the patch is modifying is too loose, we can
create an io_uring request with dmabuf_id and all ZC flags, but which
won't have the binding. We replace it with stricter validation.

Fixes: bd61848900bff ("net: devmem: Implement TX path")
Fixes: d9c56501c72fd ("net: tcp: block mixing readable and unreadable frags")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/fdc2478d8f21268d7078556409887d8e6ba0ad32.1788529053.git.asml.silence@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b4237d0e994d6..10f58281be17b 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1169,8 +1169,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			zc = MSG_SPLICE_PAGES;
 	}
 
-	if (!sockc_err && sockc.dmabuf_id &&
-	    (!(flags & MSG_ZEROCOPY) || !sock_flag(sk, SOCK_ZEROCOPY))) {
+	if (!sockc_err && sockc.dmabuf_id && (zc != MSG_ZEROCOPY || !binding)) {
 		err = -EINVAL;
 		goto out_err;
 	}
-- 
2.53.0



