Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DD41F09B3;
	Tue, 11 Nov 2025 01:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824194; cv=none; b=De45rfyPC/eTxvl5RK8W9kPbhnSb4FOYWWslMoLOxEUufHuixDLQQ9CUurqYQAKZ5HlEhu34p1e2WDRxIWcJtWruV5FOGjpkbzHkuqAj4Fl8uFCmfwek8sEum9Q/hoYnY/lAfJgMaC8iA09i1zgdQDyOiR5kptdiSKLTVSNv2JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824194; c=relaxed/simple;
	bh=ptzH4nJEOxfwRJP5w2WQrNuHCEQjT+M6ehFesNxdDrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iXJWiGlq2ch3mWVAfQX9nYQq29yU/viWeosxAOa5CahEG/a4T/xv3hpSxZ8M6Qc6MhhVspvb2bnHcs/W/RRVZFyfyEwIqoICKlpTYX3fMEafh7T3/mHUoqvWVQVA0wKADzit1xFcf9NcR8G06uhcY7F9Rv7SCwEbPqSoEHailpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ysD3wOfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ysD3wOfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35366C4CEF5;
	Tue, 11 Nov 2025 01:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824193;
	bh=ptzH4nJEOxfwRJP5w2WQrNuHCEQjT+M6ehFesNxdDrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ysD3wOfCmKeSQl1aFwp4beijx34hv5USKLO6f/KerkmVwX2JFHipZKGAfPLAYlVOA
	 kwt5GK3jdoI7dWsB7Dk3uzbyo8n2gN9gYZhFbZwGhTirJ3E7WOCK2EAiTIenw1Hotm
	 ueIVAKJ/MbIlUKFxXc6uSu/+aFTLtYKmeAHFoPRM=
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
Subject: [PATCH 6.12 408/565] PCI/PM: Skip resuming to D0 if device is disconnected
Date: Tue, 11 Nov 2025 09:44:24 +0900
Message-ID: <20251111004536.049547943@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0dd548e2b3676..5e5326031eb72 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1403,6 +1403,11 @@ int pci_power_up(struct pci_dev *dev)
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



