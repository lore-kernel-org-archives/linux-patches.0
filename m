Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D0947D945;
	Thu, 20 Aug 2026 16:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244304; cv=none; b=sKTnlTDrb+inCPbMrNB0hfT9769oPtU5yB0lR+boHzoJgg1nRcpJs7TzGLyCQM2d5l/fTE11p0zSp/kYsAWs3RheFCooPCzfux+CQgjDJiP5q/lzUnAb/Uh+WTEejqjtUyMY8pQ/10804XUIzZkfWgwijFYB9/KHeRhOF1C7RxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244304; c=relaxed/simple;
	bh=uiIrJKEx+eHoRdOLhHnBKr4eq7bNxXtKaYuQLSgUKPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3fwEt89+IjREc1zXT2lMfqcNnrvkSVHGxkRrsSFNrwlgiAryuB3LGHZnl6GeHPtJyucQf8M4SgSfUQEsWUTin0l7Cftc18b9fIRihyCAOCsUMd3shB3Ml4KQks/otl/c4reb2EY0PMkPdafZ4JXz3vq/N+ngMv04lXWxLoIkbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zuWFLVmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zuWFLVmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451BF1F00A3A;
	Thu, 20 Aug 2026 16:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244302;
	bh=aeZJtpRVVSbUzm8q1pbGMGWp0u5xHA/rsy+On7aUQpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zuWFLVmyV9q5JwkZPuZM5bq6I+4b8OuIkUfhLdv5o3anOV9PmSRxwdd4BYFHKjAFB
	 hD+Pp43RYbAgdcX/DwlvWzOeT9AwFn4h82BBwsrzLl6OA0hiHqzg/7+w0t+yAfVzWe
	 ENj/xfZdN43ViRCTrlZ2PMUdfH2fP9wzTDyjGnR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/235] net: ipip: require CAP_NET_ADMIN in the device netns for changelink
Date: Thu, 20 Aug 2026 16:55:58 +0200
Message-ID: <20260820145220.141878742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

[ Upstream commit 8211a26324667980a463c069469a818e71207e02 ]

ipip_changelink() operates on at most two netns, dev_net(dev) and the
tunnel link netns t->net. They differ once the device is created in or
moved to a netns other than the one the request runs in. The rtnl
changelink path checks CAP_NET_ADMIN only against dev_net(dev), so a
caller privileged there but not in t->net can rewrite a tunnel that
lives in t->net.

Gate ipip_changelink() on rtnl_dev_link_net_capable() at its top,
before any attribute is parsed.

Reported-by: Xiao Liang <shaw.leon@gmail.com>
Closes: https://lore.kernel.org/netdev/CABAhCOSzP1vaThGV35_VnsRCb=87_CPjPVsTHbq905k8A+BuUg@mail.gmail.com/
Fixes: 6c742e714d8c ("ipip: add x-netns support")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260612085941.3158249-3-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipip.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -476,6 +476,9 @@ static int ipip_changelink(struct net_de
 	bool collect_md;
 	__u32 fwmark = t->fwmark;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		int err = ip_tunnel_encap_setup(t, &ipencap);
 


