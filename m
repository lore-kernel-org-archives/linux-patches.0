Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679F4349AF4;
	Fri, 21 Nov 2025 13:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732851; cv=none; b=b7OqylgAZNVTZSYRjewNskYWrI05L9qu4c8U1FjdgVCQdg/luW1GnrDq20Xo64gItSuIoARl1Q/cxRQItOzENSIT7SKeWTVXzZ2PlBznbYo/Wkb0krQqR/nWWlae0zDsrInX0VjIIEvnkdxq4Bm0RM4MZQaoglpUzPS2mgYo0+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732851; c=relaxed/simple;
	bh=TLkjKHlbP0wmd2avhhxWR92YVoONjItbYlQXW1P1qMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nR/2Lzuh4j+/IYy7DMc/xcrtq0uc74CMXcIg2r8R+1fDmhvVK4R1XEnN/Vp1wBkmN21Q/sqRBpEdCJePAhWOruiJr6pdzcsX+Elq66CkR32zTo3PayH39Z5gEAvfEkbE/6qyeNscfQClpmmRhIuNQrR5n8Ox/tqA1dTV6shmMnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjeaHTH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjeaHTH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70FFC4CEF1;
	Fri, 21 Nov 2025 13:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732851;
	bh=TLkjKHlbP0wmd2avhhxWR92YVoONjItbYlQXW1P1qMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjeaHTH4Tu5jLw3MABXPe08BTS6pbYXtQgqg38oN7gtcAu6rLI96xcCXBpcqTQQZV
	 t9VQmlHRLE9fRP2ScKndKSWXTbNJOBQplYW8vKum6t4T2frg7SktBjNjLeAcXwM8al
	 z/ALLBei9NNXJ5Asi5C22rLwjIFHkFbb+29/HFzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/529] PCI/PM: Skip resuming to D0 if device is disconnected
Date: Fri, 21 Nov 2025 14:09:24 +0100
Message-ID: <20251121130240.453117965@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 299fad4133677b845ce962f78c9cf75bded63f61 ]

When a device is surprise-removed (e.g., due to a dock unplug), the PCI
core unconfigures all downstream devices and sets their error state to
pci_channel_io_perm_failure. This marks them as disconnected via
pci_dev_is_disconnected().

During device removal, the runtime PM framework may attempt to resume the
device to D0 via pm_runtime_get_sync(), which calls into pci_power_up().
Since the device is already disconnected, this resume attempt is
unnecessary and results in a predictable errors like this, typically when
undocking from a TBT3 or USB4 dock with PCIe tunneling:

  pci 0000:01:00.0: Unable to change power state from D3cold to D0, device inaccessible

Avoid powering up disconnected devices by checking their status early in
pci_power_up() and returning -EIO.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
[bhelgaas: add typical message]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Link: https://patch.msgid.link/20250909031916.4143121-1-superm1@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index df7f7e2ed0064..9a3f6bb60eb4d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1257,6 +1257,11 @@ int pci_power_up(struct pci_dev *dev)
 		return -EIO;
 	}
 
+	if (pci_dev_is_disconnected(dev)) {
+		dev->current_state = PCI_D3cold;
+		return -EIO;
+	}
+
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 	if (PCI_POSSIBLE_ERROR(pmcsr)) {
 		pci_err(dev, "Unable to change power state from %s to D0, device inaccessible\n",
-- 
2.51.0



