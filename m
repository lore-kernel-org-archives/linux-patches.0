Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BBB7F7CC;
	Mon,  8 Apr 2024 13:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582075; cv=none; b=dwqgyYcEHHdnTOFmS3dy+eisWQak0U4PQ9O1qK+hgMHKqT9y5KzPdDE5ZW+CkPCP7uidY8GR0u6Q2B7tcgMzrPz24Zdyqe0oU7V0Rl/ZOsomUS8pk0Z1jzRIMqJttrGV9Ql5HQ2YEfZ+HdgBaffTVE6rnz+6ZASVjvbdRXQTn7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582075; c=relaxed/simple;
	bh=OxR1Em4nZqm3OMeso8zVYvk041Sd0k3JiXT1PFsKJr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t0gf12JAJKbPghOO84oHBoBRxN5iCPHjMFvUyf0KEQCyw22U836PtYXrYC1I7PqHwGkKThHYb7l0K3TyLK+WoEZkv5SU5k3cintlXqhYX2vi+QEmRq7/qM1/Dk/iBpsL0MSHNWEWCtSyhrZvR5Kjz5xpZT85rcVrozVza5Zn02I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDF77Ocq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDF77Ocq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15ACC433F1;
	Mon,  8 Apr 2024 13:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582075;
	bh=OxR1Em4nZqm3OMeso8zVYvk041Sd0k3JiXT1PFsKJr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDF77OcqxmyVWEn2C5q1c1vMfJI1uZo2krvajS9kvF73coP++R7NlfvTPOD/BY37Z
	 wa1nd5RvqORRwgx+quVupsfHnySyywWICzN8Rc+J01kO/DpgVM1UF9VOYkgQLk3TpE
	 CkcgyzKilpqxQqlL4udLD63xfWw3bIP66A4huUr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/138] r8169: use spinlock to protect mac ocp register access
Date: Mon,  8 Apr 2024 14:58:10 +0200
Message-ID: <20240408125258.590975554@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 91c8643578a21e435c412ffbe902bb4b4773e262 ]

For disabling ASPM during NAPI poll we'll have to access mac ocp
registers in atomic context. This could result in races because
a mac ocp read consists of a write to register OCPDR, followed
by a read from the same register. Therefore add a spinlock to
protect access to mac ocp registers.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5e864d90b208 ("r8169: skip DASH fw status checks when DASH is disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 37 ++++++++++++++++++++---
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3dbcb311dcbf2..c7dd0eb94817f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -615,6 +615,8 @@ struct rtl8169_private {
 		struct work_struct work;
 	} wk;
 
+	spinlock_t mac_ocp_lock;
+
 	unsigned supports_gmii:1;
 	unsigned aspm_manageable:1;
 	unsigned dash_enabled:1;
@@ -850,7 +852,7 @@ static int r8168_phy_ocp_read(struct rtl8169_private *tp, u32 reg)
 		(RTL_R32(tp, GPHY_OCP) & 0xffff) : -ETIMEDOUT;
 }
 
-static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
+static void __r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 {
 	if (rtl_ocp_reg_failure(reg))
 		return;
@@ -858,7 +860,16 @@ static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 	RTL_W32(tp, OCPDR, OCPAR_FLAG | (reg << 15) | data);
 }
 
-static u16 r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
+static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tp->mac_ocp_lock, flags);
+	__r8168_mac_ocp_write(tp, reg, data);
+	spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
+}
+
+static u16 __r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
 {
 	if (rtl_ocp_reg_failure(reg))
 		return 0;
@@ -868,12 +879,28 @@ static u16 r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
 	return RTL_R32(tp, OCPDR);
 }
 
+static u16 r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
+{
+	unsigned long flags;
+	u16 val;
+
+	spin_lock_irqsave(&tp->mac_ocp_lock, flags);
+	val = __r8168_mac_ocp_read(tp, reg);
+	spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
+
+	return val;
+}
+
 static void r8168_mac_ocp_modify(struct rtl8169_private *tp, u32 reg, u16 mask,
 				 u16 set)
 {
-	u16 data = r8168_mac_ocp_read(tp, reg);
+	unsigned long flags;
+	u16 data;
 
-	r8168_mac_ocp_write(tp, reg, (data & ~mask) | set);
+	spin_lock_irqsave(&tp->mac_ocp_lock, flags);
+	data = __r8168_mac_ocp_read(tp, reg);
+	__r8168_mac_ocp_write(tp, reg, (data & ~mask) | set);
+	spin_unlock_irqrestore(&tp->mac_ocp_lock, flags);
 }
 
 /* Work around a hw issue with RTL8168g PHY, the quirk disables
@@ -5232,6 +5259,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->eee_adv = -1;
 	tp->ocp_base = OCP_STD_PHY_BASE;
 
+	spin_lock_init(&tp->mac_ocp_lock);
+
 	dev->tstats = devm_netdev_alloc_pcpu_stats(&pdev->dev,
 						   struct pcpu_sw_netstats);
 	if (!dev->tstats)
-- 
2.43.0



