Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34493B71A0;
	Tue, 21 Jul 2026 21:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670307; cv=none; b=KiSmT3LCMpAHmbp4iV2uQHRCHRXoO0Ic3XcRx46/ABBJiwI4KFFaxbkfzjtvTj9AzrMx7D21jIlHYC8dRy1fMIWsog/bcFDz50lmvfF2I2KXCPy6mzsdGPMBxP8CMvlZ2r8uBFhZnIVK2Faj+S6VKPo/6xsspJ2sDB2iGChpaVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670307; c=relaxed/simple;
	bh=x02V7KBiHF0ie+o13NsnQgDi2nenLSYWiB1duGpCG/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn1RiJNW9IahBHZDzn4LwW3RD57l5lEJS16hb+EfoufpYzrjm7Ift5E21gJAAnPBRdKT8fcoCFqZRHOFaOJMge+c9IzM0fgkAPpl8scwKZZiqeUztjJ728dSkGo4wHVm0nASaZDNlDC6ZpHZk2Jc1EgMHq0WfygvyrUophkknOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oH9z9yd4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oH9z9yd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146031F000E9;
	Tue, 21 Jul 2026 21:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670306;
	bh=VebG1Zopj3lPUObaEh2x/G+zSYLQFvnHxknesJ6uncI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oH9z9yd4H7MNg07R5+OlZeUsxpnffgGgiaf5Mv+as6hgm2jJgxWYukxwxuQ+ghKPe
	 8PjfcbWhD2Z7DnbJG9FFcx+3+C153j/5aKLaZUmD5E2p5hw0YF20eXJEMr+Lne/K2Y
	 P3K6TP+gNZlixlTmVIAH5FQsBc9VtlYiX3lJI/YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0881/1067] net: ip_vti: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:24:42 +0200
Message-ID: <20260721152444.239948484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -579,6 +579,9 @@ static int vti_changelink(struct net_dev
 	__u32 fwmark = t->fwmark;
 	struct ip_tunnel_parm p;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	vti_netlink_parms(data, &p, &fwmark);
 	return ip_tunnel_changelink(dev, tb, &p, fwmark);
 }


