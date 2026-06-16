Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617BD4779B3;
	Tue, 16 Jun 2026 16:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628134; cv=none; b=lN3LXVbq46ytHeEKw8qkCEbvrUBYbqbdhALlmb2kLzPLEHwd1le6EZcCjqsFNaihkBYtgP4473Q3KaIELQDh/ZJp8GZw0KzEiI6lPiQS+BJJoxLp+R0iMwsFxJGAvec5/M/kMPB+NOPWNGvGCJP1zDteSqdZ/s9ZEAM7zVn1r9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628134; c=relaxed/simple;
	bh=rdNGmf7HLpSBEZGDOkSz7f7Uq6Bzc9rP0nQnAtH3yRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwmPK+W6B99TP4a+TEmwN+eveI7KWH9rPwgl2S5gce+0FvKFeTmJPDVJepYAUqGJBF/LPKvaXboI0/cmjROLpUrNY8goXA4Z4ULaasaTcXVhPDu1405Vy05xCYODg8PS4q9MPqBTKQ2n6axBdrsXIdfufgp4M1qftxd9E2tU5WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ca6SqOxl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ca6SqOxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083761F000E9;
	Tue, 16 Jun 2026 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628133;
	bh=zqRGBJmHErhjEQPlfaGrQo5Of7BZ/nmdQ6oYG96F3Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ca6SqOxlXEzkqsBHxv3iJDIWzbyT5bpDtjKjq3WrUbBVVgNpfCGnY78c09Ad6rmXo
	 yF4nwUBb10fHU3aAMtamy9r0f6YUQM1Zllt9ueweBZjn7eti4zJdQTE/yMgcAIXy2N
	 wsYRy9HjosEi4G7LWV3hQ5yyVgC7Tq1TR5BKqPnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8ed98cbd0161632bce95@syzkaller.appspotmail.com,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/452] bonding: refuse to enslave CAN devices
Date: Tue, 16 Jun 2026 20:24:23 +0530
Message-ID: <20260616145119.833827119@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 8ba68464e4787b6a7ec938826e16124df20fd23d ]

syzbot reported a kernel paging request crash in
can_rx_unregister() inside net/can/af_can.c. The crash occurs
because a virtual CAN device (vxcan) is being enslaved to a
bonding master.

During the enslavement process, the bonding driver mutates
and modifies the network device states to fit an Ethernet-like
aggregation model. However, CAN devices operate on a completely
different Layer 2 architecture, relying on the CAN mid-layer
private data structure (can_ml_priv) instead of standard
Ethernet structures. Since bonding does not initialize or
maintain these CAN structures, subsequent operations on the
half-enslaved interface (such as closing associated sockets
via isotp_release) lead to a null-pointer dereference when
accessing the CAN receiver lists.

Bonding CAN interfaces is architecturally invalid as CAN lacks
MAC addresses, ARP capabilities, and standard Ethernet
link-layer mechanisms. While generic loopback devices are
blocked globally in net/core/dev.c, virtual CAN devices
bypass this check because they do not carry the IFF_LOOPBACK
flag, despite acting as local software-loopbacks.

Fix this by explicitly blocking network devices of type
ARPHRD_CAN from being enslaved at the very beginning of
bond_enslave(). This prevents illegal state mutations,
eliminates the resulting KASAN crashes, and avoids potential
memory leaks from incomplete socket cleanups.

As the CAN support has been added a long time after bonding
the Fixes-tag points to the introduction of ARPHRD_CAN that
would have needed a specific handling in bonding_main.c.

Fixes: cd05acfe65ed ("[CAN]: Allocate protocol numbers for PF_CAN")
Reported-by: syzbot+8ed98cbd0161632bce95@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8ed98cbd0161632bce95
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20260526-bonding-candev-v1-1-ba1df400918a@hartkopp.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 029a7f001dd8a0..7732f7023033ed 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1889,6 +1889,12 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	int link_reporting;
 	int res = 0, i;
 
+	if (slave_dev->type == ARPHRD_CAN) {
+		BOND_NL_ERR(bond_dev, extack,
+			    "CAN devices cannot be enslaved");
+		return -EPERM;
+	}
+
 	if (slave_dev->flags & IFF_MASTER &&
 	    !netif_is_bond_master(slave_dev)) {
 		BOND_NL_ERR(bond_dev, extack,
-- 
2.53.0



