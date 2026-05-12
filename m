Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBD43C09ED;
	Tue, 12 May 2026 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608492; cv=none; b=Kz15uic1aT2JgwmlrQPWbHmG1rZv06cacR7FPJK6Udt7iHq0V5glpEwcCPGB9n1fagvehJMCvzx2QHoygxXSzrsDsa3IGS4kzfEoifl8owRU6QznzHZvaZck5qPuE6VTjhQ0gyfOLeVsEa/I9bUpBxsFFPbeZGdCnrAhzU/OV5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608492; c=relaxed/simple;
	bh=cWaNFMIg5yS0lW7ovG4+YwfTlnCoMxRuStJUbGPsAbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bE4oiULHUtqunKkr3xRORbQ6wNssKPPIO7GJLuVQqWHQgFhgvMmEPXhlb8z6wnDBgk5DYPAufjcnWoF2phZ8xHGyPgiViiFXxgh6pM+9MwdBaz+TIobQ0VU7uQ98DWhABySuHhMfIxO5h+SzGdRF5nr21Z1Ww0xKefTalkHeVOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+iVMa/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+iVMa/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7004C2BCB0;
	Tue, 12 May 2026 17:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608492;
	bh=cWaNFMIg5yS0lW7ovG4+YwfTlnCoMxRuStJUbGPsAbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+iVMa/lDCPAYIQSUftGSYel3dlhy8vTTs0EVAJI5SJ3yZ/JfBCa7+fUmdhdp1ER7
	 BTRn+b38NE2CH/xJ2n7F2zzvb1n3rSU2jqL18sXYie+pimHwtsodXXVPWbaWh7N+97
	 eB2plw7ITKfWx07YGsD3XIim7FczOlM/bXLWjcbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 100/270] ip6_gre: Use cached t->net in ip6erspan_changelink().
Date: Tue, 12 May 2026 19:38:21 +0200
Message-ID: <20260512173940.564546266@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

commit 1d324c2f43f70c965f25c58cc3611c779adbe47e upstream.

After commit 5e72ce3e3980 ("net: ipv6: Use link netns in newlink() of
rtnl_link_ops"), ip6erspan_newlink() correctly resolves the per-netns
ip6gre hash via link_net. ip6erspan_changelink() was not converted in
that series and still uses dev_net(dev), which diverges from the
device's creation netns after IFLA_NET_NS_FD migration.

This re-inserts the tunnel into the wrong per-netns hash. The
original netns keeps a stale entry. When that netns is later
destroyed, ip6gre_exit_rtnl_net() walks the stale entry, producing a
slab-use-after-free reported by KASAN, followed by a kernel BUG at
net/core/dev.c (LIST_POISON1) in unregister_netdevice_many_notify().

Reachable from an unprivileged user namespace (unshare --user
--map-root-user --net).

ip6gre_changelink() earlier in the same file already uses the cached
t->net; only ip6erspan_changelink() has the wrong shape.

Fixes: 2d665034f239 ("net: ip6_gre: Fix ip6erspan hlen calculation")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260430103318.3206018-1-maoyi.xie@ntu.edu.sg
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2261,10 +2261,11 @@ static int ip6erspan_changelink(struct n
 				struct nlattr *data[],
 				struct netlink_ext_ack *extack)
 {
-	struct ip6gre_net *ign = net_generic(dev_net(dev), ip6gre_net_id);
+	struct ip6_tnl *t = netdev_priv(dev);
 	struct __ip6_tnl_parm p;
-	struct ip6_tnl *t;
+	struct ip6gre_net *ign;
 
+	ign = net_generic(t->net, ip6gre_net_id);
 	t = ip6gre_changelink_common(dev, tb, data, &p, extack);
 	if (IS_ERR(t))
 		return PTR_ERR(t);


