Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A6D21ADAE;
	Tue,  8 Apr 2025 11:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110021; cv=none; b=m+RZhTAoxfarS7/k5cy3IVQwSGnnOQcxeNtWFpDyPi2Ms8FrGspEhM5Gvp5p+GKb9p53ORCwCpcXS+lt+p9x5z5GtXfUwVcUotewnmRCOq5i9+mSOYW1JTHqVoRvsUYfc5wkW0R6xXpXTP13yA9jCFrBCy/3slq4ucFBLLhQT3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110021; c=relaxed/simple;
	bh=OtlRD8F2KQJEoz4ydFPCFbGMqunMHAtpTIy+IOO8XuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4gFWvI0x3qCFwp/FtWtqJxNLnL7zY4M0o3A8FM5+dnBjhUHoLXtvrrlBq8Q1hpNpNAslHw5005l/vxsQekA1rT75qHBFV440A/Nar6RCaRyQbHMxdkC4bJwpOSyEnqyqKx+nGkxGvgj+bpw/ZEaTTVwwbOtzgJhYDlE4zaQ73s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb8LVwPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb8LVwPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACDEC4CEE5;
	Tue,  8 Apr 2025 11:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110020;
	bh=OtlRD8F2KQJEoz4ydFPCFbGMqunMHAtpTIy+IOO8XuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xb8LVwPnje3ZfGXdSnvjBqXGgfTy4ZUgY9n6kE0mFpxgwQlNaVebrnqRux761YUnc
	 923NQHHJiEwMylkBL0N9NNIvRDVZhfXJmvNNuw2pPaJd5JIGxFDmea7wjo0Qh6URJA
	 xFraP2kDprWWIkcQwT3f2tdJww50SW3YIADBW9Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Lukas Wunner <lukas@wunner.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 140/227] PCI: pciehp: Dont enable HPIE when resuming in poll mode
Date: Tue,  8 Apr 2025 12:48:38 +0200
Message-ID: <20250408104824.507826790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 527664f738afb6f2c58022cd35e63801e5dc7aec ]

PCIe hotplug can operate in poll mode without interrupt handlers using a
polling kthread only.  eb34da60edee ("PCI: pciehp: Disable hotplug
interrupt during suspend") failed to consider that and enables HPIE
(Hot-Plug Interrupt Enable) unconditionally when resuming the Port.

Only set HPIE if non-poll mode is in use. This makes
pcie_enable_interrupt() match how pcie_enable_notification() already
handles HPIE.

Link: https://lore.kernel.org/r/20250321162114.3939-1-ilpo.jarvinen@linux.intel.com
Fixes: eb34da60edee ("PCI: pciehp: Disable hotplug interrupt during suspend")
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 75c6c72ec32ac..d1e524078793c 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -840,7 +840,9 @@ void pcie_enable_interrupt(struct controller *ctrl)
 {
 	u16 mask;
 
-	mask = PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_DLLSCE;
+	mask = PCI_EXP_SLTCTL_DLLSCE;
+	if (!pciehp_poll_mode)
+		mask |= PCI_EXP_SLTCTL_HPIE;
 	pcie_write_cmd(ctrl, mask, mask);
 }
 
-- 
2.39.5



