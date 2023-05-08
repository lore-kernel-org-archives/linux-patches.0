Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1928B168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9CCC433EF;
	Mon,  8 May 2023 10:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540628;
	bh=Ec3INi9tzN8PK5EEiLrwzWnnI++tHTy0UMphsl0DaMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjTfyrcSKhgIhMEFgNkC3OJzIBXQeuftMMlM5tV9SsI9ZXapm8+qR/rD3NMtiCjNl
	 a1XsUsrZz5pFVV3yNEKVseDnMIdt37f1HqcvFVEmAKuLKYcfOaDFgIu4NVWPqxeot1
	 yO3X6WUEOztI2ONw1iYp1zCGt2JiZVSQ432N/ZxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiyi Guo <zhguo@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tarun Gupta <targupta@nvidia.com>,
	Abhishek Sahu <abhsahu@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 437/611] PCI/PM: Extend D3hot delay for NVIDIA HDA controllers
Date: Mon,  8 May 2023 11:44:39 +0200
Message-Id: <20230508094436.372439254@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit a5a6dd2624698b6e3045c3a1450874d8c790d5d9 ]

Assignment of NVIDIA Ampere-based GPUs have seen a regression since the
below referenced commit, where the reduced D3hot transition delay appears
to introduce a small window where a D3hot->D0 transition followed by a bus
reset can wedge the device.  The entire device is subsequently unavailable,
returning -1 on config space read and is unrecoverable without a host
reset.

This has been observed with RTX A2000 and A5000 GPU and audio functions
assigned to a Windows VM, where shutdown of the VM places the devices in
D3hot prior to vfio-pci performing a bus reset when userspace releases the
devices.  The issue has roughly a 2-3% chance of occurring per shutdown.

Restoring the HDA controller d3hot_delay to the effective value before the
below commit has been shown to resolve the issue.  NVIDIA confirms this
change should be safe for all of their HDA controllers.

Fixes: 3e347969a577 ("PCI/PM: Reduce D3hot delay with usleep_range()")
Link: https://lore.kernel.org/r/20230413194042.605768-1-alex.williamson@redhat.com
Reported-by: Zhiyi Guo <zhguo@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Tarun Gupta <targupta@nvidia.com>
Cc: Abhishek Sahu <abhsahu@nvidia.com>
Cc: Tarun Gupta <targupta@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 494fa46f57671..8d32a3834688f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1939,6 +1939,19 @@ static void quirk_radeon_pm(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6741, quirk_radeon_pm);
 
+/*
+ * NVIDIA Ampere-based HDA controllers can wedge the whole device if a bus
+ * reset is performed too soon after transition to D0, extend d3hot_delay
+ * to previous effective default for all NVIDIA HDA controllers.
+ */
+static void quirk_nvidia_hda_pm(struct pci_dev *dev)
+{
+	quirk_d3hot_delay(dev, 20);
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+			      PCI_CLASS_MULTIMEDIA_HD_AUDIO, 8,
+			      quirk_nvidia_hda_pm);
+
 /*
  * Ryzen5/7 XHCI controllers fail upon resume from runtime suspend or s2idle.
  * https://bugzilla.kernel.org/show_bug.cgi?id=205587
-- 
2.39.2



