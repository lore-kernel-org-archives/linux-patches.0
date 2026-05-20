Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93091402BB5;
	Wed, 20 May 2026 18:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302940; cv=none; b=lMOyOK4cCgI+ZfguRsJ147aPKQOBG01hJL3qz9ZgQ4kBhx7k/K4Fb4cQrZDA9h07+G1etQOgrbFzLk55iV4d18w78jbMq53UEpTdt3PzAWAMdSTCbQPhn9a6zT5kaBIZBGYII2Pl6Aoe1ZYY3iI2w6ay1gesOHQSXHk5ApRi+ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302940; c=relaxed/simple;
	bh=CsKdc6cZqbm4p0n/WScdjK+DA04A4I6b0oWs8hKG1eQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/Bx5VxMrjDdgCehpAOwFl7KrRUmntwq6PS87m8uH3VGrvVeX7uWRteX1Fb/GvopxTLsZWBPp6e9PaaLx7T4n6/AasLGPDCAgBTuJdcxCNrHSkk2AkqRHXT2aWz00IuXo4NVLaWVYMIXMZlLRyEOUh9yOwPYfV7B+gzCw3vWkAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hv+UY4ij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hv+UY4ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F46C1F000E9;
	Wed, 20 May 2026 18:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302938;
	bh=81P97zKR82qANNcp18/i0zbSq/CZDHGdAlcQ4XxBOxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hv+UY4ijVLzoV+dNAHdFDsRoByAfXvH+ehIYnJ9Gy6nOpzXjdJYn/rNcHykgKJHEz
	 rEv3PE0VamZ/X08gDZADIwFksrx2ZG3pBC+QU0NGYkymI7biIRZu1i5EyVpavKyJAM
	 apkrQslxXRJnHgwPa7d52phP5nvSwIGUVpFzptuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoran Ilievski <goodboy@rexbytes.com>,
	Sukhdeep Singh <sukhdeeps@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 457/508] net: atlantic: preserve PCI wake-from-D3 on shutdown when WOL enabled
Date: Wed, 20 May 2026 18:24:40 +0200
Message-ID: <20260520162108.497159697@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
@@ -374,7 +374,7 @@ static void aq_pci_shutdown(struct pci_d
 	pci_disable_device(pdev);
 
 	if (system_state == SYSTEM_POWER_OFF) {
-		pci_wake_from_d3(pdev, false);
+		pci_wake_from_d3(pdev, self->aq_hw->aq_nic_cfg->wol);
 		pci_set_power_state(pdev, PCI_D3hot);
 	}
 }


