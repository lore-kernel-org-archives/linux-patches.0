Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC34119CD14;
	Thu,  6 Jun 2024 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683077; cv=none; b=mBWKzzZ/TNJnWxhUBQpANbP/vZDKBOP0cDljZM2ji7zpmozAWmQr6cuKCedj640dk6DRRCHE8RIs9/ytKY/fMxLVpXB1FqszowYpps/tnSJtS2ays0P2YqhCTO75A86D2K+lFbKydlBrzMaKP6EjuvahePfQRPGzh+mGYULeuEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683077; c=relaxed/simple;
	bh=0aVMY43aLepXRALzUaskbXdxxO9NSg40xzOY8Lv+XwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0lh/BL9vpbgBEBlcNRjg1Va0JXux+p/aBTI4/x/8CeQ3ht+V+EW+3LeFwCJyAP8veDNZI6HO62IOWw/XDCjRKdplq90P+n1dwh08T6029cd62DREckd/kFQ/p3WMt/tG0jqiafJNB+nEWXBlPMK6iwv54ufM4qEWk46C8S3QCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8lhU+9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8lhU+9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C929DC4AF10;
	Thu,  6 Jun 2024 14:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683076;
	bh=0aVMY43aLepXRALzUaskbXdxxO9NSg40xzOY8Lv+XwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8lhU+9giJLwMSeh4jvmjaf5vaPEXz0FVSH7NqaRNHfijdpADYSoS5hileHjAtZa0
	 deL4K3Tn/Hp5gdEIQx5DHj3uRGfJ/b3dn4SzuPSzoHeLgeH8RHFokrD5MKgCHTqwFF
	 H9vs9ZrBlyKKnkfHqd7UUxhMqx9bthBrxneY5VH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Yamen Safadi <ysafadi@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 317/374] ipv4: Fix address dump when IPv4 is disabled on an interface
Date: Thu,  6 Jun 2024 16:04:56 +0200
Message-ID: <20240606131702.490983545@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 7b05ab85e28f615e70520d24c075249b4512044e ]

Cited commit started returning an error when user space requests to dump
the interface's IPv4 addresses and IPv4 is disabled on the interface.
Restore the previous behavior and do not return an error.

Before cited commit:

 # ip address show dev dummy1
 10: dummy1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
     link/ether e2:40:68:98:d0:18 brd ff:ff:ff:ff:ff:ff
     inet6 fe80::e040:68ff:fe98:d018/64 scope link proto kernel_ll
        valid_lft forever preferred_lft forever
 # ip link set dev dummy1 mtu 67
 # ip address show dev dummy1
 10: dummy1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 67 qdisc noqueue state UNKNOWN group default qlen 1000
     link/ether e2:40:68:98:d0:18 brd ff:ff:ff:ff:ff:ff

After cited commit:

 # ip address show dev dummy1
 10: dummy1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
     link/ether 32:2d:69:f2:9c:99 brd ff:ff:ff:ff:ff:ff
     inet6 fe80::302d:69ff:fef2:9c99/64 scope link proto kernel_ll
        valid_lft forever preferred_lft forever
 # ip link set dev dummy1 mtu 67
 # ip address show dev dummy1
 RTNETLINK answers: No such device
 Dump terminated

With this patch:

 # ip address show dev dummy1
 10: dummy1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
     link/ether de:17:56:bb:57:c0 brd ff:ff:ff:ff:ff:ff
     inet6 fe80::dc17:56ff:febb:57c0/64 scope link proto kernel_ll
        valid_lft forever preferred_lft forever
 # ip link set dev dummy1 mtu 67
 # ip address show dev dummy1
 10: dummy1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 67 qdisc noqueue state UNKNOWN group default qlen 1000
     link/ether de:17:56:bb:57:c0 brd ff:ff:ff:ff:ff:ff

I fixed the exact same issue for IPv6 in commit c04f7dfe6ec2 ("ipv6: Fix
address dump when IPv6 is disabled on an interface"), but noted [1] that
I am not doing the change for IPv4 because I am not aware of a way to
disable IPv4 on an interface other than unregistering it. I clearly
missed the above case.

[1] https://lore.kernel.org/netdev/20240321173042.2151756-1-idosch@nvidia.com/

Fixes: cdb2f80f1c10 ("inet: use xa_array iterator to implement inet_dump_ifaddr()")
Reported-by: Carolina Jubran <cjubran@nvidia.com>
Reported-by: Yamen Safadi <ysafadi@nvidia.com>
Tested-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240523110257.334315-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 7e45c34c8340a..ee5fbc19b85fc 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1882,10 +1882,11 @@ static int inet_dump_ifaddr(struct sk_buff *skb, struct netlink_callback *cb)
 			goto done;
 
 		if (fillargs.ifindex) {
-			err = -ENODEV;
 			dev = dev_get_by_index_rcu(tgt_net, fillargs.ifindex);
-			if (!dev)
+			if (!dev) {
+				err = -ENODEV;
 				goto done;
+			}
 			in_dev = __in_dev_get_rcu(dev);
 			if (!in_dev)
 				goto done;
-- 
2.43.0



