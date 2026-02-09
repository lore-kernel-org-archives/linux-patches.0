Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E222690EC;
	Mon,  9 Feb 2026 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648534; cv=none; b=UrmZ8f2dtk1P823CgPVHpyQ4BGbZ1uOH6OBebyWh6Fp7eDpzo1mLiZvJayUK5gPOqXvpSUkfiXTIV/Vj86GCtHq4xlACmXjLiF/PjQdIlIlu0zwoiXjc3y48er3qtRM7Fmu01ej9D2T9e9kUcGA75hqTgqY/Gg8wNgrAWwJN2H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648534; c=relaxed/simple;
	bh=ofipjIzMcZPqXhQOgRRP/w+DoOFJF1MxmDBy62Cu378=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8G01Xx3MP0wyCSnjzXahR80wHgjpEKHBWfmhItYwWovyAZJYa+UI/uw74v4z82/0SuK+5OEsMfQDnwhhss79Y44+CAeabJJ1yAorKqwKjs+12jbxMuJXcDcq2PO4QJ/mr0hAfNQ/pXNuIshlZ9lzRpHCF6Md701AIsFH9CwoRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1O+k8oKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1O+k8oKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFD5C116C6;
	Mon,  9 Feb 2026 14:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648534;
	bh=ofipjIzMcZPqXhQOgRRP/w+DoOFJF1MxmDBy62Cu378=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1O+k8oKtOWMz7loBJruWtjKZh7PJ3CdUxhYvBA0cMpo6Kk/smHtR3/aTxiIXDbuRS
	 EcS1eFv1SpoGCU8HXWbb37WDCmMpco/nct/kt5/J5Aql0ZVljRxpqAXkmCZexWZBBl
	 2AHbNZvAYtnfMMPrLIoMNjXiUG7aGFtnH73jkwzg=
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
Subject: [PATCH 6.6 67/86] macvlan: fix error recovery in macvlan_common_newlink()
Date: Mon,  9 Feb 2026 15:24:30 +0100
Message-ID: <20260209142307.188195144@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 09db43ce31767..fea7352e2a470 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1572,9 +1572,10 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
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



