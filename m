Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715A7415F10;
	Tue, 21 Jul 2026 22:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674414; cv=none; b=lFRR1HTNOOnDLaOONHvOH9RlXOb+WCeXBCR3cxaSBVz1PB+zWEDM+el9idOaCZ57rK/kOQf6aaOUv3D8FEtZ3rjYr7Q+fUnsjV02p5UemKCFT7fkFWNhr4SCmtKdlZ6OIzbF5HCPYSbbhexx5g8lUp05rrklAILVqM9jDyWxfKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674414; c=relaxed/simple;
	bh=A4dXxACwhlJwoMQSc4dvggGuIEqi0PTgtcpG319n53o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyUxBlVmpn5VRIIxEITVsAKJskigWC6QKcWU921f3tRT9h5l97AU4ap8cjsj6J2/vnuK3HIHC5wHMgdEaO5kFSGYtA24hnpFrx2cMnprm67YA2KXmRBAjcQlfsEwACpkwxWfS9zbkGTcJ30dMdIuHJdxc0uf9M7Nq89IOB0kB/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skXWLdNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skXWLdNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ED91F000E9;
	Tue, 21 Jul 2026 22:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674413;
	bh=a2OM9+B3JnGNiFj5kZHEz0iVg20V8bavcoo5+gYdy94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skXWLdNtguB/QoOAWTVFWqJ/Njr84KjZQuhxhi8l0daaJbdp7zjTYSjf8V0Te+h9g
	 raykKubvC+4I/o/292ouQSidA8U3mzGZWAlfin0dSoQ+qzYZXTscIG0lGJ7cx5P5UW
	 tKGB3OuaS/5/eX/cgBZA+9BgJSqFZH5dKjAaCqaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 531/699] net: ip_vti: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:24:50 +0200
Message-ID: <20260721152407.676585303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

commit 95cceadbfd52d7239bd730afdda0655287d77425 upstream.

vti_changelink() operates on at most two netns, dev_net(dev) and the
tunnel link netns t->net. They differ once the device is created in or
moved to a netns other than the one the request runs in. The rtnl
changelink path checks CAP_NET_ADMIN only against dev_net(dev), so a
caller privileged there but not in t->net can rewrite a tunnel that
lives in t->net.

Gate vti_changelink() on rtnl_dev_link_net_capable() at its top,
before any attribute is parsed.

Reported-by: Xiao Liang <shaw.leon@gmail.com>
Closes: https://lore.kernel.org/netdev/CABAhCOSzP1vaThGV35_VnsRCb=87_CPjPVsTHbq905k8A+BuUg@mail.gmail.com/
Fixes: 895de9a3488a ("vti4: Enable namespace changing")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260612085941.3158249-4-maoyixie.tju@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_vti.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -576,6 +576,9 @@ static int vti_changelink(struct net_dev
 	__u32 fwmark = t->fwmark;
 	struct ip_tunnel_parm p;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	vti_netlink_parms(data, &p, &fwmark);
 	return ip_tunnel_changelink(dev, tb, &p, fwmark);
 }


