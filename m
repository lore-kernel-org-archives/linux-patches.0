Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BFD4E430E;
	Wed, 30 Sep 2026 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784147; cv=none; b=t/Z7mTiGQjFZ+ouDIY/G9DLhCTPbsksmskvlcg6/UjRMrsb9mhcFW+4pNtQqix6rsyXWGsDt5i4Eq7NYSb3rCo3KrgrSOXLeUHT9PvdtdAaCXUNVR1dzQLulEC4vK/ljNNG+SfmaLU/O8zz9VQ0Ts0jp6twvChCEV4H+wK30Cig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784147; c=relaxed/simple;
	bh=kYPyWe+9Cg6YyyEBoR6pMcW223lRyQTb7xyNkHNqHaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIcklu1jplTJ6kyQUi7faCuLHs7OaAvnVXGSYhuwmBoenk1ztGF7Jo7hCSFE+5FJPQMoCPAu8FtkmHUa57JcjuTpFXV1TOlGKhC20Yb1vlnEPRIQu0J35oXNiE82UPHJgc+hPvSmwjzFHJTpuNn9SD61L0RqHGT39wkr5t2ZVJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dqq5FAcv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dqq5FAcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B551F000FF;
	Wed, 30 Sep 2026 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784142;
	bh=DVAwBBarBGCG5mk6BOiXcOyxX+UoJqE2Rg/XnxJTvYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dqq5FAcvbkGYr5hKCC94kNCVh907LrastwScdCaCmFOhRQF4cpRjvMJLtorhfjyt5
	 mN/asjpARmGglpyojxUxyDUpWTbPWs/2LfGIfXRTZJB6qtJteGpAPF0B04eleo7OqP
	 yEJrDW5l84FKrEIYn2q7Bl4J4RPVvkVAY0D9xjcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/982] PCI: Wait for device readiness after D3hot -> D0uninitialized transition
Date: Wed, 30 Sep 2026 17:13:06 +0200
Message-ID: <20260930152417.867939066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Bjorn Helgaas <helgaas@kernel.org>

[ Upstream commit 41167a1e98536b4baf0846fd259c8124bd1c4e1b ]

For a device that advertises No_Soft_Reset == 0, a transition from D3hot to
D0uninitialized is a soft reset, and the resulting internal device state is
undefined.

Per PCIe r7.0, sec 2.3.1, a transition from D3hot to D0uninitialized
mandates a minimum 10 ms delay before accessing the device. Following this
delay, the device is permitted to respond to initial configuration requests
with a Request Retry Status (RRS) completion status if it needs more time
to initialize.

Call pci_dev_wait() after pci_power_up() performs a D3hot->D0uninitialized
transition to ensure the device is ready to accept config accesses, as is
done after the similar transition in pci_pm_reset().

If the device is already ready, this is essentially a no-op except for one
additional config read.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Link: https://patch.msgid.link/20260518191220.636213-3-bhelgaas@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c87a5e9f75684..b0d4c3bc205bf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1274,7 +1274,18 @@ int pci_power_up(struct pci_dev *dev)
 	bool need_restore;
 	pci_power_t state;
 	u16 pmcsr;
+	int ret;
 
+	/*
+	 * When setting power state to D0, platform_pci_set_power_state()
+	 * ensures main power is on.  If it puts the device in D0, it also
+	 * completes any required delays after the transition; if it leaves
+	 * the device in D1, D2, or D3hot, we use the PM Capability to
+	 * transition to D0.
+	 *
+	 * In all cases, the device is either Configuration-Ready or
+	 * inaccessible upon return.
+	 */
 	platform_pci_set_power_state(dev, PCI_D0);
 
 	if (!dev->pm_cap) {
@@ -1315,10 +1326,19 @@ int pci_power_up(struct pci_dev *dev)
 	pci_write_config_word(dev, dev->pm_cap + PCI_PM_CTRL, 0);
 
 	/* Mandatory transition delays; see PCI PM 1.2. */
-	if (state == PCI_D3hot)
+	if (state == PCI_D3hot) {
 		pci_dev_d3_sleep(dev);
-	else if (state == PCI_D2)
+		if (!(pmcsr & PCI_PM_CTRL_NO_SOFT_RESET)) {
+			ret = pci_dev_wait(dev, "power up D3hot->D0uninitialized",
+					   PCIE_RESET_READY_POLL_MS);
+			if (ret) {
+				dev->current_state = PCI_D3cold;
+				return -EIO;
+			}
+		}
+	} else if (state == PCI_D2) {
 		udelay(PCI_PM_D2_DELAY);
+	}
 
 end:
 	dev->current_state = PCI_D0;
-- 
2.53.0



