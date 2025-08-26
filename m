Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7112C17A0;
	Tue, 26 Aug 2025 11:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207224; cv=none; b=jdFapH+GMsOiNFvJCfEoyJKc59PrzgAmBj8P/CSmsFjh3Xnxm4mp48JlU1ZfPnS2SI3FHwavPGw00JVVJG75MdnjRgeLsQo1/PBrnG/9OeW79I+dLVRu1m7jJLwOQfVE6w1nSunJFwgefc/EMKhRWiMsvGAW41KqSM2mxQSlFRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207224; c=relaxed/simple;
	bh=JAZBEfSc6VkHkjKKv0HqXaFJ2z7JcOqrL3Zik8aAc8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JoYPLt+dNOB1Wu28O/26Mgg1R6gdHW/2wbMNhS6zOLyXKjyBfys8izqqPq+P/8Jp2pYXxnNzy/+1N5O3RpaDJ2YGOFx6fEaUxYhMv6Y3vTpUx/XIUfKTRwyC6t8CqnK+KvlECtJmmkunViXbTGRIjQP/6yXwaCeG/bsDVhb5Xb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjfukGZL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjfukGZL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1EDC4CEF1;
	Tue, 26 Aug 2025 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207223;
	bh=JAZBEfSc6VkHkjKKv0HqXaFJ2z7JcOqrL3Zik8aAc8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjfukGZLQmEw1YW5r7yWOQEytjUxSHnr5M7M2A9B5EzmCb35OZMACD1TMxpi0e5tK
	 9W/lPSd+iKtW2vq5f2Utchj7wHDGJ2Qc9JQSo+1NBe0efibDDlNU7xKC7Y2VRKs3LY
	 hnNjVyRH5ovx6oxjcLU2fkIEsqwngh31cd4AX+aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew <andreasx0@protonmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jiwei Sun <sunjw10@lenovo.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.16 098/457] PCI: Fix link speed calculation on retrain failure
Date: Tue, 26 Aug 2025 13:06:22 +0200
Message-ID: <20250826110939.798071836@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiwei Sun <sunjw10@lenovo.com>

commit 9989e0ca7462c62f93dbc62f684448aa2efb9226 upstream.

When pcie_failed_link_retrain() fails to retrain, it tries to revert to the
previous link speed.  However it calculates that speed from the Link
Control 2 register without masking out non-speed bits first.

PCIE_LNKCTL2_TLS2SPEED() converts such incorrect values to
PCI_SPEED_UNKNOWN (0xff), which in turn causes a WARN splat in
pcie_set_target_speed():

  pci 0000:00:01.1: [1022:14ed] type 01 class 0x060400 PCIe Root Port
  pci 0000:00:01.1: broken device, retraining non-functional downstream link at 2.5GT/s
  pci 0000:00:01.1: retraining failed
  WARNING: CPU: 1 PID: 1 at drivers/pci/pcie/bwctrl.c:168 pcie_set_target_speed
  RDX: 0000000000000001 RSI: 00000000000000ff RDI: ffff9acd82efa000
  pcie_failed_link_retrain
  pci_device_add
  pci_scan_single_device

Mask out the non-speed bits in PCIE_LNKCTL2_TLS2SPEED() and
PCIE_LNKCAP_SLS2SPEED() so they don't incorrectly return PCI_SPEED_UNKNOWN.

