Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C1F471257;
	Tue, 21 Jul 2026 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657208; cv=none; b=f0JDSe7LRJNlpEWk64UZK7NJ+ZZsLn6vDJ56+hfjr+qbLHjfKjXuCTClRxIT69KB4wTbgKCpV1HPKcdMvFlfRH+lXHutz5akwFsv8ykrmt4vbx5fz4EiICplYOx9G2YHqflJbtBzuczJxSzacMvkY9aM0EeETd1/I6kGhtmaP48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657208; c=relaxed/simple;
	bh=sTfC3qxCKSEIzBqwvGD2/WFUWJs8XvEzGaTtY/8SyCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWQi4VA5+dGn1kGEgh2z+45KOBGZP6pE0ahC8NB/VbNEKpPTHELPiHLxXXMKhqxRbrZEzbTO4VMS20fXlVcwKl0FHzEoC4iO+xWnlGgDF/aXixqe3N1Jw5mQMpdv5eMi9JQG/p0rIdh4EGrh7ppoBS8qlC8HkU3aHn2WyIyZ+/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsdveiQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsdveiQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD9F1F000E9;
	Tue, 21 Jul 2026 18:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657207;
	bh=QvHXXfy+jN9dxbxfB392GWc5giJIxndjUq9aOCmEw5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsdveiQ24Ac9PKTeOdkQxsZVodstmadFOrlFgGBp1+thm4++5zZHh0GVCJs7gzZBX
	 N4hel286T9/pdc3dmXUF5aCasdpmvwhKBKFfpOGc34+yZONsHbI3LLfgE3bAqf+5M3
	 QeRmmFePcxMO8QoGX0Ij5olWv145VkZMwoo0zFM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0678/1611] PCI: meson: Add missing remove callback
Date: Tue, 21 Jul 2026 17:13:14 +0200
Message-ID: <20260721152530.632430594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

[ Upstream commit 4b0dc84b293984f75598881809fb2d3daf54a2a8 ]

meson_pcie_probe() powers on the PHY and registers the DesignWare host
bridge with dw_pcie_host_init(), but the driver has no remove callback.
On driver unbind or module unload, the driver core therefore proceeds to
devres cleanup without first unregistering the host bridge or powering off
the PHY.

Add a remove callback that deinitializes the DesignWare host bridge and
powers off the PHY while device-managed resources are still valid.

Fixes: 9c0ef6d34fdb ("PCI: amlogic: Add the Amlogic Meson PCIe controller driver")
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/1a0c86ab264cdc1c79c917e984b90991af51d827.1779123847.git.shuvampandey1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-meson.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-meson.c b/drivers/pci/controller/dwc/pci-meson.c
index 8d495bcc3a41ae..225d887cd0a3e1 100644
--- a/drivers/pci/controller/dwc/pci-meson.c
+++ b/drivers/pci/controller/dwc/pci-meson.c
@@ -453,6 +453,14 @@ static int meson_pcie_probe(struct platform_device *pdev)
 	return ret;
 }
 
+static void meson_pcie_remove(struct platform_device *pdev)
+{
+	struct meson_pcie *mp = platform_get_drvdata(pdev);
+
+	dw_pcie_host_deinit(&mp->pci.pp);
+	meson_pcie_power_off(mp);
+}
+
 static const struct of_device_id meson_pcie_of_match[] = {
 	{
 		.compatible = "amlogic,axg-pcie",
@@ -466,6 +474,7 @@ MODULE_DEVICE_TABLE(of, meson_pcie_of_match);
 
 static struct platform_driver meson_pcie_driver = {
 	.probe = meson_pcie_probe,
+	.remove = meson_pcie_remove,
 	.driver = {
 		.name = "meson-pcie",
 		.of_match_table = meson_pcie_of_match,
-- 
2.53.0



