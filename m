Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C1B1420B3;
	Tue, 27 Feb 2024 14:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044109; cv=none; b=KYyDXmKK+bop2zRIPvJc46W19jw6jQfoNwFhR7MsF8LLgR2j+NPSAQ0ChtCT1j+YjRwHLZ6Ea5/9dvuN/Sk2786S9EK4PX91J+7tBg6YhguFAtwLSfpAoFaRK8tRki9dmfP6MmVnIRFnQUvZDCeCSNeG7hNCmfMLBJZ2v2WGh9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044109; c=relaxed/simple;
	bh=q7MRvqhoINgS5o2/IQY3c2ZPEzu70ViMQoyIYMkqDKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i532tC9KKaGPoYHE3Pg1/N91Qjx1iHCqJ+caWyN2izLsRONl2n4eFH5cf8vCxSMkFOjd1N98xXd/R22hwVutGhOmYCqOE9AnJGgHgTNI59mclB8zNpW37nJyT/ujoIMQWbmua8yMbP8KdRzLulIHF6N7wg9YBtvV/Dnfkw8miwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNUJU0RV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNUJU0RV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652DCC433F1;
	Tue, 27 Feb 2024 14:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044108;
	bh=q7MRvqhoINgS5o2/IQY3c2ZPEzu70ViMQoyIYMkqDKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNUJU0RVj7l+y5yu05TDfrPMhOXoNxt2hu1N3yA1+nhLGCYMmCRmaTtvwvK7z23wk
	 FSwH/uBl3luKA6cE1s4aiNZ9dv8sBMiDQCjsyQkG5ykgMQOEwlBE6c/lfQoftQSXj0
	 CADAuxSePZOb/DDNwjPBEBTpJF4Q8xgotof2WYMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergej Bauer <sbauer@blackbox.su>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/122] lan743x: fix for potential NULL pointer dereference with bare card
Date: Tue, 27 Feb 2024 14:27:06 +0100
Message-ID: <20240227131600.830937903@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergej Bauer <sbauer@blackbox.su>

[ Upstream commit e9e13b6adc338be1eb88db87bcb392696144bd02 ]

This is the 3rd revision of the patch fix for potential null pointer dereference
with lan743x card.

The simpliest way to reproduce: boot with bare lan743x and issue "ethtool ethN"
commant where ethN is the interface with lan743x card. Example:

$ sudo ethtool eth7
dmesg:
[  103.510336] BUG: kernel NULL pointer dereference, address: 0000000000000340
...
[  103.510836] RIP: 0010:phy_ethtool_get_wol+0x5/0x30 [libphy]
...
[  103.511629] Call Trace:
[  103.511666]  lan743x_ethtool_get_wol+0x21/0x40 [lan743x]
[  103.511724]  dev_ethtool+0x1507/0x29d0
[  103.511769]  ? avc_has_extended_perms+0x17f/0x440
[  103.511820]  ? tomoyo_init_request_info+0x84/0x90
[  103.511870]  ? tomoyo_path_number_perm+0x68/0x1e0
[  103.511919]  ? tty_insert_flip_string_fixed_flag+0x82/0xe0
[  103.511973]  ? inet_ioctl+0x187/0x1d0
[  103.512016]  dev_ioctl+0xb5/0x560
[  103.512055]  sock_do_ioctl+0xa0/0x140
[  103.512098]  sock_ioctl+0x2cb/0x3c0
[  103.512139]  __x64_sys_ioctl+0x84/0xc0
[  103.512183]  do_syscall_64+0x33/0x80
[  103.512224]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  103.512274] RIP: 0033:0x7f54a9cba427
...

Previous versions can be found at:
v1:
initial version
    https://lkml.org/lkml/2020/10/28/921

v2:
do not return from lan743x_ethtool_set_wol if netdev->phydev == NULL, just skip
the call of phy_ethtool_set_wol() instead.
    https://lkml.org/lkml/2020/10/31/380

v3:
in function lan743x_ethtool_set_wol:
use ternary operator instead of if-else sentence (review by Markus Elfring)
return -ENETDOWN insted of -EIO (review by Andrew Lunn)

Signed-off-by: Sergej Bauer <sbauer@blackbox.su>

Link: https://lore.kernel.org/r/20201101223556.16116-1-sbauer@blackbox.su
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_ethtool.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index dcde496da7fb4..c5de8f46cdd35 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -780,7 +780,9 @@ static void lan743x_ethtool_get_wol(struct net_device *netdev,
 
 	wol->supported = 0;
 	wol->wolopts = 0;
-	phy_ethtool_get_wol(netdev->phydev, wol);
+
+	if (netdev->phydev)
+		phy_ethtool_get_wol(netdev->phydev, wol);
 
 	wol->supported |= WAKE_BCAST | WAKE_UCAST | WAKE_MCAST |
 		WAKE_MAGIC | WAKE_PHY | WAKE_ARP;
@@ -809,9 +811,8 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 
 	device_set_wakeup_enable(&adapter->pdev->dev, (bool)wol->wolopts);
 
-	phy_ethtool_set_wol(netdev->phydev, wol);
-
-	return 0;
+	return netdev->phydev ? phy_ethtool_set_wol(netdev->phydev, wol)
+			: -ENETDOWN;
 }
 #endif /* CONFIG_PM */
 
-- 
2.43.0



