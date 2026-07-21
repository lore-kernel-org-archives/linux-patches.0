Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28660470111;
	Tue, 21 Jul 2026 20:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664044; cv=none; b=TIqDjRsiov7a9tL+9WPM+VjhRr0Xk4+svLClw47fztvluHawELWJSH0W+IGaOsix/HvONSLl9rczRh08xVPUmQZHJ/B8cVZuiWcn7fq3LtKePjjdmJ8kMeP6+B1DdFCUD62TtmW1rUbLXNVhOEzSU5UZjwKtWo3OB+T+CwxwLlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664044; c=relaxed/simple;
	bh=+C7wIlLyFhAXM9f5k+TBNqjb3Hm/Gyfz1jLyS9igxDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EA6qvD5CFbLYRi47qI+T5k1mQ94DByRsEs8LX4Py3Eo1YQ6DGHQ09HcaQzSw3P/ClZQxnvUER9xZdeW0pcnBTzOHJol2f7/EcwSWUQMpaGKASBSFfpNrQiIwNTd5vscOlDPLTLT81LXTYpXzXk1UXdsgr+s6a0HGPQ++/MFNpNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR3LMoX2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR3LMoX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A0F1F000E9;
	Tue, 21 Jul 2026 20:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664042;
	bh=2hgceG39RJfLGsRGwWbewU6qU5pQhfPO9UXa+foNCHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZR3LMoX2ahX4BYjlw7F9XUAgSYKzoWTVC7CvkUjgntgxFu3dBVMf/7fr0yQ6wMKoT
	 GiZBGOW34SoUMwM1lPnFNT4PHGY93IZk2TXOH3vm6KdaUfEk9b+Zbp32LUhFeAjxkz
	 NlKzh/aSmcPpY2MSRoeL6xI8YYEG7tCHbc/Bx8hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1050/1276] net: ip6_vti: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:24:53 +0200
Message-ID: <20260721152509.485453057@linuxfoundation.org>
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
@@ -1044,6 +1044,9 @@ static int vti6_changelink(struct net_de
 	struct __ip6_tnl_parm p;
 	struct vti6_net *ip6n;
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	ip6n = net_generic(net, vti6_net_id);
 	if (dev == ip6n->fb_tnl_dev)
 		return -EINVAL;


