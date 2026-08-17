Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4003A424D6D;
	Mon, 17 Aug 2026 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979356; cv=none; b=L+qYUvzaTGK/o73/+qhvWKnbHTKGx8gdxTOAuBf9ydQDo+WVaP4EbAAvkQY/q1bOoraqbFjP4TxtWpSagf0CN+xl6FUpjoXESNGBFCdaaNzxPMIPKx/kryCX34rEh7pRwP/v7SZ9mmL7Ckx+Q+7iq5ZM1zNNVsHRnarEos5cY6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979356; c=relaxed/simple;
	bh=ZVdNGoNQDAXVlSw8SfTk8V92vxlpDvusHJeD0lG+FOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNLR5I4GfL/RysYgCZzIUiLTvGPk7GabVw2QPUeTThE6lW2AkBhncbUitZhmiE4OEKIBFyNbCOKygenvTTYFKEK9NQIA2uLxYKa8BOFZPcl3V7MGXItDEgKzXqY2WO1rgeS8GrwewegmULdR3S1yGFpuBGAR3X9ckFl8HYPmyMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pima61hI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pima61hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B04B1F000E9;
	Mon, 17 Aug 2026 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979355;
	bh=vM1ZBJMGx1Ji06IPfQwMVsJb8A8g3S+M6ilcJ+MR97E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pima61hINFQh3BrtZ1H0eJlabzu3vhhNbqqGtRYdHFmM2yZLScCPoy2e5M1PqWaRf
	 9aQnRQS4b5jViBZ8k5O4HJpYqmTXc0mbh+12Bht0DGtvDL5zARS4hlC3lA+sA8MZuA
	 dC6J3qC3MoEQ0zxAuS8ZiRwqWJmQLEYir605KKbw=
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
Subject: [PATCH 6.1 149/609] net: hsr: fix memory leak on slave unregistration by removing synced VLANs
Date: Mon, 17 Aug 2026 15:27:25 +0200
Message-ID: <20260817132548.995738465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b8230faa567f77..58e757dc555461 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -228,6 +228,8 @@ void hsr_del_port(struct hsr_port *port)
 		netdev_rx_handler_unregister(port->dev);
 		if (!port->hsr->fwd_offloaded)
 			dev_set_promiscuity(port->dev, -1);
+		if (port->type == HSR_PT_SLAVE_A || port->type == HSR_PT_SLAVE_B)
+			vlan_vids_del_by_dev(port->dev, master->dev);
 		netdev_upper_dev_unlink(port->dev, master->dev);
 	}
 
-- 
2.53.0



