Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CD7405845;
	Tue, 21 Jul 2026 17:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654974; cv=none; b=UU0I8sKbf51Qj0GPpulIe2P4ID8rfCHyUcChNj9DgRErdd0+5xenCZDQhdd5Y7BgMJPXbCIftRKhv+M/c64uP2PGv+lH7EotjDS+yjQuAdIl/OCn+33QFMNnsieqi3Der/KlDfoPMfPBqChHLuPwzt1wXp7M/vAj9LwIIOtKw0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654974; c=relaxed/simple;
	bh=U8vPVpueaRm/edOS6fLP4qTIpgyyVlUeCBWE3tbRhBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZIRMw+7N1I5uU2FbFoxLkRj/X1Sjk5peLxzplyUl2U/QUB4lVBEJGdO/uiP7NzcM8EWgEyjf6eApWh2QuuSE+BRwY3xPsUT+qkT8XRSZixnrxQcVXGIc1CVDznUmiN5rvqgObTmWm+OWX7/hmYqbvxu4Bm/IicKFKz/Fj9rR+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEUHAoBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEUHAoBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0E81F000E9;
	Tue, 21 Jul 2026 17:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654973;
	bh=G0HjB7OKB6ZNYW8Np/TbEB1XpCsX4LJs47PqsBvs858=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEUHAoBqK/P4V+i0R6iJn93SNPlNHkiXzNa4GBbf4RSoXoIysFDz9HnKli/EuKnin
	 Nv6dj4A4AUGLbCUPoJlKIHOjNw67xp7ooAZc0IW+GTGBKOgOM5ygZx6kpoUX0CanZ8
	 3dOveRY6z2a3qaKzB9yB3t67wGjfjbcRldeWF7vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1909/2077] net: sit: require CAP_NET_ADMIN in the device netns for changelink
Date: Tue, 21 Jul 2026 17:26:22 +0200
Message-ID: <20260721152637.746765934@linuxfoundation.org>
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
@@ -1611,6 +1611,9 @@ static int ipip6_changelink(struct net_d
 	__u32 fwmark = t->fwmark;
 	int err;
 
+	if (!rtnl_dev_link_net_capable(dev, net))
+		return -EPERM;
+
 	if (dev == sitn->fb_tunnel_dev)
 		return -EINVAL;
 


