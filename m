Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD87746D088;
	Tue, 21 Jul 2026 18:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659537; cv=none; b=r8hqCEInbXbm+JHVjNKkpE9Ni49WbaQcsIe9uJsNzNv+qFVWNCQPCe8JNWhFxy5zpb70kJ09nq35Dl18taJo8CtznduXMtJOfa1CUp1Y/lg2UF1JC5C3mwUO9aAM7rvrmDe0A9Q2p4Xfkl6JaDh2guGVuGMhQvqsBXwXPIE9qgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659537; c=relaxed/simple;
	bh=WEIKI+CVuxpl8pEdKT2c6tK1ZBmuFN7nlGWtX/n6lzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=npm3fZHYBwy4dwzicP/nmUHpj3Z2WxU9C7arKkp0h95Lkuz0Nk4Eo8t176bUgvaMCPVuNaGh2yj5u0ZrJ3HAWcbuvDvjPj3sONhjE54kMdvch7nCDDJanD+J41GZ6Z4DPlYBvB324iN1paMBj1Dy2mZ7jKkTAvwbL8X6rclXXZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbObD8NU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbObD8NU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0AA1F000E9;
	Tue, 21 Jul 2026 18:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659536;
	bh=uNJuqi3zZ6JUo57sgNgj3AgbAhy3clZyTaGyD3q9Yf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbObD8NUAycmQ/5Olg8BkpnUs0eIoVmE3X3FbFBmpZzCsA7RK8x32r0p5o2PaR4m8
	 5Y63nIftFrlql75MjH4kUQRE0LV68tGQYZ8wBcJ1NzeXz/c/e5tlxYsb0nMooCJdKo
	 r15+kAePQw8BZu+qomnO1OIun8FX6SF7imXeuMTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH 6.18 1531/1611] PCI/IOV: Adjust ->barsz[] when changing BAR size
Date: Tue, 21 Jul 2026 17:27:27 +0200
Message-ID: <20260721152549.882854358@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 4687b3315a3f76647746f5b7f92684cf1045b085 ]

pci_rebar_set_size() adjusts BAR size for both normal and IOV BARs. The
struct pci_sriov keeps a cached copy of BAR size in ->barsz[] which is not
adjusted by pci_rebar_set_size() but by pci_iov_resource_set_size().
pci_iov_resource_set_size() is called also from
pci_resize_resource_set_size().

The current arrangement is problematic once BAR resize algorithm starts to
roll back changes properly in case of a failure. The normal resource
fitting algorithm rolls back resource size using the struct
pci_dev_resource easily but also calling pci_resize_resource_set_size() or
pci_iov_resource_set_size() to roll back BAR size would be an extra burden,
whereas combining ->barsz[] update with pci_rebar_set_size() naturally
rolls back it when restoring the old BAR size on a different layer of the
BAR resize operation.

Thus, rework pci_rebar_set_size() to also update ->barsz[].

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Alex Bennée <alex.bennee@linaro.org> # AVA, AMD GPU
Link: https://patch.msgid.link/20251113162628.5946-3-ilpo.jarvinen@linux.intel.com
Stable-dep-of: ee7471fe968d ("PCI: Skip Resizable BAR restore on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/iov.c       |   15 ++++-----------
 drivers/pci/pci.c       |    4 ++++
 drivers/pci/pci.h       |    5 ++---
 drivers/pci/setup-res.c |   10 ++++------
 4 files changed, 14 insertions(+), 20 deletions(-)

--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -158,8 +158,7 @@ resource_size_t pci_iov_resource_size(st
 	return dev->sriov->barsz[pci_resource_num_to_vf_bar(resno)];
 }
 
-void pci_iov_resource_set_size(struct pci_dev *dev, int resno,
-			       resource_size_t size)
+void pci_iov_resource_set_size(struct pci_dev *dev, int resno, int size)
 {
 	if (!pci_resource_is_iov(resno)) {
 		pci_warn(dev, "%s is not an IOV resource\n",
@@ -167,7 +166,8 @@ void pci_iov_resource_set_size(struct pc
 		return;
 	}
 
-	dev->sriov->barsz[pci_resource_num_to_vf_bar(resno)] = size;
+	resno = pci_resource_num_to_vf_bar(resno);
+	dev->sriov->barsz[resno] = pci_rebar_size_to_bytes(size);
 }
 
 bool pci_iov_is_memory_decoding_enabled(struct pci_dev *dev)
@@ -1345,7 +1345,6 @@ EXPORT_SYMBOL_GPL(pci_sriov_configure_si
 int pci_iov_vf_bar_set_size(struct pci_dev *dev, int resno, int size)
 {
 	u32 sizes;
-	int ret;
 
 	if (!pci_resource_is_iov(resno))
 		return -EINVAL;
@@ -1360,13 +1359,7 @@ int pci_iov_vf_bar_set_size(struct pci_d
 	if (!(sizes & BIT(size)))
 		return -EINVAL;
 
-	ret = pci_rebar_set_size(dev, resno, size);
-	if (ret)
-		return ret;
-
-	pci_iov_resource_set_size(dev, resno, pci_rebar_size_to_bytes(size));
-
-	return 0;
+	return pci_rebar_set_size(dev, resno, size);
 }
 EXPORT_SYMBOL_GPL(pci_iov_vf_bar_set_size);
 
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3797,6 +3797,10 @@ int pci_rebar_set_size(struct pci_dev *p
 	ctrl &= ~PCI_REBAR_CTRL_BAR_SIZE;
 	ctrl |= FIELD_PREP(PCI_REBAR_CTRL_BAR_SIZE, size);
 	pci_write_config_dword(pdev, pos + PCI_REBAR_CTRL, ctrl);
+
+	if (pci_resource_is_iov(bar))
+		pci_iov_resource_set_size(pdev, bar, size);
+
 	return 0;
 }
 
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -826,8 +826,7 @@ void pci_iov_update_resource(struct pci_
 resource_size_t pci_sriov_resource_alignment(struct pci_dev *dev, int resno);
 void pci_restore_iov_state(struct pci_dev *dev);
 int pci_iov_bus_range(struct pci_bus *bus);
-void pci_iov_resource_set_size(struct pci_dev *dev, int resno,
-			       resource_size_t size);
+void pci_iov_resource_set_size(struct pci_dev *dev, int resno, int size);
 bool pci_iov_is_memory_decoding_enabled(struct pci_dev *dev);
 static inline u16 pci_iov_vf_rebar_cap(struct pci_dev *dev)
 {
@@ -869,7 +868,7 @@ static inline int pci_iov_bus_range(stru
 	return 0;
 }
 static inline void pci_iov_resource_set_size(struct pci_dev *dev, int resno,
-					     resource_size_t size) { }
+					     int size) { }
 static inline bool pci_iov_is_memory_decoding_enabled(struct pci_dev *dev)
 {
 	return false;
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -452,12 +452,10 @@ static void pci_resize_resource_set_size
 	resource_size_t res_size = pci_rebar_size_to_bytes(size);
 	struct resource *res = pci_resource_n(dev, resno);
 
-	if (!pci_resource_is_iov(resno)) {
-		resource_set_size(res, res_size);
-	} else {
-		resource_set_size(res, res_size * pci_sriov_get_totalvfs(dev));
-		pci_iov_resource_set_size(dev, resno, res_size);
-	}
+	if (pci_resource_is_iov(resno))
+		res_size *= pci_sriov_get_totalvfs(dev);
+
+	resource_set_size(res, res_size);
 }
 
 int pci_resize_resource(struct pci_dev *dev, int resno, int size)


