Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025349;
	b=GFrpBS9E+HTCXsUuSXbQzllZ5uFOrQxJAI6COdK3NvzLQL9DviaVYMnPp+hWky1YHVuk
	 27yq8hWAQpI19W2tB4L2iUSHUvZhSmM1V6RPPEQIwvF1BHa8SVV8TVaN0StidqhLhYOyU
	 IjN7YCW72w2iYLyiLvJZI8A/1Z/mJyB2dg6MsjxiDx+ktlzknRFWmxNdFU1vVH2WiMX/i
	 PhYfQ2SRFJkqaDWYO/SqOnDbdZCl/szA5rzfyzIfUkInJtDYOUvpfRjt3pGN4Z3OuRwKX
	 saI7cacp3ZbVhcmrqacKsDWoMi0/mK/zwag60NVf7MnLFNrJllIH6P6dR+ShlUy02Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bndL4HAYoKGiwpQ8+HtTtBYT6LB7Y2pkwG7prDvWLM0=;
	b=P8ZjjQtyQuA9OMJeDHcHUM81xcesV+JacHkIgJFEELwx1hp3CZX4Bb0FMGV7098LQYBK
	 JPPk6R8NuulWgXIBNC8RduZDEtONXrdO1tka65WAatS9rgvBPu+p6AfxzGdBxDkVyKGue
	 BoHscUh5VRSNwxbumwVwIQa9kczg6awR4Nl4lBsWykg4Yj9yXkPi/tNXncuWJi+K2fpod
	 y/XR6RmUoV5mdK8kaoHSs3aCLcRzO2smixuShvOvfEt2Nn7pdEwcb96UxT5PMDF6+PLwc
	 xuLiQ6USmaRUc8mIol09OJNAq1qY9oKCTPh9wqPyChK8VWdNhC4wfeukRUFLhCluTlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kiNp3JFR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085B3606A33E;
	Wed, 18 Nov 2026 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kiNp3JFR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645B41F000C9;
	Wed, 18 Nov 2026 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025348;
	bh=bndL4HAYoKGiwpQ8+HtTtBYT6LB7Y2pkwG7prDvWLM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kiNp3JFR2PyFYhixqXRWyS75k+68WmSKNC2qddBlm5CoegBjHrId5GzlaJkN9lglq
	 RRKWNd6W47HlwczbiTvUM2Qia964iniTQtfcjhIZXUtd/adS9QK+3QxPcmznln0BLl
	 zQpEFlyxPclEX6O4AJu4NpRIYPilcqE7sAv1izsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <Markus.Elfring@web.de>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1047/2151] perf/dwc_pcie: Fix PCI device reference leak in probe
Date: Wed, 18 Nov 2026 15:46:22 +0100
Message-ID: <20261118150200.467562677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 3a4067658363e34bf4e1d7039e5b52951fcb4012 ]

pci_get_domain_bus_and_slot() returns a referenced PCI device. When the
subsequent RAS DES capability lookup fails, dwc_pcie_pmu_probe() returns
-ENODEV without releasing that reference. Repeated failed probes can
therefore keep the PCI device allocated after removal.

Declare the looked-up device with __free(pci_dev_put), so the temporary
reference is released on every return path. Keeping the reference scoped
to the whole probe also covers all later uses of the device during
initialization.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 7f35b429802a ("perf/dwc_pcie: fix duplicate pci_dev devices")
Suggested-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/dwc_pcie_pmu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/dwc_pcie_pmu.c b/drivers/perf/dwc_pcie_pmu.c
index 22f73ac894e95..904e6cd01bf88 100644
--- a/drivers/perf/dwc_pcie_pmu.c
+++ b/drivers/perf/dwc_pcie_pmu.c
@@ -694,16 +694,16 @@ static struct notifier_block dwc_pcie_pmu_nb = {
 
 static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 {
-	struct pci_dev *pdev;
+	u32 sbdf = plat_dev->id;
+	struct pci_dev *pdev __free(pci_dev_put) =
+		pci_get_domain_bus_and_slot(sbdf >> 16,
+					    PCI_BUS_NUM(sbdf & 0xffff),
+					    sbdf & 0xff);
 	struct dwc_pcie_pmu *pcie_pmu;
 	char *name;
-	u32 sbdf;
 	u16 vsec;
 	int ret;
 
-	sbdf = plat_dev->id;
-	pdev = pci_get_domain_bus_and_slot(sbdf >> 16, PCI_BUS_NUM(sbdf & 0xffff),
-					   sbdf & 0xff);
 	if (!pdev) {
 		pr_err("No pdev found for the sbdf 0x%x\n", sbdf);
 		return -ENODEV;
@@ -713,7 +713,6 @@ static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 	if (!vsec)
 		return -ENODEV;
 
-	pci_dev_put(pdev);
 	name = devm_kasprintf(&plat_dev->dev, GFP_KERNEL, "dwc_rootport_%x", sbdf);
 	if (!name)
 		return -ENOMEM;
-- 
2.53.0