Fixes: de9a6c8d5dbf ("PCI/bwctrl: Add pcie_set_target_speed() to set PCIe Link Speed")
Reported-by: Andrew <andreasx0@protonmail.com>
Closes: https://lore.kernel.org/r/7iNzXbCGpf8yUMJZBQjLdbjPcXrEJqBxy5-bHfppz0ek-h4_-G93b1KUrm106r2VNF2FV_sSq0nENv4RsRIUGnlYZMlQr2ZD2NyB5sdj5aU=@protonmail.com/
Suggested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
[bhelgaas: commit log, add details from https://lore.kernel.org/r/1c92ef6bcb314ee6977839b46b393282e4f52e74.1750684771.git.lukas@wunner.de]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org	# v6.13+
Link: https://patch.msgid.link/20250123055155.22648-2-sjiwei@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.h |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -391,12 +391,14 @@ void pci_bus_put(struct pci_bus *bus);
 
 #define PCIE_LNKCAP_SLS2SPEED(lnkcap)					\
 ({									\
-	((lnkcap) == PCI_EXP_LNKCAP_SLS_64_0GB ? PCIE_SPEED_64_0GT :	\
-	 (lnkcap) == PCI_EXP_LNKCAP_SLS_32_0GB ? PCIE_SPEED_32_0GT :	\
-	 (lnkcap) == PCI_EXP_LNKCAP_SLS_16_0GB ? PCIE_SPEED_16_0GT :	\
-	 (lnkcap) == PCI_EXP_LNKCAP_SLS_8_0GB ? PCIE_SPEED_8_0GT :	\
-	 (lnkcap) == PCI_EXP_LNKCAP_SLS_5_0GB ? PCIE_SPEED_5_0GT :	\
-	 (lnkcap) == PCI_EXP_LNKCAP_SLS_2_5GB ? PCIE_SPEED_2_5GT :	\
+	u32 lnkcap_sls = (lnkcap) & PCI_EXP_LNKCAP_SLS;			\
+									\
+	(lnkcap_sls == PCI_EXP_LNKCAP_SLS_64_0GB ? PCIE_SPEED_64_0GT :	\
+	 lnkcap_sls == PCI_EXP_LNKCAP_SLS_32_0GB ? PCIE_SPEED_32_0GT :	\
+	 lnkcap_sls == PCI_EXP_LNKCAP_SLS_16_0GB ? PCIE_SPEED_16_0GT :	\
+	 lnkcap_sls == PCI_EXP_LNKCAP_SLS_8_0GB ? PCIE_SPEED_8_0GT :	\
+	 lnkcap_sls == PCI_EXP_LNKCAP_SLS_5_0GB ? PCIE_SPEED_5_0GT :	\
+	 lnkcap_sls == PCI_EXP_LNKCAP_SLS_2_5GB ? PCIE_SPEED_2_5GT :	\
 	 PCI_SPEED_UNKNOWN);						\
 })
 
@@ -411,13 +413,17 @@ void pci_bus_put(struct pci_bus *bus);
 	 PCI_SPEED_UNKNOWN)
 
 #define PCIE_LNKCTL2_TLS2SPEED(lnkctl2) \
-	((lnkctl2) == PCI_EXP_LNKCTL2_TLS_64_0GT ? PCIE_SPEED_64_0GT : \
-	 (lnkctl2) == PCI_EXP_LNKCTL2_TLS_32_0GT ? PCIE_SPEED_32_0GT : \
-	 (lnkctl2) == PCI_EXP_LNKCTL2_TLS_16_0GT ? PCIE_SPEED_16_0GT : \
-	 (lnkctl2) == PCI_EXP_LNKCTL2_TLS_8_0GT ? PCIE_SPEED_8_0GT : \
-	 (lnkctl2) == PCI_EXP_LNKCTL2_TLS_5_0GT ? PCIE_SPEED_5_0GT : \
-	 (lnkctl2) == PCI_EXP_LNKCTL2_TLS_2_5GT ? PCIE_SPEED_2_5GT : \
-	 PCI_SPEED_UNKNOWN)
+({									\
+	u16 lnkctl2_tls = (lnkctl2) & PCI_EXP_LNKCTL2_TLS;		\
+									\
+	(lnkctl2_tls == PCI_EXP_LNKCTL2_TLS_64_0GT ? PCIE_SPEED_64_0GT :	\
+	 lnkctl2_tls == PCI_EXP_LNKCTL2_TLS_32_0GT ? PCIE_SPEED_32_0GT :	\
+	 lnkctl2_tls == PCI_EXP_LNKCTL2_TLS_16_0GT ? PCIE_SPEED_16_0GT :	\
+	 lnkctl2_tls == PCI_EXP_LNKCTL2_TLS_8_0GT ? PCIE_SPEED_8_0GT :	\
+	 lnkctl2_tls == PCI_EXP_LNKCTL2_TLS_5_0GT ? PCIE_SPEED_5_0GT :	\
+	 lnkctl2_tls == PCI_EXP_LNKCTL2_TLS_2_5GT ? PCIE_SPEED_2_5GT :	\
+	 PCI_SPEED_UNKNOWN);						\
+})
 
 /* PCIe speed to Mb/s reduced by encoding overhead */
 #define PCIE_SPEED2MBS_ENC(speed) \


