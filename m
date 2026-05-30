Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C011D63E4;
	Sat, 30 May 2026 18:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166928; cv=none; b=WnMxkLIw51zq+PHZkGroy8MvPkp7lWs3ak/O30HTea+J5sWIlxWNh8rnnJw1JyazSGAAsHF7o8Jwxx1gHTuGxbp1yajFs1yMOt8V6zA0YvUxbdbAhxFqFUNcFdRO8++nn7h0hDhIwv8sRUqY4dLmPv8E4o5CKAw7/cPK2rS494g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166928; c=relaxed/simple;
	bh=PBE5uI2dwkrTYxrnhMYN0ZscoWfDmfiSL+iZhhEExU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8RX4d7lVXcBB99oLtVGLtpFTgQupaJZ4fcaVqPl89ztt/A+EaFCxZ5jJQdKXRzHX/1idKg8pZxnqEyM5rxsnJ/xh+nBTWFXdh3C2uNI9wa0sp5KqwB7w004fdYTGURGyvtCmdffap4+cIq3BBFaayHibJKxF5HukNdeINkSzhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qg7nO2YY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qg7nO2YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A221F00893;
	Sat, 30 May 2026 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166927;
	bh=rNl6pBTLmTazntDWs6Au4EJlP0qkLGfz6aYxfM4W210=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qg7nO2YYLLh1Rl2xdxGV5O/CiZ0Xxmvsn8scwLCvt+FMudgdyGhP4Vg3obkP5/flI
	 XAU7NDOhJfo0sXcCjOTuNxZuDZ5w1ecnKP9mzbkxvaGwmM3HC91qv73q864vDi0MqC
	 KHaMBIQ2Iry7WUIroGXZDNHutgDH3B1OI4ZEQFCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoran Ilievski <goodboy@rexbytes.com>,
	Sukhdeep Singh <sukhdeeps@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 506/589] net: atlantic: preserve PCI wake-from-D3 on shutdown when WOL enabled
Date: Sat, 30 May 2026 18:06:27 +0200
Message-ID: <20260530160237.900959359@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zoran Ilievski <goodboy@rexbytes.com>

commit 2c308cf34284420963607d677d576a2b4124d8bd upstream.

The shutdown handler aq_pci_shutdown() unconditionally calls
pci_wake_from_d3(pdev, false), clearing the PCI PME_En bit even when
wake-on-LAN has been configured. While aq_nic_shutdown() correctly
programs the NIC firmware via aq_nic_set_power() to listen for magic
packets, the PCI subsystem will not propagate the resulting PME wake
event from D3, so the system never wakes after poweroff.

WOL from suspend (S3) is unaffected because aq_suspend_common() does
not touch pci_wake_from_d3() and relies on the PM core's wake
configuration via device_may_wakeup().

This affects all atlantic-supported NICs (AQC107/108/111/112/113);
users have reported that WOL works if the atlantic driver is never
loaded, but breaks once it has run its shutdown path.

Pass the configured WOL state to pci_wake_from_d3() instead of a
literal false, so the PCI PME_En bit is preserved when the user has
armed WOL via ethtool.

Fixes: 90869ddfefeb ("net: aquantia: Implement pci shutdown callback")
Cc: stable@vger.kernel.org
Signed-off-by: Zoran Ilievski <goodboy@rexbytes.com>
Reviewed-by: Sukhdeep Singh <sukhdeeps@marvell.com>
Link: https://patch.msgid.link/20260511064002.1857-1-goodboy@rexbytes.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -380,7 +380,7 @@ static void aq_pci_shutdown(struct pci_d
 	pci_disable_device(pdev);
 
 	if (system_state == SYSTEM_POWER_OFF) {
-		pci_wake_from_d3(pdev, false);
+		pci_wake_from_d3(pdev, self->aq_hw->aq_nic_cfg->wol);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 }


