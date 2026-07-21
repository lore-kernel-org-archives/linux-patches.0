Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EDF3C276E;
	Tue, 21 Jul 2026 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654996; cv=none; b=h4PRIEbyNdzM93amXVhfXFP/MkeaXXZhMfCG33E1PNR+BfGJqh3o0pNRr0Brb/el6713lQ/+ndNm4qaQCr3hIOdAcs5pfOzi8BL18jbS0BNI+YFpmp6M2gTt4OOUSEFTHCUinx9o7Y3fCigxJOIBbfLdZk3MWGO+kq+nAzSH3KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654996; c=relaxed/simple;
	bh=LmAWhXfsLhbbZoNqJy3XZEGVFtwQgpiou4il+Hmwpgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBMwsLaZPEikwyWYuzlC7mRrGprdJO+e4m3u223WRYtiItLwyaX5Rb0XpcjV5wxiV7Ra03FnXY6sEIEm03au71lV64zcvWITgZRS1RTxjdKQzaCJhbnnFOllvHW5s7k5jqWqUp0W9x5V2V1jhNl6tkSEJsQziSG7p71LCS9BHnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KG4OeK9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KG4OeK9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9EE1F000E9;
	Tue, 21 Jul 2026 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654994;
	bh=3vd+lQp5qw+7Ql2RA1cx+QDHzZtJyvUdyBX1Ecb3CKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KG4OeK9aqCaHsbGZxaQbJqbduIXLfmtdkSh8IaVU09Ow50AcQPiv/SI37LcN6Q7KD
	 0lkQsP02ROm5jEsXDu9nN4iFqw8gquCo1/UCM0gHSebFI5nKyLaM0wMc4xlPCaboHi
	 jD3seq6/zWMhrBV2Uw3haR313XbL7sWj3VK9krBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1916/2077] net: ip6_vti: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:26:29 +0200
Message-ID: <20260721152637.907847953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit e2ac3b242c37dff323a964962e43854f4b1a2b79 upstream.

vti6_changelink() operates on at most two netns, dev_net(dev) and the
tunnel link netns t->net. They differ once the device is created in or
moved to a netns other than the one the request runs in. The rtnl
changelink path checks CAP_NET_ADMIN only against dev_net(dev), so a
caller privileged there but not in t->net can rewrite a tunnel that
lives in t->net.

Gate vti6_changelink() on rtnl_dev_link_net_capable() at its top,
before any attribute is parsed.

Reported-by: Xiao Liang <shaw.leon@gmail.com>
Closes: https://lore.kernel.org/netdev/CABAhCOSzP1vaThGV35_VnsRCb=87_CPjPVsTHbq905k8A+BuUg@mail.gmail.com/
Fixes: 61220ab34948 ("vti6: Enable namespace changing")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260612085941.3158249-7-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_vti.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -1046,6 +1046,9 @@ static int vti6_changelink(struct net_de
 	struct __ip6_tnl_parm p;
 	struct vti6_net *ip6n;
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	ip6n = net_generic(net, vti6_net_id);
 	if (dev == ip6n->fb_tnl_dev)
 		return -EINVAL;


