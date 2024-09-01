Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD931849CB;
	Sun,  1 Sep 2024 16:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209283; cv=none; b=crWq0K2IaDXIUG32QItmagNR73LFQevJUYcsM+8srk3Kn2pmiZU/ERAhYvKTFLtOHskYgFxPMMHCuC3HWjvubjFuQ3DMloP0gpYXJR2ymPIAI/NRHp/Ztb9b3nmY65b90tHT17UAfDTdMELK/BjOPVlfHawXTqx4ltJIoz7x7p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209283; c=relaxed/simple;
	bh=RJwpr+yHUfY01UAsE1AF5BlEmf7VwZzT10t0YS7qmoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=euRCDURAtPanV4lTk7OkrnVwDDMz1bbbL6pusLqGbGeDTZCARtmN8R+1HU3V5kuB+KOSeZdxeY6zVNGAay9lvpCjlk8iJiR3SsOvXEHu3TFmms4bIRI89FBT8Y1ULiHMIB0QJuaSSG7Sb3wCKEq7be1V41TSUV7pCubBWF7ZmVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYgbuY/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYgbuY/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252E8C4CEC3;
	Sun,  1 Sep 2024 16:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209283;
	bh=RJwpr+yHUfY01UAsE1AF5BlEmf7VwZzT10t0YS7qmoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYgbuY/uIH3m4prtP+LNgefDMaBCx1JuJYoKW0bGD032O5+O2qhn+n897Q2dDWgHX
	 Zo7OdoNI+DQHkStdJu0UR3RoRF08MxxIhh3S56VhnQ5+pu1U0slRn9JXXfwT0ms7oZ
	 xMx3kDlOXML2zKN1ek1KkYtHmbXNFsSCmfRaIYGY=
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
Subject: [PATCH 6.1 51/71] gtp: fix a potential NULL pointer dereference
Date: Sun,  1 Sep 2024 18:17:56 +0200
Message-ID: <20240901160803.816857989@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 512daeb14e28b..bbe8d76b1595e 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1219,7 +1219,7 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
 	sock = sockfd_lookup(fd, &err);
 	if (!sock) {
 		pr_debug("gtp socket fd=%d not found\n", fd);
-		return NULL;
+		return ERR_PTR(err);
 	}
 
 	sk = sock->sk;
-- 
2.43.0



