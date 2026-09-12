Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4573C472F6C;
	Sat, 12 Sep 2026 11:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212761; cv=none; b=Sm/cMJgtBVOGLclMt/EokOC0Vujmoe8m7jomZc9D20GnnH4ydLXbFS9OxtQmXYc8WrtafMK9drVbBCWIWmMMUj15NZ00I9ikm2gkRypEFOF58zpUbMuHV98LXZI6Ibet60DJIspx6tR4pV1zZStOaSUBC3nA+SUAZl8aGIHAq/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212761; c=relaxed/simple;
	bh=lgO3saXKQVc2W/fbu663TNQMj9XrrVOuYVmlz/sc4MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Laq+z8rT8Hp4iPIoQ4bIux6weHJYcBHn8q6RScMpQ6vpJg5Q4W/UPzhAkYOE8g2IJZ8f0KgPUo014IYIesT28mSdNi19spfkB4xlP6HTdf+VG66j67cYs8JGEZDXyRTyaCwoX7YGmb9Ap3RFmQSQpfTkH7sKdPBABkAFmOKXeyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6rl4Noq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6rl4Noq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C361F000FF;
	Sat, 12 Sep 2026 11:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212758;
	bh=3+OrEZTrvi0BX5DhuegwxLNNK4tQac7BXUyGPpATAXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6rl4Noq2O8VNXWqlUR15d12enmQBu8CIz/dTEL0Axb/JCtgPP6YsC3907Hqm4eJ5
	 iHINPkl+pcU+PZZCpEjN1qNjXn3Kgm6ARPi8i7y0UoxmOJm3UuRSZR/HNO0Jk7sgu0
	 rLBvyEba/M3XsQgOXZZGDZeQYFPWxq6w02TpnCg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1501/1518] tcp: reject non zerocopy devmem tx
Date: Sat, 12 Sep 2026 09:01:10 +0200
Message-ID: <20260912065657.518147515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 02f5d53245547..53700d6f6f280 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1132,8 +1132,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
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



