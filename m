Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7C04746AA;
	Tue, 21 Jul 2026 20:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667502; cv=none; b=kbXUtVOGolEyp5EIe2zqfkIyxPMZdbSAcRPkSs/g7iHlMEB9PAZTp1JkeqReNpT+pmH7eRtp4euins5jp2SvUJ9g1o/hQIUUqxLezwF6MnT8ekIXM++gYDwG9yXTerXdBuie/D5BuYwu7pqPLG/Pbc8ZNvUD4fw5ymRW8pF6QMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667502; c=relaxed/simple;
	bh=J8D8OnjC/ZqeYVYI/8EZWn39anEBW20yQoH0KqJ4lUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kc0WGLWkh4/AI5oEtw0Bbn5rFkd11aSFa7cinCJWvA4Fj+WxwEtjhEqw6bOgv8nyPhKMzo0kBqrUd3XtMnDWNGLd/MeHmTl3UVdkxkN9Bzlf7KPbkPoe8W+t/pEmLPUlgnhssDclTcEkB0CZrNaAqQ+bEVMOPzGiFR8yGU8WQro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s0qUSvPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s0qUSvPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555681F00A3F;
	Tue, 21 Jul 2026 20:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667487;
	bh=m7cGkUS1Vb+IPM1HZZgjg32+yHphKdAFYOiGW3Jddgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s0qUSvPDeyyW4V+LM8PQ+0TfKqi9hFfjKK69wkt/GVOuVoJ3KNSq08noZFI7q8uML
	 H6XCVmoRZf6iaQYiTCtbZ86UAMo9hWNVKni8KKyWJSbAeqg5OO8NFDXZuYFNSPSpAO
	 iiMyAMYIKfbAR82yx2skZA4iTMaX7E4ON/KpNLKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 1080/1266] net: sit: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:25:17 +0200
Message-ID: <20260721152505.980298214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1615,6 +1615,9 @@ static int ipip6_changelink(struct net_d
 	__u32 fwmark = t->fwmark;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	if (dev == sitn->fb_tunnel_dev)
 		return -EINVAL;
 


