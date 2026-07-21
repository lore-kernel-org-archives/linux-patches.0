Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21593C276E;
	Tue, 21 Jul 2026 17:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654998; cv=none; b=S+0jcf11MDJaNidGQK5qqnhtsWFV2iEPKcIyfqr0JL/cVDw7WhB/En8vpHLZjXlz+JaiFn5aMbDj2Cf/q7H1PLSMgGy97oa5Dd3Z3Le4stXpUIKXkb7RsmX3vIIIhph9azdKiJ9PXjvf8Fl5NB1Xl+4wKC/zZJ7rgQ0Xrv2pNCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654998; c=relaxed/simple;
	bh=XlzYWq2B2th6zBAhOCjTbZo8Kmv2JGbLz1tRvk2wDKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIvqE/32MoxuDFrtBnUxW4xY0v11RqiNmsi9qV5+DGQNm5ECC1NZ9OR5dmXlep98AJSwb1S/PpW4s40U81X1nU4rTR5hn7DDzkjGGpW76pLEmQUBSvxGFIRIl0WyFBN+wJxwson309Gnh3K5mERgbhFvWWSWppHN+4R2IAHOyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8TA1e31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8TA1e31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008C71F000E9;
	Tue, 21 Jul 2026 17:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654997;
	bh=cVxvGtbR3HU77hTUDoJEvv0JQL8JwM7I+rMFO2GtOcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8TA1e31EiJLWKWJ0Ir81iThCllHwwMru4gympheEnbaACfC4wTslE5fGieky663D
	 jOkENtpFtINWNwRn+0q+h4jBh6zsbMUm7NRm+12+6cop7qwT2j2sBI5EiVH04YN8vO
	 +oGNwX2dmSF5z+W4Z5wIe4WzuQ6P0DgQeZBHOx4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1917/2077] net: ip_vti: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:26:30 +0200
Message-ID: <20260721152637.931318428@linuxfoundation.org>
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
@@ -596,6 +596,9 @@ static int vti_changelink(struct net_dev
 	struct ip_tunnel_parm_kern p;
 	__u32 fwmark = t->fwmark;
 
+	if (!rtnl_dev_link_net_capable(dev, t->net))
+		return -EPERM;
+
 	vti_netlink_parms(data, &p, &fwmark);
 	return ip_tunnel_changelink(dev, tb, &p, fwmark);
 }


