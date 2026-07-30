Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7635B45041D;
	Thu, 30 Jul 2026 16:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427500; cv=none; b=n6yE+2X3q2om+aHLK3CvRFZXH+40svVnRDeUhyPvT9gkjwZb6URAoJNFapAUs/7kkPlLlQBmQr99VHc5hNVteDqyKWPfS2fSv+yJ/2Enslx+7bebRS20hHF6O4uhQOjlEaT1hxATO5xLWZrma1uADUdW/Kktfzdl6YKi5vcE1FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427500; c=relaxed/simple;
	bh=c/+5IgaokuFyPWKrFauq5JIR0hnCgYPma+XErNyqShQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ini5z3GK2Md+8eXEIfUfC1rj98M5PFV2Wt/MTIIw4rxodFsN0BduBwxlrCMQ9XzVkV9DwuVtuDYhA6doqP7eSqMuZi0p3wtSsEVg9snEVW+dYdXANc5S0KyX35/fsdvFTDdDJyMFmdgL2RN35up9qN/ZYW1euMM797S4sIbWaa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSaadqrH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSaadqrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24541F000E9;
	Thu, 30 Jul 2026 16:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427499;
	bh=gdWqO3dK+1a2A4Ku/ehQuXuKijV7uiltgvy6OA/P2no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSaadqrHe4mSzZb7K+GZ8/sPCVJm+XMpZNRQ2I9MfOAGKvrnKTya0nbm/fDSoUwlC
	 ijDkjPbc67/f3jkMo10zW8eu2TJj2OpV0SeeOSst+5RlQX3fm52QFxYmTpKJMTc2u9
	 RdOl1YJk79BDwZtWjan4X9JdJH20Zdug0iX1frac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 193/484] ppp: use IFF_NO_QUEUE in virtual interfaces
Date: Thu, 30 Jul 2026 16:11:30 +0200
Message-ID: <20260730141427.660523468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingfang Deng <dqfext@gmail.com>

[ Upstream commit 95d0d094ba26432ec467e2260f4bf553053f1f8f ]

For PPPoE, PPTP, and PPPoL2TP, the start_xmit() function directly
forwards packets to the underlying network stack and never returns
anything other than 1. So these interfaces do not require a qdisc,
and the IFF_NO_QUEUE flag should be set.

Introduces a direct_xmit flag in struct ppp_channel to indicate when
IFF_NO_QUEUE should be applied. The flag is set in ppp_connect_channel()
for relevant protocols.

While at it, remove the usused latency member from struct ppp_channel.

Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20250301135517.695809-1-dqfext@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 543adf072165 ("ppp: annotate data races in ppp_generic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 4 ++++
 drivers/net/ppp/pppoe.c       | 1 +
 drivers/net/ppp/pptp.c        | 1 +
 include/linux/ppp_channel.h   | 3 +--
 net/l2tp/l2tp_ppp.c           | 1 +
 5 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 53e96a8740397c..62169a38b984a2 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -3508,6 +3508,10 @@ ppp_connect_channel(struct channel *pch, int unit)
 		ret = -ENOTCONN;
 		goto outl;
 	}
+	if (pch->chan->direct_xmit)
+		ppp->dev->priv_flags |= IFF_NO_QUEUE;
+	else
+		ppp->dev->priv_flags &= ~IFF_NO_QUEUE;
 	spin_unlock_bh(&pch->downl);
 	if (pch->file.hdrlen > ppp->file.hdrlen)
 		ppp->file.hdrlen = pch->file.hdrlen;
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index bc726b54ca745d..4aab447f0d65c9 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -699,6 +699,7 @@ static int pppoe_connect(struct socket *sock, struct sockaddr *uservaddr,
 		po->chan.mtu = dev->mtu - sizeof(struct pppoe_hdr) - 2;
 		po->chan.private = sk;
 		po->chan.ops = &pppoe_chan_ops;
+		po->chan.direct_xmit = true;
 
 		error = ppp_register_net_channel(dev_net(dev), &po->chan);
 		if (error) {
diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 3a10303eb756a8..386e0be78a6a96 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -469,6 +469,7 @@ static int pptp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	po->chan.mtu -= PPTP_HEADER_OVERHEAD;
 
 	po->chan.hdrlen = 2 + sizeof(struct pptp_gre_header);
+	po->chan.direct_xmit = true;
 	error = ppp_register_channel(&po->chan);
 	if (error) {
 		pr_err("PPTP: failed to register PPP channel (%d)\n", error);
diff --git a/include/linux/ppp_channel.h b/include/linux/ppp_channel.h
index 45e6e427ceb8a0..f73fbea0dbc239 100644
--- a/include/linux/ppp_channel.h
+++ b/include/linux/ppp_channel.h
@@ -42,8 +42,7 @@ struct ppp_channel {
 	int		hdrlen;		/* amount of headroom channel needs */
 	void		*ppp;		/* opaque to channel */
 	int		speed;		/* transfer rate (bytes/second) */
-	/* the following is not used at present */
-	int		latency;	/* overhead time in milliseconds */
+	bool		direct_xmit;	/* no qdisc, xmit directly */
 };
 
 #ifdef __KERNEL__
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 34d8582c0c072e..2e856a83a7506b 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -810,6 +810,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	po->chan.private = sk;
 	po->chan.ops	 = &pppol2tp_chan_ops;
 	po->chan.mtu	 = pppol2tp_tunnel_mtu(tunnel);
+	po->chan.direct_xmit	= true;
 
 	error = ppp_register_net_channel(sock_net(sk), &po->chan);
 	if (error) {
-- 
2.53.0



