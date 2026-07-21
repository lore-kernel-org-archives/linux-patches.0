Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6C2429822;
	Tue, 21 Jul 2026 18:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659139; cv=none; b=lkkuKkVuHM4YxOgWzDSHtNtbWrymZIPQRbqVrk2jpSZ+5ByJ1T0vG7WItt9+29qg5MfVXh4CA3xTV5fZ29Llk8lIlsobkCxrSoXf4566xPlIfII0qMEz/y3mzHVtUUvei82k+oqPR5ZCfhdODerhi9PVdpE0JLw8dyvHgadkxqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659139; c=relaxed/simple;
	bh=3v2LqTDuiXiRWGKxLytB+NUM4iDZDs4sToEj/gDYnVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKqHs3LdiLcaL/3uv6kk437N0niUhtETBGv798C3oBAv0fwGjddQ5LE5QgXIdVDc+DbqteYPyl77KhAWbWPhuejMa48K/qESVZwCPwKdeBXIVQposFJ8w+upnI2JXeZGl8UZRvoFp8MSU31yoeGk/AaSe48Zy0vpDKwmCZwvIE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdzHTLhk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdzHTLhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7B31F00A3A;
	Tue, 21 Jul 2026 18:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659138;
	bh=8k62TjyzN5XfY47pi/bQTjwCLekjNs1ReDh7XPALR2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdzHTLhkQk3svJKNz/s+Wn1sonW/45O8csJxxUEVxkrZ0pddjH7EseRNNiLLxQ8cL
	 sH81ZpG2NSk0DDo97IZZ239jjoZ4659RS2oiRnGhVjJP1dGvw4FuOvg3BrXAekKH4m
	 uAM0Dre+w34kakZyelrCpfP7zFRsdvYd1VLuYkOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1409/1611] net: ip6_gre: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:25:25 +0200
Message-ID: <20260721152547.134084664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2046,6 +2046,9 @@ static int ip6gre_changelink(struct net_
 	struct ip6gre_net *ign = net_generic(t->net, ip6gre_net_id);
 	struct __ip6_tnl_parm p;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	t = ip6gre_changelink_common(dev, tb, data, &p, extack);
 	if (IS_ERR(t))
 		return PTR_ERR(t);
@@ -2265,6 +2268,9 @@ static int ip6erspan_changelink(struct n
 	struct __ip6_tnl_parm p;
 	struct ip6gre_net *ign;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	ign = net_generic(t->net, ip6gre_net_id);
 	t = ip6gre_changelink_common(dev, tb, data, &p, extack);
 	if (IS_ERR(t))


