Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1A11DF72F;
	Wed,  6 Nov 2024 12:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895564; cv=none; b=mBJ3LwDNAUgouEUfMNNvoivWBB1y9X/wkYdeb1xDJvAeu4W0hzXpDxluI4OhFOmv+MAtMj3Nt/9JXp1p1L33UeMkM8sl1wgG454DPGlREulcNKtrCijVqMKKglX33OMfJVo/AcirZUBHsiia0ER9tvyL7vYxIscT+23ZPFmoogE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895564; c=relaxed/simple;
	bh=ST86yPLu9pBZXPiG1S+ifwx06SrCvFBdX324CZf9XyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGAVD6fk5p2KT60lUFFQcs4LZPgD3joT6mxkLkVAqSP79vjtpf3DohvioplIEn+Zkry090o9lfYNRxd85CEWpYQR2rOJbR57pVSNMhI4UpuucHf4b2a3RqEbwReXP9lGyzfd5I7r5PJ2XhmKnn0CCNZmbrXWjtCbhYxe0q9hvfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7HV+UdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7HV+UdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452C8C4CECD;
	Wed,  6 Nov 2024 12:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895564;
	bh=ST86yPLu9pBZXPiG1S+ifwx06SrCvFBdX324CZf9XyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7HV+UdRBDCQbLkxQ8drsslnVX0FZDY8JE5s2lWGJDUo5vZBAvBqAN8NMXcH+JS0S
	 lw/q+p7bWCZwTnlLf9FcKJBiLrmRxHDjOs5n7ENL8qQKCRZE+JtnKguqhXeQ+UkrKj
	 jfvVamoQ0MmZOFiJeDYvNZW2WZuakRBx9ibk49KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Nixdorf <j.nixdorf@avm.de>,
	"David S. Miller" <davem@davemloft.net>,
	Bruno VERNAY <bruno.vernay@se.com>,
	Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Subject: [PATCH 4.19 261/350] net: ipv6: ensure we call ipv6_mc_down() at most once
Date: Wed,  6 Nov 2024 13:03:09 +0100
Message-ID: <20241106120327.351789236@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: j.nixdorf@avm.de <j.nixdorf@avm.de>

commit 9995b408f17ff8c7f11bc725c8aa225ba3a63b1c upstream.

There are two reasons for addrconf_notify() to be called with NETDEV_DOWN:
either the network device is actually going down, or IPv6 was disabled
on the interface.

If either of them stays down while the other is toggled, we repeatedly
call the code for NETDEV_DOWN, including ipv6_mc_down(), while never
calling the corresponding ipv6_mc_up() in between. This will cause a
new entry in idev->mc_tomb to be allocated for each multicast group
the interface is subscribed to, which in turn leaks one struct ifmcaddr6
per nontrivial multicast group the interface is subscribed to.

The following reproducer will leak at least $n objects:

ip addr add ff2e::4242/32 dev eth0 autojoin
sysctl -w net.ipv6.conf.eth0.disable_ipv6=1
for i in $(seq 1 $n); do
	ip link set up eth0; ip link set down eth0
done

Joining groups with IPV6_ADD_MEMBERSHIP (unprivileged) or setting the
sysctl net.ipv6.conf.eth0.forwarding to 1 (=> subscribing to ff02::2)
can also be used to create a nontrivial idev->mc_list, which will the
leak objects with the right up-down-sequence.

Based on both sources for NETDEV_DOWN events the interface IPv6 state
should be considered:

 - not ready if the network interface is not ready OR IPv6 is disabled
   for it
 - ready if the network interface is ready AND IPv6 is enabled for it

The functions ipv6_mc_up() and ipv6_down() should only be run when this
state changes.

Implement this by remembering when the IPv6 state is ready, and only
run ipv6_mc_down() if it actually changed from ready to not ready.

The other direction (not ready -> ready) already works correctly, as:

 - the interface notification triggered codepath for NETDEV_UP /
   NETDEV_CHANGE returns early if ipv6 is disabled, and
 - the disable_ipv6=0 triggered codepath skips fully initializing the
   interface as long as addrconf_link_ready(dev) returns false
 - calling ipv6_mc_up() repeatedly does not leak anything

Fixes: 3ce62a84d53c ("ipv6: exit early in addrconf_notify() if IPv6 is disabled")
Signed-off-by: Johannes Nixdorf <j.nixdorf@avm.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Bruno VERNAY <bruno.vernay@se.com>
Signed-off-by: Hugo SIMELIERE <hsimeliere.opensource@witekio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3679,6 +3679,7 @@ static int addrconf_ifdown(struct net_de
 	struct inet6_ifaddr *ifa;
 	LIST_HEAD(tmp_addr_list);
 	bool keep_addr = false;
+	bool was_ready;
 	int state, i;
 
 	ASSERT_RTNL();
@@ -3744,7 +3745,10 @@ restart:
 
 	addrconf_del_rs_timer(idev);
 
-	/* Step 2: clear flags for stateless addrconf */
+	/* Step 2: clear flags for stateless addrconf, repeated down
+	 *         detection
+	 */
+	was_ready = idev->if_flags & IF_READY;
 	if (!how)
 		idev->if_flags &= ~(IF_RS_SENT|IF_RA_RCVD|IF_READY);
 
@@ -3824,7 +3828,7 @@ restart:
 	if (how) {
 		ipv6_ac_destroy_dev(idev);
 		ipv6_mc_destroy_dev(idev);
-	} else {
+	} else if (was_ready) {
 		ipv6_mc_down(idev);
 	}
 


