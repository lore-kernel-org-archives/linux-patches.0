Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC93C2C028F;
	Thu, 15 Jan 2026 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496629; cv=none; b=OVsAhPHNssP8dvAAmoGhwXNSDSeGF+HCQM62PZ9cS7DwyNy4Eg9SrOhW21wJHWJh0rbrRc61r8BmA5m9mn3ReCsQ0kjLunSh6goVpUZtPSWB3FXzUfJhr8d6A1UOVf0P7lsxh1mkI8Eicr75EoUf/mdJTznVHy20ww9oU0JFRio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496629; c=relaxed/simple;
	bh=b65guiZd1QqrrlmYB7+Lw77OgaBhr8A1647e/t6Mbt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWdLscn/gATkMt2gWrliGDv9z/3sr0ruz3v9y1uZv3fvDvxxHb5rrXHdYmhLGxTvDnqYvwBWKAeXw2z9jN1VNWletWwtGuGVsJvFoXU1BG+6r7m46apg2H6nP4aiHstM16eu6b9Q5bUifcSjhW7UAIDgykFFR6mBuCR1PxPaHYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5Uy30hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5Uy30hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0DAC116D0;
	Thu, 15 Jan 2026 17:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496628;
	bh=b65guiZd1QqrrlmYB7+Lw77OgaBhr8A1647e/t6Mbt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5Uy30hzWJSiQEiX5+gSV3DznyeUHUsBcKSRfzxea7OBaCwRVfZ+9arlWQ2sRBvy6
	 vml7okYp22obkc1kVcrCNZ5dviAtEAeCOVYdHxlSXy/CzvJGlyc8IrZAXLgdr+e1aM
	 7d7nDvLu948rM+TmbO7PKiyYfwpPDu5M2pjbnkEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yohei Kojima <yk@y-koj.net>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/119] net: netdevsim: fix inconsistent carrier state after link/unlink
Date: Thu, 15 Jan 2026 17:48:15 +0100
Message-ID: <20260115164154.839970736@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Yohei Kojima <yk@y-koj.net>

[ Upstream commit d83dddffe1904e4a576d11a541878850a8e64cd2 ]

This patch fixes the edge case behavior on ifup/ifdown and
linking/unlinking two netdevsim interfaces:

1. unlink two interfaces netdevsim1 and netdevsim2
2. ifdown netdevsim1
3. ifup netdevsim1
4. link two interfaces netdevsim1 and netdevsim2
5. (Now two interfaces are linked in terms of netdevsim peer, but
    carrier state of the two interfaces remains DOWN.)

This inconsistent behavior is caused by the current implementation,
which only cares about the "link, then ifup" order, not "ifup, then
link" order. This patch fixes the inconsistency by calling
netif_carrier_on() when two netdevsim interfaces are linked.

This patch fixes buggy behavior on NetworkManager-based systems which
causes the netdevsim test to fail with the following error:

  # timeout set to 600
  # selftests: drivers/net/netdevsim: peer.sh
  # 2025/12/25 00:54:03 socat[9115] W address is opened in read-write mode but only supports read-only
  # 2025/12/25 00:56:17 socat[9115] W connect(7, AF=2 192.168.1.1:1234, 16): Connection timed out
  # 2025/12/25 00:56:17 socat[9115] E TCP:192.168.1.1:1234: Connection timed out
  # expected 3 bytes, got 0
  # 2025/12/25 00:56:17 socat[9109] W exiting on signal 15
  not ok 13 selftests: drivers/net/netdevsim: peer.sh # exit=1

This patch also solves timeout on TCP Fast Open (TFO) test in
NetworkManager-based systems because it also depends on netdevsim's
carrier consistency.

Fixes: 1a8fed52f7be ("netdevsim: set the carrier when the device goes up")
Signed-off-by: Yohei Kojima <yk@y-koj.net>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/602c9e1ba5bb2ee1997bb38b1d866c9c3b807ae9.1767624906.git.yk@y-koj.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/bus.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 64c0cdd31bf85..067cbf788da48 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -314,6 +314,11 @@ static ssize_t link_device_store(const struct bus_type *bus, const char *buf, si
 	rcu_assign_pointer(nsim_a->peer, nsim_b);
 	rcu_assign_pointer(nsim_b->peer, nsim_a);
 
+	if (netif_running(dev_a) && netif_running(dev_b)) {
+		netif_carrier_on(dev_a);
+		netif_carrier_on(dev_b);
+	}
+
 out_err:
 	put_net(ns_b);
 	put_net(ns_a);
@@ -363,6 +368,9 @@ static ssize_t unlink_device_store(const struct bus_type *bus, const char *buf,
 	if (!peer)
 		goto out_put_netns;
 
+	netif_carrier_off(dev);
+	netif_carrier_off(peer->netdev);
+
 	err = 0;
 	RCU_INIT_POINTER(nsim->peer, NULL);
 	RCU_INIT_POINTER(peer->peer, NULL);
-- 
2.51.0



