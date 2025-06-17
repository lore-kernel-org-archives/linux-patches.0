Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5181220E71E;
	Tue, 17 Jun 2025 16:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177974; cv=none; b=hnJWmCBXVGFhu1Jag+CAAl7aR+roUpTxDbpe4Wqp9sAJhvqQpBIcXIi6QuUWNu4I0y6O5vqZlRoMMXCQyUo1MZPj4Iw9eP/Gu30xV291gB7ce1WuNZ1h6Hw1neHektYrEisdhKHkzrXxHSAF47G4wyY3vRE8ecnf98Poo1j6Iyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177974; c=relaxed/simple;
	bh=kweeEq81c5lK+oTfXDV4igMjA0O1g3BpnFyQlNVAUjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSgtQinAGaYDMx6mbuUhz8IptJzjYyLpdR+Mu6zs2IlzJY0AJ8MEUka/ZJwomTlx08hydkIZiYGimyYsFHxt2l+J5yYysFni9OzCDtOj9aG/E5vTK4YlFNICDfruUP3V3CfpnwK4hV/H/pd1k9Ek/seX6XeEpyYf/u/IStUEUjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3Dqkan0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3Dqkan0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BAEC4CEE3;
	Tue, 17 Jun 2025 16:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177974;
	bh=kweeEq81c5lK+oTfXDV4igMjA0O1g3BpnFyQlNVAUjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I3Dqkan0dUVGKE9RJKrRLltKOi1OtCgewVZGzlFEo8ejH6+8iBlLk1tVh+IYCcyZ8
	 bhi+rolEP04XtTPE5IBOiAwHGpZZk3p/TFlcqzzCYGEG15k192MwSVbVEZhfabTxVB
	 IGiLoGQPb5auVHr0nkCqSo0QZFASv5hN444G0EgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 426/512] net: dsa: b53: fix untagged traffic sent via cpu tagged with VID 0
Date: Tue, 17 Jun 2025 17:26:32 +0200
Message-ID: <20250617152436.831531049@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 692eb9f8a5b71d852e873375d20cf5da7a046ea6 ]

When Linux sends out untagged traffic from a port, it will enter the CPU
port without any VLAN tag, even if the port is a member of a vlan
filtering bridge with a PVID egress untagged VLAN.

This makes the CPU port's PVID take effect, and the PVID's VLAN
table entry controls if the packet will be tagged on egress.

Since commit 45e9d59d3950 ("net: dsa: b53: do not allow to configure
VLAN 0") we remove bridged ports from VLAN 0 when joining or leaving a
VLAN aware bridge. But we also clear the untagged bit, causing untagged
traffic from the controller to become tagged with VID 0 (and priority
0).

Fix this by not touching the untagged map of VLAN 0. Additionally,
always keep the CPU port as a member, as the untag map is only effective
as long as there is at least one member, and we would remove it when
bridging all ports and leaving no standalone ports.

Since Linux (and the switch) treats VLAN 0 tagged traffic like untagged,
the actual impact of this is rather low, but this also prevented earlier
detection of the issue.

Fixes: 45e9d59d3950 ("net: dsa: b53: do not allow to configure VLAN 0")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20250602194914.1011890-1-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 79039c0941c20..71c30a81c36db 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2036,9 +2036,6 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 
 		b53_get_vlan_entry(dev, pvid, vl);
 		vl->members &= ~BIT(port);
-		if (vl->members == BIT(cpu_port))
-			vl->members &= ~BIT(cpu_port);
-		vl->untag = vl->members;
 		b53_set_vlan_entry(dev, pvid, vl);
 	}
 
@@ -2117,8 +2114,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 		}
 
 		b53_get_vlan_entry(dev, pvid, vl);
-		vl->members |= BIT(port) | BIT(cpu_port);
-		vl->untag |= BIT(port) | BIT(cpu_port);
+		vl->members |= BIT(port);
 		b53_set_vlan_entry(dev, pvid, vl);
 	}
 }
-- 
2.39.5



