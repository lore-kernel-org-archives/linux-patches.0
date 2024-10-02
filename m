Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F81F1D07B1;
	Wed,  2 Oct 2024 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876568; cv=none; b=WXye1RO2tHMp1KRDxrxg4vgS9po0vlLjcXuMhmYzLRIjoE/yjfnMZZkPEcEyPhagw+WlDr3Vqc8QSwCfHccAySWpxKoffTkHhKGAJp4fDQIbOtCJGCQgIbksxGNwJSqtpQApJdUpO5qAQ609gOELqAmT8I+7d5zPr1lGzRwhI3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876568; c=relaxed/simple;
	bh=0qvzFoNXwaRyUz/lHwOnqN6EV5gGjrKGRX9UfF0vZa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6PBLH+bxgQ2aKMIHiQdlfTfrFl6Q5Yd9gc693jAetjDG7mfPw9Fb8uR6RV62hKIQijb1V5+qV4Icn/pobbCsuW35CN1OFnDeA3w6uEhCx8aHVw+vs3q5woW0qQRvNn87d9bREHNdXoK3jwGtDaFR9xY9lVSCO6NaZmWkaF9E/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fstxkuor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fstxkuor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB57CC4CEC5;
	Wed,  2 Oct 2024 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876568;
	bh=0qvzFoNXwaRyUz/lHwOnqN6EV5gGjrKGRX9UfF0vZa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FstxkuorOGi132zA1vHwDDEyr6pXP4zJa2oRU7h97zUADvpfQEO7dcJfBZ909O6IC
	 SkfyQ4CjWPCFUWSPR/vQIEpWy/yzbr02oh7x2csHCFz8HEma7GyZrdrxWaNPgC6nIC
	 sdNRIxf0Dnq59gKkV+eXMkjJv5sYdZmTtBWZXRuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c187823a52ed505b2257@syzkaller.appspotmail.com,
	Jiwon Kim <jiwonaid0@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 487/695] bonding: Fix unnecessary warnings and logs from bond_xdp_get_xmit_slave()
Date: Wed,  2 Oct 2024 14:58:05 +0200
Message-ID: <20241002125841.907118401@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiwon Kim <jiwonaid0@gmail.com>

[ Upstream commit 0cbfd45fbcf0cb26d85c981b91c62fe73cdee01c ]

syzbot reported a WARNING in bond_xdp_get_xmit_slave. To reproduce
this[1], one bond device (bond1) has xdpdrv, which increases
bpf_master_redirect_enabled_key. Another bond device (bond0) which is
unsupported by XDP but its slave (veth3) has xdpgeneric that returns
XDP_TX. This triggers WARN_ON_ONCE() from the xdp_master_redirect().
To reduce unnecessary warnings and improve log management, we need to
delete the WARN_ON_ONCE() and add ratelimit to the netdev_err().

[1] Steps to reproduce:
    # Needs tx_xdp with return XDP_TX;
    ip l add veth0 type veth peer veth1
    ip l add veth3 type veth peer veth4
    ip l add bond0 type bond mode 6 # BOND_MODE_ALB, unsupported by XDP
    ip l add bond1 type bond # BOND_MODE_ROUNDROBIN by default
    ip l set veth0 master bond1
    ip l set bond1 up
    # Increases bpf_master_redirect_enabled_key
    ip l set dev bond1 xdpdrv object tx_xdp.o section xdp_tx
    ip l set veth3 master bond0
    ip l set bond0 up
    ip l set veth4 up
    # Triggers WARN_ON_ONCE() from the xdp_master_redirect()
    ip l set veth3 xdpgeneric object tx_xdp.o section xdp_tx

Reported-by: syzbot+c187823a52ed505b2257@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c187823a52ed505b2257
Fixes: 9e2ee5c7e7c3 ("net, bonding: Add XDP support to the bonding driver")
Signed-off-by: Jiwon Kim <jiwonaid0@gmail.com>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20240918140602.18644-1-jiwonaid0@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index bb9c3d6ef4359..e20bee1bdffd7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5536,9 +5536,9 @@ bond_xdp_get_xmit_slave(struct net_device *bond_dev, struct xdp_buff *xdp)
 		break;
 
 	default:
-		/* Should never happen. Mode guarded by bond_xdp_check() */
-		netdev_err(bond_dev, "Unknown bonding mode %d for xdp xmit\n", BOND_MODE(bond));
-		WARN_ON_ONCE(1);
+		if (net_ratelimit())
+			netdev_err(bond_dev, "Unknown bonding mode %d for xdp xmit\n",
+				   BOND_MODE(bond));
 		return NULL;
 	}
 
-- 
2.43.0



