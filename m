Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B0F47D92B;
	Thu, 20 Aug 2026 16:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243588; cv=none; b=IWdn9XwBHxxECQQlE5OW0RjUI57WJ5a7GX9BuY0/QKc64irGnjZQnDj8nx8HhB3TJsSdrD0zPhHbYK0ZqzQyHMFNHXZJe0h/xdHxWeCqMU7PuDkYdsh/3QNVnvjgwIp0IgjkENg4frpgnM25ryvFj3CNBCqDu8Zsw1vQjFNZd+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243588; c=relaxed/simple;
	bh=J31HUb/s45IOJO60nUFPTIIzYGo2GtXLqU2vw2CLHKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl0FhnVhmoajhe5fZutp1+LV34AlNyPyZtCAJLjqzIpe2/dzatY19ex3UuGGduMSNRCeG47cJmU1VoR/grOZucx5jkYSHzU3jccOlelTOt5qzBGsCLNoZF6UCdkpfxB5maCbR0ZSvEPkWonCk1v95brMqkUiX/EvPQCWCGt/CKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8iR5XCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8iR5XCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC031F000E9;
	Thu, 20 Aug 2026 16:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243587;
	bh=t098M/7eL56bXgAmf7CbIpExKKuZ8TbsWK6dkylxldA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8iR5XCqhbfEPY6au9RIdy2tt41tNX2kLM10cKi7eFah/rkp7DUwBrKNWjZ/tzrDW
	 NJRsxFfAFzm8X5ebkn9mXdd8fG9c28J/IcwjAWhK6/fYluMvSEqAT/T7k9gyPOudIk
	 4zFuAUTpcT/lBiwxEl/0EXYqU9vGbSKopESyfxk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/272] net: ipip: require CAP_NET_ADMIN in the device netns for changelink
Date: Thu, 20 Aug 2026 16:55:29 +0200
Message-ID: <20260820145235.658350323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
@@ -478,6 +478,9 @@ static int ipip_changelink(struct net_de
 	bool collect_md;
 	__u32 fwmark = t->fwmark;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	if (ip_tunnel_netlink_encap_parms(data, &ipencap)) {
 		int err = ip_tunnel_encap_setup(t, &ipencap);
 


