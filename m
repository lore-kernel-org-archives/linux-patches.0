Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815511AA793;
	Mon, 14 Oct 2024 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918619; cv=none; b=mP07alzPwYX5iSNn1QJdlzEh0P5k9ahtD9NS1dxvW3dPefontjkIx8fx+pwbry0onZQKOfMJQgr/p402Cq50/FKkVEGTXVZfMmHuFGb8dUnwO3odk2x1jQS5WYUgD5L4j3gbPeYBAnCgkdjecayAfLdi30xX9Y7/Z+cInmmqavc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918619; c=relaxed/simple;
	bh=uayO0A0Syzfw3/GZxHIitxfexN8yxX+Xxv62P+bGEW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F64AgaorUaiZNzMoiU2oPyWXRIxZY65xHb7BnFVhyFpQchV8TDbvyDl+6Ac0R79vcaSSCZcAoK34ui9NDkjq39zF4m3ea2vg4rhW1+4cD54W2iz9sTw0NFyrNq5+8qtU0b7JrPSgSx0U9JA8FJDY6ZXW5EQCyVC6VKtOGgSg8EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9K16+se; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9K16+se"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A8AC4CEC3;
	Mon, 14 Oct 2024 15:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918619;
	bh=uayO0A0Syzfw3/GZxHIitxfexN8yxX+Xxv62P+bGEW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9K16+seN8aF4V9+pfH/AIynVOBdVxHmSD6trkoGrB2iXRItwZ+A8Jmnh/TkwqyQr
	 e8oCUiWk9VsxVpd43tOW8A8kMAZQgpbwT5xP/wD/IsDyVd2+UKti0x0SAIgfgcIe9R
	 YTn5R04WhRbIaO72WYAtuZGo26qwSzaxFuDf2RQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Blakeney <mark.blakeney@bullet-systems.net>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 6.1 374/798] PCI/PM: Mark devices disconnected if upstream PCIe link is down on resume
Date: Mon, 14 Oct 2024 16:15:28 +0200
Message-ID: <20241014141232.647034793@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit c82458101d5490230d735caecce14c9c27b1010c upstream.

Mark Blakeney reported that when suspending system with a Thunderbolt
dock connected and then unplugging the dock before resume (which is
pretty normal flow with laptops), resuming takes long time.

What happens is that the PCIe link from the root port to the PCIe switch
inside the Thunderbolt device does not train (as expected, the link is
unplugged):

  pcieport 0000:00:07.2: restoring config space at offset 0x24 (was 0x3bf12001, writing 0x3bf12001)
  pcieport 0000:00:07.0: waiting 100 ms for downstream link
  pcieport 0000:01:00.0: not ready 1023ms after resume; giving up

However, at this point we still try to resume the devices below that
unplugged link:

  pcieport 0000:01:00.0: Unable to change power state from D3cold to D0, device inaccessible
  ...
  pcieport 0000:01:00.0: restoring config space at offset 0x38 (was 0xffffffff, writing 0x0)
  ...
  pcieport 0000:02:02.0: waiting 100 ms for downstream link, after activation

And this is the link from PCIe switch downstream port to the xHCI on the
dock:

  xhci_hcd 0000:03:00.0: not ready 65535ms after resume; giving up
  xhci_hcd 0000:03:00.0: Unable to change power state from D3cold to D0, device inaccessible
  xhci_hcd 0000:03:00.0: restoring config space at offset 0x3c (was 0xffffffff, writing 0x1ff)

This ends up slowing down the resume time considerably. For this reason
mark these devices as disconnected if the link above them did not train
properly.

Fixes: e8b908146d44 ("PCI/PM: Increase wait time after resume")
Link: https://lore.kernel.org/r/20230918053041.1018876-1-mika.westerberg@linux.intel.com
Reported-by: Mark Blakeney <mark.blakeney@bullet-systems.net>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217915
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org	# v6.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-driver.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -579,7 +579,19 @@ static void pci_pm_default_resume_early(
 
 static void pci_pm_bridge_power_up_actions(struct pci_dev *pci_dev)
 {
-	pci_bridge_wait_for_secondary_bus(pci_dev, "resume");
+	int ret;
+
+	ret = pci_bridge_wait_for_secondary_bus(pci_dev, "resume");
+	if (ret) {
+		/*
+		 * The downstream link failed to come up, so mark the
+		 * devices below as disconnected to make sure we don't
+		 * attempt to resume them.
+		 */
+		pci_walk_bus(pci_dev->subordinate, pci_dev_set_disconnected,
+			     NULL);
+		return;
+	}
 
 	/*
 	 * When powering on a bridge from D3cold, the whole hierarchy may be


