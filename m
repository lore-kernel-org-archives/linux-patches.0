Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80F7432E6E;
	Thu, 30 Jul 2026 14:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422057; cv=none; b=dsjTEiKjLCSzzqJIk42Kcr72hrkpiWaTbplvAGs8XOiLH5SHXFc/71ZN+AbEEpmQ/uZExjC0BhqbaMO01gavmfIyn5Uxrd5syoeNujupCQwzJv8v31B4LZRlSK9NHvHWRwInm1VMlDiGABYWVLCVox7355cPYy9jfcDQemghFdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422057; c=relaxed/simple;
	bh=wdt4vKcKyRs84pHHPOq4lHEQQRCjvcCrS2gvf+Pc5z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSRhQaUNYwgIB4QZC49++EYemwFEh0sX3627ur6ngivS/XG20OfWmSThbAQG7fGWoL0f2f/oKJBKqACV0JHNB3p/CrbKaK+E8uq8AoxaBv5CWggIA+bTSv+VspCTITwezi8kNxnaP5gsAxuwkNqjuLIRWKmioHvf2nMc67WLx4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKAekDCQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKAekDCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068AA1F000E9;
	Thu, 30 Jul 2026 14:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422056;
	bh=fF89+WJnGhj5vxCS1ZO34GdKOXPMXul+7cvaWTAxlDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKAekDCQMGHQOXJXFhBfAV6k8bVUyP/sHqGtG6KU1L1ltsPXdwqo9oVHbQWF7mI9o
	 uiuiP79V0BHQyS1kBH445zeTavm5podJpPtDAH4nsUrym8FZJIUFnU7ijMuvizfDdH
	 YNlOpl+jhEn/zTt/BR4XwnJeqs4eFtyyXMebNTqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+456957213f32970c0762@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Felix Maurer <fmaurer@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 308/744] net: hsr: fix memory leak on slave unregistration by removing synced VLANs
Date: Thu, 30 Jul 2026 16:09:41 +0200
Message-ID: <20260730141450.836115495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dcf15eaf5641812f1cfc5e96537380132a7da89d ]

When an HSR master device is brought UP, it auto-adds VLAN 0 via
vlan_vid0_add(), which propagates VID 0 to its slave devices (slave A and B).

If a slave device is later unregistered while HSR is active (e.g., during
netns cleanup or interface destruction), hsr_del_port() is called to
detach the slave port from the HSR master. However, hsr_del_port() currently
does not delete the VLAN IDs that were synced to the slave device by HSR.

As a result, the slave device retains a refcount on VID 0 (and any other
synced VLANs). When the slave device is destroyed, its vlan_info /
vlan_vid_info structure remains allocated, leading to a memory leak.

Fix this by calling vlan_vids_del_by_dev(port->dev, master->dev) in
hsr_del_port() before unlinking slave A or slave B ports, matching the
propagation logic in hsr_ndo_vlan_rx_add_vid() / hsr_ndo_vlan_rx_kill_vid()
and the cleanup behavior in bonding and team drivers.

Fixes: 1a8a63a5305e ("net: hsr: Add VLAN CTAG filter support")
Reported-by: syzbot+456957213f32970c0762@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a4cb6ca.57639fcc.86d58.000b.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Felix Maurer <fmaurer@redhat.com>
Link: https://patch.msgid.link/20260721101240.995597-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_slave.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index d9af9e65f72f07..01c73b4b50ddd8 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -242,6 +242,8 @@ void hsr_del_port(struct hsr_port *port)
 		netdev_rx_handler_unregister(port->dev);
 		if (!port->hsr->fwd_offloaded)
 			dev_set_promiscuity(port->dev, -1);
+		if (port->type == HSR_PT_SLAVE_A || port->type == HSR_PT_SLAVE_B)
+			vlan_vids_del_by_dev(port->dev, master->dev);
 		netdev_upper_dev_unlink(port->dev, master->dev);
 		if (hsr->prot_version == PRP_V1 &&
 		    port->type == HSR_PT_SLAVE_B) {
-- 
2.53.0



