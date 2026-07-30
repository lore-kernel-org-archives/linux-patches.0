Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49A8331A48;
	Thu, 30 Jul 2026 15:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425864; cv=none; b=uSKGiAZPJgUcV8AqUHoBakmngnZ98NQwZIs/QQQ+3eI+DmI+ECj+He5TcI1kF0kmlQcBEk8m7eSz414c6cWZWyuUyeB/rLpYlq4gABu/oa2EMUY4fVDRYE6s/dwoz9YFs4wMnfQRMYJln71NKGLptp4uLWDJsrSPj2/vyYO1pmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425864; c=relaxed/simple;
	bh=is4q215oogEZoh1SlPhVZ2pTBp/IdUjtLvyRa/ii0Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/uORkb3MHP4YxR9bVsyPAxflWlc+nlxZO5QZwFzZsVttxWhvCxsGo5pEXZPX6pFwFyo1qfopVx8ui8LoaVRuPl8gGy22YsCS15eI2HOnYp2sNucFy+mz0YzT8j4camJ29PrjrrFfbwRaK2+lWl1vaJMSaj6riMUZBfNq1eWXSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/BlV5Wm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/BlV5Wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142821F000E9;
	Thu, 30 Jul 2026 15:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425863;
	bh=kOOWcOEkywOEf2pCSzo+fH34tFCFP7kHyg7dN+ThFt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/BlV5WmtY8T33lSVL0ql1Sb4UQTH8X0WHUWchmoQfshIKwoDi6x/63AJrb9A6JQE
	 p0QQLMnikNuywh30LK2KXHRVSt7dw4dj53qj+JqJ7zbudcJkst912kZAxDmG2btcY6
	 mYlpJtSslsJunZ5nPMLg5f25A0k9tCLyrRQNo2UU=
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
Subject: [PATCH 6.12 217/602] net: hsr: fix memory leak on slave unregistration by removing synced VLANs
Date: Thu, 30 Jul 2026 16:10:09 +0200
Message-ID: <20260730141440.515291201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 70472726c60494..ffc72597295273 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -238,6 +238,8 @@ void hsr_del_port(struct hsr_port *port)
 		netdev_rx_handler_unregister(port->dev);
 		if (!port->hsr->fwd_offloaded)
 			dev_set_promiscuity(port->dev, -1);
+		if (port->type == HSR_PT_SLAVE_A || port->type == HSR_PT_SLAVE_B)
+			vlan_vids_del_by_dev(port->dev, master->dev);
 		netdev_upper_dev_unlink(port->dev, master->dev);
 	}
 
-- 
2.53.0



