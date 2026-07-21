Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F145740244D;
	Tue, 21 Jul 2026 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655004; cv=none; b=l5e9LBGOm4vZpqjswOxV0QeigMGX/4iDatrMkTidxzgz5CnyVcm9+zghUd8o7Gr6nZWJkSOLwdQ8WlBKSWHT81pEVCQ7EKJo6zCGSLmc7SL3Qv7y7gj6H8pQKEtaSGTKAkPEeJXkgtquqgxtddtXrMn9ZcQrRqD33SgZNGK49QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655004; c=relaxed/simple;
	bh=ns/U4HuU2swwHjy/xPSVrGDGiIqIyIT5MwwftOuvqdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO00FgMuOh6WTkMBA/TJHHr3qcmmLscF9yC51AZzpxY0bzEaMSfz1NW+ztrhvfh86DFfPrCLkKUg5PWBwouC6VodPe87qjz672j27bALe/ZDldR4cUEz+UGXHgzagI4rqmS3jEYlCwUiEGuSP4xZ68yEbdgN+soNE+dBOcOnbpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWRQKISD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWRQKISD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6400A1F000E9;
	Tue, 21 Jul 2026 17:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655002;
	bh=XpJ+2w7Q4n39Q+cMjDrfgm9s5BRmY4Go+U4tgYrzwgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWRQKISDRpCLGdSCJfFDbrmNoj3gIiszG7quqU/3Xkg5b9V/A4bzWexfqyVpu7mKo
	 igb0cQoLUMi2Ms7ZWzFqfn50BbnwnHa4EztLiIN3xTbsID8AI0fED8hODWc79/U1kS
	 z+fl97iJSYubxklnproInhC7eM/S4Rf1DdouVhVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1919/2077] net: ip6_gre: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:26:32 +0200
Message-ID: <20260721152637.976763695@linuxfoundation.org>
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

commit f00a50876d2818bd6dc86fa98b3ef360884c53c8 upstream.

ip6gre_changelink() and ip6erspan_changelink() operate on at most two
netns, dev_net(dev) and the tunnel link netns t->net. They differ once
the device is created in or moved to a netns other than the one the
request runs in. The rtnl changelink path checks CAP_NET_ADMIN only
against dev_net(dev), so a caller privileged there but not in t->net can
rewrite a tunnel that lives in t->net.

Gate both ops on rtnl_dev_link_net_capable() at their top, before any
attribute is parsed.

Reported-by: Xiao Liang <shaw.leon@gmail.com>
Closes: https://lore.kernel.org/netdev/CABAhCOSzP1vaThGV35_VnsRCb=87_CPjPVsTHbq905k8A+BuUg@mail.gmail.com/
Fixes: 690afc165bb3 ("net: ip6_gre: fix moving ip6gre between namespaces")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260612085941.3158249-6-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2047,6 +2047,9 @@ static int ip6gre_changelink(struct net_
 	struct ip6gre_net *ign = net_generic(t->net, ip6gre_net_id);
 	struct __ip6_tnl_parm p;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	t = ip6gre_changelink_common(dev, tb, data, &p, extack);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
@@ -2266,6 +2269,9 @@ static int ip6erspan_changelink(struct n
 	struct __ip6_tnl_parm p;
 	struct ip6gre_net *ign;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	ign = net_generic(t->net, ip6gre_net_id);
 	t = ip6gre_changelink_common(dev, tb, data, &p, extack);
 	if (IS_ERR(t))


