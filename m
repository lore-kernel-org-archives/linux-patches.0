Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378923E49C4;
	Tue, 21 Jul 2026 19:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660421; cv=none; b=Wn5uN7WItBA0F6Y8tpfv8oyy7lsYgkxDTJkEC9UqRqVKMo5yNXseKLCy+lpp3HQXKjjcO001hEy1g2SJ+YrsF/RzsohjS7jUPvaOtMPOBst+A2LG50KUl8lR0Y+ZNkHXUYgU9uxg8Pdfm5Waee8uRTVao9LxQ3yhcEy3t8jx5HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660421; c=relaxed/simple;
	bh=UP/nDyhzWTf5skWmM3NOztHqRB4TYMxrBq7TxBZMIhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQ7SFYwYFIIpsb0/1Gbk03k4f03nLGVLiSmxgJfayUaxLWAf/7FCgT6dlKWU+ay3c7M5j3S32zLhxq/BoQ6eMB5bczfZmZl8TXSxkER8/q57DXnW0AUOYWeeGDlwlu/5HiCCO04efoKYLB5SnKgLpwG6YdA3ODpAF5n82Nf1TwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7GWXRCu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7GWXRCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C361F000E9;
	Tue, 21 Jul 2026 19:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660420;
	bh=4xM7JNDBcPqufNGDsr+41B0Ssfd0AKFXUkd7jmxhqC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7GWXRCuSP0RF3JXBSq+FmQ7xbjOV91gG67Tq1xQW+5MgyNH5gbRNCnF5jSY2GlQa
	 MGUSgJ04NcTs1jmrd7J/vAuNvVZASS7kjhtQfksc6nuK2zLvjyD3TMzRbQccPKxVTI
	 J/GEfs3XKSEa2fhAw4rRr1XmJtzBu+a2wV0HMpMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0974/2077] PCI: meson: Propagate devm_add_action_or_reset() failure
Date: Tue, 21 Jul 2026 17:10:47 +0200
Message-ID: <20260721152615.791795659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit b12341b98d5ac52f48ca1390e1e371aed81346c8 ]

meson_pcie_probe_clock() enables a clock and then registers a devres
action to disable it during teardown. If devm_add_action_or_reset()
fails, it runs the action immediately, disabling the clock.

The return value is currently ignored, so on that failure path,
meson_pcie_probe_clock() returns the disabled clock and probe continues.
Return the error so the existing probe error path unwinds normally.

Fixes: 9c0ef6d34fdbf ("PCI: amlogic: Add the Amlogic Meson PCIe controller driver")
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/177909148011.9588.6639767953842842291@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-meson.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-meson.c b/drivers/pci/controller/dwc/pci-meson.c
index 0694084f612b79..8d495bcc3a41ae 100644
--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -204,7 +204,9 @@ static inline struct clk *meson_pcie_probe_clock(struct device *dev,
 		return ERR_PTR(ret);
 	}
 
-	devm_add_action_or_reset(dev, meson_pcie_disable_clock, clk);
+	ret = devm_add_action_or_reset(dev, meson_pcie_disable_clock, clk);
+	if (ret)
+		return ERR_PTR(ret);
 
 	return clk;
 }
-- 
2.53.0



