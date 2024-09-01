Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC032B9C7;
	Sun,  1 Sep 2024 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208519; cv=none; b=gnUdLdWCfkeMFQeigokLld4JThP6tFAtPmkXiXD3Zhiz2p8KjK/HTJCsAxssWgTWUYvSSKdt60tg8V2KC7DylbG1KIUmrmaXBX3lhZmN//wgJcKkVy/VleSG0zHEDAVHhEQubmbT3m8OivfB7iqOk1ccLYQlw9Nuz0NM9IakyFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208519; c=relaxed/simple;
	bh=Wr5Qamb/IQb56M1wMaOkDN2YOYwr2Ei4Apm0rpKnSxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlWBySoyYI91ZKrMJ3g7DcB7AQellcqTk8TBWFYbdtEPbmu2UXQaVo8jG3pdvLHkChbaAxg07jub5UsExQs8RO7Hn+Y1k/KAz8P/2OBVGudlMhiCSBxm9pD7UZj6DiO5TQXOfIOwlc/Qw9MoIdCOA7yuCbsGLzzzePgDrOt6HZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mClngzc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mClngzc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6553DC4CEC3;
	Sun,  1 Sep 2024 16:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208518;
	bh=Wr5Qamb/IQb56M1wMaOkDN2YOYwr2Ei4Apm0rpKnSxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mClngzc3ckY01KWmJ9UyqdtnDOKL6PYaH0RHdczGKvQFOza6zqI+wZd3tWm/hs2VF
	 Ed5ZS+9JsY5yhwy4kU3Dw72g5HjHtsp3pBwlzZ13opMU6H+sDRFbNx8Wq7JmAJHYea
	 XH6JSQTDtASlFWuZ/v7VAYzGSiuLDHYhUb/nT0F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Schultz <aschultz@tpip.net>,
	Harald Welte <laforge@gnumonks.org>,
	Cong Wang <cong.wang@bytedance.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 107/149] gtp: fix a potential NULL pointer dereference
Date: Sun,  1 Sep 2024 18:16:58 +0200
Message-ID: <20240901160821.479852458@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit defd8b3c37b0f9cb3e0f60f47d3d78d459d57fda ]

When sockfd_lookup() fails, gtp_encap_enable_socket() returns a
NULL pointer, but its callers only check for error pointers thus miss
the NULL pointer case.

Fix it by returning an error pointer with the error code carried from
sockfd_lookup().

(I found this bug during code inspection.)

Fixes: 1e3a3abd8b28 ("gtp: make GTP sockets in gtp_newlink optional")
Cc: Andreas Schultz <aschultz@tpip.net>
Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://patch.msgid.link/20240825191638.146748-1-xiyou.wangcong@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 0696faf60013e..2e94d10348cce 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1653,7 +1653,7 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	sock = sockfd_lookup(fd, &err);
 	if (!sock) {
 		pr_debug("gtp socket fd=%d not found\n", fd);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	sk = sock->sk;
-- 
2.43.0



