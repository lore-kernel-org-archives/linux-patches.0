Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B17B2AF07;
	Mon, 28 Oct 2024 06:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098346; cv=none; b=WEz3p3ujpQyG4MwD3zL0dUtJKFKYgyjrPpvfBRuUZu3D6MkaNG9yfFyvMj71h9mgPfQu6CEyOn97KLMR3LbpkJSy+lLyxLwle13LFaEcADs6pGii+r4eDWfpG7QKcmU9cDGEzbiI3ocjSjmtGBlrA1BJPd9j3ky0+7TkMOD/VV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098346; c=relaxed/simple;
	bh=f2TG4ivWerYv6kBndIV6XhLX00vW56oLW9X9YvInfkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr4WaClxSQnRnZOGXWCLO+ore052pJY/+q6OXWfk2Xccf7PKzTwotlBI5F6pTynWLBc/AjNUcdxXxQl+4O5cj5CMaYwSHE+sPVhwrnXdCaKVMz8fGDr+CkilFKoxP4dR6pOa2rnKHazuH6QEBkYoU3iyxQSq9X2kS7oTMflkdcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gppAdYAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gppAdYAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C87C4CEC3;
	Mon, 28 Oct 2024 06:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098345;
	bh=f2TG4ivWerYv6kBndIV6XhLX00vW56oLW9X9YvInfkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gppAdYAtbsKdrLeZtWPE/PTJR2XEdoZvGf3tAKNk+SR+WSMhJV39hICS/lCxZF4C/
	 9y59gMEoEPTw/6Dvm3xeqGk6XjMmPGQ+CAZqsoB5h9+lAPQRv/aWJ36hFcx6DmKdR4
	 RnA0OFW4/KltL4hNoDiKdKWuIYOsRuIznu0ktCOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 187/261] PCI: Hold rescan lock while adding devices during host probe
Date: Mon, 28 Oct 2024 07:25:29 +0100
Message-ID: <20241028062316.704411200@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 1d59d474e1cb7d4fdf87dfaf96f44647f13ea590 ]

Since adding the PCI power control code, we may end up with a race between
the pwrctl platform device rescanning the bus and host controller probe
functions. The latter need to take the rescan lock when adding devices or
we may end up in an undefined state having two incompletely added devices
and hit the following crash when trying to remove the device over sysfs:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  Internal error: Oops: 0000000096000004 [#1] SMP
  Call trace:
    __pi_strlen+0x14/0x150
    kernfs_find_ns+0x80/0x13c
    kernfs_remove_by_name_ns+0x54/0xf0
    sysfs_remove_bin_file+0x24/0x34
    pci_remove_resource_files+0x3c/0x84
    pci_remove_sysfs_dev_files+0x28/0x38
    pci_stop_bus_device+0x8c/0xd8
    pci_stop_bus_device+0x40/0xd8
    pci_stop_and_remove_bus_device_locked+0x28/0x48
    remove_store+0x70/0xb0
    dev_attr_store+0x20/0x38
    sysfs_kf_write+0x58/0x78
    kernfs_fop_write_iter+0xe8/0x184
    vfs_write+0x2dc/0x308
    ksys_write+0x7c/0xec

Fixes: 4565d2652a37 ("PCI/pwrctl: Add PCI power control core code")
Link: https://lore.kernel.org/r/20241003084342.27501-1-brgl@bgdev.pl
Reported-by: Konrad Dybcio <konradybcio@kernel.org>
Tested-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e9e56bbb3b59d..d203e23b75620 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -3106,7 +3106,9 @@ int pci_host_probe(struct pci_host_bridge *bridge)
 	list_for_each_entry(child, &bus->children, node)
 		pcie_bus_configure_settings(child);
 
+	pci_lock_rescan_remove();
 	pci_bus_add_devices(bus);
+	pci_unlock_rescan_remove();
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pci_host_probe);
-- 
2.43.0



