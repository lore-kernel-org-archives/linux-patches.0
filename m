Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEF04E0B63;
	Thu, 17 Sep 2026 17:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667554; cv=none; b=Ar4ZDFqLEJsb+hJNFU+znY3OyZEuiOTW/gyVvkTJyRLjjOPzrnhBCuZmNuIk69PJ/8lOpkfheK+L7KNwY3ZfQgDQnHMv0l8VzD7yukaTdSvXdIwiIYk321/L5v9Ff5aLGEvJVpPJOREnkJtZNV3OKwhAxdgrEjpTT2KCM8oyySE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667554; c=relaxed/simple;
	bh=K75a8ihTlKQnXBLgObctGB47ZCWZEpD8IoKCjr0bebA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSrTllSrRhRNXbrGt+h8gM80VZ4gBw8YfF8nLgxYmPo3W+ije5yD8Q+4h0LlqEDGPyoPYJBLUkTIi5zRT8dcXB0lIk0WZLmATVr7j3EAAT2dV/H9IXvJ0WER5AoAhgBQB295AL9+gvQwmMZX6PHPnWvE81PMhX49h3LMT2JIP78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWTe122q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWTe122q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B6D1F000FF;
	Thu, 17 Sep 2026 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667553;
	bh=2s9S5wXXaEpCbcfP+o0vLfzy9/qCYmXBlmnthT0jxZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWTe122qpRsFlAbp9gEGnZPLZN5zeay0pb7PntSD0rUoeX94Wc9bmnZjyK7cOifH/
	 ZEJJePki3Dzyr9CQLJpz0Q8Izu2w6QnrZVphHtub7mrScGAnpOrnsL8X/3rUqqVoYP
	 Q3cC94VTqPZBH9P0/gXyiBh7XPl2XPhbfeqpmCQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0093/1102] PCI: Wait for device readiness after D3hot -> D0uninitialized transition
Date: Thu, 17 Sep 2026 16:00:36 +0100
Message-ID: <20260917151541.825541086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 451ee220f9541..326540ed02c45 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1390,7 +1390,18 @@ int pci_power_up(struct pci_dev *dev)
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
@@ -1431,10 +1442,19 @@ int pci_power_up(struct pci_dev *dev)
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



