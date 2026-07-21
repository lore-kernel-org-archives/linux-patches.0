Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA3845DF4D;
	Tue, 21 Jul 2026 22:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672628; cv=none; b=YXGlCY/FpN131J+Ck80vVfKhmXow83BjbOh0+F1CR+58/jLVSA5BYagzOBnzmro1IlhkUdVDzINefLs92SZZRNeTn8ybi94/ySxOypgwfBzoHdQxgzubh00rXuxdfsC9on2NGuqOtr9EhMOSYpfA9fHtgQEbH3E5jOFZNi2pLHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672628; c=relaxed/simple;
	bh=0oMIkbR5nEwK/Gn8lmFFINu6NGk5VDYXtalXh5lja38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OraU8Hp0jkRG5khDe4Azclr/nkr6mNe7M91f0iNJYSqZjrZDJqJMV7gh/VOqJrG2yIU3u2sXnK6Y2hiwqgfTvXXcYkRnTFxmByv3FDxxrR1ucxnlQBWYBx+jJC9A4PNEj6eGvUwfc4vy0gtJxSfN1TwC8sVipCgDzzzFmZwFNu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptCAyneb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptCAyneb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC161F000E9;
	Tue, 21 Jul 2026 22:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672626;
	bh=lX5mkJ9xitZPsJDcE/IXnPZEYDS5EeR4+Ez+aXb4Dmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptCAynebmpuzTLIDobb7DDjNzimjXcgfb8iHbekHHkJvv/VEeO/k0vpvsX/fdf8CH
	 JLHqUpTg26FSzqXFDim5jdn8Pjd83EM5dQ/52AFsUMY1TXDhx89J5vslWqp6QloErX
	 rsqWL7P06HdzbrwujR5VNjGohEG4mtyYipFIqjCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 679/843] net: sit: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:25:14 +0200
Message-ID: <20260721152421.331776361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 27ccb68e7cccead5d8c611665a45d23032d468b3 upstream.

ipip6_changelink() operates on at most two netns, dev_net(dev) and the
tunnel link netns t->net. They differ once the device is created in or
moved to a netns other than the one the request runs in. The rtnl
changelink path checks CAP_NET_ADMIN only against dev_net(dev), so a
caller privileged there but not in t->net can rewrite a tunnel that
lives in t->net.

Gate ipip6_changelink() on rtnl_dev_link_net_capable() at its top,
before any attribute is parsed. sit was the one tunnel type not covered
by the recent series that added this check to the other changelink()
handlers.

Fixes: 5e6700b3bf98 ("sit: add support of x-netns")
Link: https://lore.kernel.org/netdev/20260612085941.3158249-1-maoyixie.tju@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260618070817.3378283-1-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1679,6 +1679,9 @@ static int ipip6_changelink(struct net_d
 	__u32 fwmark = t->fwmark;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	if (dev == sitn->fb_tunnel_dev)
 		return -EINVAL;
 


