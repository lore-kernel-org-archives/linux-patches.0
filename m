Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13B51A683A;
	Tue, 21 Jul 2026 20:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664030; cv=none; b=TjA5NhqiIgfUJZ636EdFT/Kah+/8r1Ub9U+m+n0CqkQvP5ypXwzGH16Z6A2TXvI5dv5wFGa6Xc/ZFmmfGhltKgm0AVs6DTum/9GeBHPPmhiJXMUlxZSThDr/cu/MSA8juHLZdWGMMFCDM40cF/1fvdEFSbR2h5mqb93WfLw4RdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664030; c=relaxed/simple;
	bh=Il97A07cVEGLm/YsTWiMWXutMd2rHn2sFNoFiNA/aYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2SBCHczHeX4wqm+b4NanTMsajS3YYmkNuQl/YWfuGXJC2AKQqBWbohqRi7jHM93zbV+9k2xlEfrcsUAyq9zm4JYiAqAlKlV+ZhKNx3BW1xP4Zm8Lls7I3tI+twTdvImF0QBS2oeLzdKka2zGz/4ugi9eVA5Z2jVVTpz18rA+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPhC2ck6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPhC2ck6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538861F000E9;
	Tue, 21 Jul 2026 20:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664029;
	bh=X038rOsDhH25W17qp9GBALuDRj8SPdnN68hh0KWkgYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPhC2ck69zB5GcN8dSmRpRP2Fv/8lkKyE5U366W2143vX9XUT3qU8cWPht/aBKvkD
	 hMqf2HYAaGD15Mv1EdObRNC4OHkjtimsXy0EW7qLJ3pZS2lqakQzGXmywi0kGBVbHy
	 1+Jgksg0ZhtDjhWKk2ixO+UyauhKe5Osu4nm1hhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1045/1276] net: sit: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:24:48 +0200
Message-ID: <20260721152509.372503866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
 


