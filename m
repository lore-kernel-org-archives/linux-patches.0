Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1233237F0E4;
	Mon,  9 Feb 2026 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647998; cv=none; b=CdSS/vGDcreM95Mrv33zLShN7eOys/qp4NagNgEtMEvH7KAUhaJKhlllJL6IYI35vKSmg3nr+p05+WK2YsIp3AEIXK7jdwSITg+sHGbsXAOuaAgnW1mI7nmRq/8vNZAWi0BrxH1RiP02t4L5Wv0wC7Nzri4EQXU2gAN/RPVfJPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647998; c=relaxed/simple;
	bh=f0MbFLYMpQD4rYbvDBKJG1X4IFZvRGh+z98qiRISzCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeIMpTocNtZtvepFG9wj1I1V11yjloABKHA1+ncNL2sQFdsaNV7bFe4mGr55kaRcWDOpXzJYDqUhsKXVAdfxAbhZXqrwuvj6t7MkjmUewPpVjhTAjzb9f6dYmOd7DUURT1HFB8cg6eMiS5GN9cA+Lkt/dRo6WlZb9zwwNAg26h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtV6lqu0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtV6lqu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595A9C116C6;
	Mon,  9 Feb 2026 14:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647997;
	bh=f0MbFLYMpQD4rYbvDBKJG1X4IFZvRGh+z98qiRISzCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtV6lqu0jMqXBRplu4Nyqyr0VFIsWozTMGASfzmWvPzpIzR/xsgmoarZbDpMY0tbt
	 9bacig95vIrxc2xSPKtEQ/CVI6uilTsH/ZdM0E4D8baoA1fg7URz4Kt7A+rtyfoxrz
	 mGzPPvMPzV8p7rmVJXWkGlTCbuVBkvkaCWCJ6fDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	valis <sec@valis.email>,
	syzbot+7182fbe91e58602ec1fe@syzkaller.appspotmail.com,
	Boudewijn van der Heide <boudewijn@delta-utec.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/113] macvlan: fix error recovery in macvlan_common_newlink()
Date: Mon,  9 Feb 2026 15:23:59 +0100
Message-ID: <20260209142313.417305107@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f8db6475a83649689c087a8f52486fcc53e627e9 ]

valis provided a nice repro to crash the kernel:

ip link add p1 type veth peer p2
ip link set address 00:00:00:00:00:20 dev p1
ip link set up dev p1
ip link set up dev p2

ip link add mv0 link p2 type macvlan mode source
ip link add invalid% link p2 type macvlan mode source macaddr add 00:00:00:00:00:20

ping -c1 -I p1 1.2.3.4

He also gave a very detailed analysis:

<quote valis>

The issue is triggered when a new macvlan link is created  with
MACVLAN_MODE_SOURCE mode and MACVLAN_MACADDR_ADD (or
MACVLAN_MACADDR_SET) parameter, lower device already has a macvlan
port and register_netdevice() called from macvlan_common_newlink()
fails (e.g. because of the invalid link name).

In this case macvlan_hash_add_source is called from
macvlan_change_sources() / macvlan_common_newlink():

This adds a reference to vlan to the port's vlan_source_hash using
macvlan_source_entry.

vlan is a pointer to the priv data of the link that is being created.

When register_netdevice() fails, the error is returned from
macvlan_newlink() to rtnl_newlink_create():

        if (ops->newlink)
                err = ops->newlink(dev, &params, extack);
        else
                err = register_netdevice(dev);
        if (err < 0) {
                free_netdev(dev);
                goto out;
        }

and free_netdev() is called, causing a kvfree() on the struct
net_device that is still referenced in the source entry attached to
the lower device's macvlan port.

Now all packets sent on the macvlan port with a matching source mac
address will trigger a use-after-free in macvlan_forward_source().

</quote valis>

With all that, my fix is to make sure we call macvlan_flush_sources()
regardless of @create value whenever "goto destroy_macvlan_port;"
path is taken.

Many thanks to valis for following up on this issue.

Fixes: aa5fd0fb7748 ("driver: macvlan: Destroy new macvlan port if macvlan_common_newlink failed.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: valis <sec@valis.email>
Reported-by: syzbot+7182fbe91e58602ec1fe@syzkaller.appspotmail.com
Closes: https: //lore.kernel.org/netdev/695fb1e8.050a0220.1c677c.039f.GAE@google.com/T/#u
Cc: Boudewijn van der Heide <boudewijn@delta-utec.com>
Link: https://patch.msgid.link/20260129204359.632556-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index ee59b57dfb53a..aaf7d755fc8a1 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1563,9 +1563,10 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	/* the macvlan port may be freed by macvlan_uninit when fail to register.
 	 * so we destroy the macvlan port only when it's valid.
 	 */
-	if (create && macvlan_port_get_rtnl(lowerdev)) {
+	if (macvlan_port_get_rtnl(lowerdev)) {
 		macvlan_flush_sources(port, vlan);
-		macvlan_port_destroy(port->dev);
+		if (create)
+			macvlan_port_destroy(port->dev);
 	}
 	return err;
 }
-- 
2.51.0



