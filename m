Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DDB432E74;
	Tue, 21 Jul 2026 19:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662571; cv=none; b=OyyyWkbtEhU5Abr/K8QT3YhMe+VcEpaQF8X9iHWDRMM6RW95m6KPIEs20ubjaSiYAoh9erX2clDG/y1Ivn210PmMsKomAaLG91N7T013PX0vTZgxwLT9u8Dex36XlphkD1XXuJYt6Te6xH7oV7T1tgDiMIaK0sbvxpqndPnSo+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662571; c=relaxed/simple;
	bh=tsFQisbuqrYLoZfEYyrgB2ngXwl/5PN3TpWuWYuGzDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgsUrFclUWyAbUqxmEgAOOO8Lg2ASB3/K8OW1ZcpR8dyqXfTbEg2a79zX5xAG3NWYFXDDevh8cH0jv1WSvyo7dJf6RTFjDFHKWLwxYqvAUQakiTVkTCE4cPUoDe9U7UrVZHVy8v9qjxDfXYwwASnULuSW60mnxzTGspGt++UJGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ex2QgHsU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ex2QgHsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE051F000E9;
	Tue, 21 Jul 2026 19:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662570;
	bh=eA0KKORfIp/d2pR9LnSO+3B4u6W5bhXqQwa/6UYw/Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ex2QgHsUXJs9jjw9RkWjFKyOtKb3/unygj4kIZr3PkbB6UWksl3J1AobaVGISWN0j
	 QFreGv366ThJhy+seb1BT/w/Gys9G3kottipYQYtHfzZ8YcVnzxnK1HZFkIMCaxOF+
	 HgWY/JfcGkQ67zJEhPJtaeXZsvnj8eOUeV3gArh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0494/1276] PCI: meson: Propagate devm_add_action_or_reset() failure
Date: Tue, 21 Jul 2026 17:15:37 +0200
Message-ID: <20260721152457.155312130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index db9482a113e984..8b00c7db7435bd 100644
--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -193,7 +193,9 @@ static inline struct clk *meson_pcie_probe_clock(struct device *dev,
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



