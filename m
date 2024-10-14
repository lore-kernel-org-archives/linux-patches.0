Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AAA4087C;
	Mon, 14 Oct 2024 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918250; cv=none; b=fX417IIChCTe1N1e1ZA9FX7/Hk9tF8Ao2xPrjt25JegVPFJaAmdFcrTbw+W9CDWo9g4lTHy4rPuSVd84pO4M7/b4klFbmP9Iyv7Ep6rSWmhLNgmarKaDeRC7EXZ4A8pJkh6DN5sIU6wU9dlO3sBTKlnj95ORUNIShhcf8zN0dJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918250; c=relaxed/simple;
	bh=YbWBq9MYDwGroPA6C9jJRbFEwg4oMg66hUsOsXHf/JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOPnAtZzpeZwVYgQ4JNSM+3sUyNbjsBIzx1z0rxuHl3CpFWOBmMHewAG1i4Iw+K0nP0avfEoxtq/IoPLVtZ65bQrpuC7WvxwZcK0dDgBgIOjymh1RCZ4wC5VNH3G2ISzA8IfO798c8UQumWwAQmp8Stn0UF8tOMK0aS2xCmpsUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8YRJbQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8YRJbQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ECDC4CEC3;
	Mon, 14 Oct 2024 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918250;
	bh=YbWBq9MYDwGroPA6C9jJRbFEwg4oMg66hUsOsXHf/JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8YRJbQDkwRa8jhlJrk3aglmfaD5eBZPHS17Us9IBx/axzerRN2VN04DGMXQHktoH
	 GATq8CssiLoIGit5/Ej4CZq+B2j653HlY3nk0Ld6MfSRPcVR+516soZQ7u48J/i8hJ
	 fUXEpwpkfB8SDfw6Kpp5qAroHoucsv2Tu2jXOGxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c187823a52ed505b2257@syzkaller.appspotmail.com,
	Jiwon Kim <jiwonaid0@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 268/798] bonding: Fix unnecessary warnings and logs from bond_xdp_get_xmit_slave()
Date: Mon, 14 Oct 2024 16:13:42 +0200
Message-ID: <20241014141228.462688903@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 375412ce1ea5f..51d6cf0a3fb4e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5538,9 +5538,9 @@ bond_xdp_get_xmit_slave(struct net_device *bond_dev, struct xdp_buff *xdp)
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



