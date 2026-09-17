Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8873B27E1;
	Thu, 17 Sep 2026 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668008; cv=none; b=c1vIbgB+0Ky/c8wOZ5P2BFoQ/zuSQvpvklEy5QZvnDS7yzSaQHAsIYvJMHjYVrMiJEQS0ZaIO0fTiIEMNEweEw6PXpIwnUIMJObx6Gb3ia+QTeZpIPZU+2fe1R4gzIzfWC92bJPGA7rDohNpcQS19u9whT8rSY5A+kAQ+7f06FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668008; c=relaxed/simple;
	bh=4cZeRmWmg+EVAZ+uyxis3SWe0wWeU3Bp6j93CKq7QQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8+nyH838vOUPHgcebse2UMokzXuEUt6A2uGy7ypcndT8yoAQ01ij2HdpM/ojVNFAIbp0BOz2E4IG/SKgv9cDaIAEbpyWFS8FBrwsnZHbks+qCTReitinuHRV7Oca7uel9x/6lIJkf0uSiEbV78UQJ7ncHpC0TIZzm/9jvGRSCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zthk+oE1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zthk+oE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5941F000FF;
	Thu, 17 Sep 2026 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668006;
	bh=PC65GpYQV8o53XVDX6DlADWUfHapbknLUTcuXeAEXrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zthk+oE1fnu91E4laN+uyq77qiIfztudEKx5wyVZCvP92aWG5L3CWQ1exOioX/kg3
	 1ngrAqiia8i290aWsKDXKRnF9tnkFeoIpMKzrd70l/N+JI9a9gaNuIk+F99GsB5bQD
	 qTl43d3xAeB8LLUBak2sL5DbGsmIN2T4ciuf4czQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0281/1102] PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi, SDX62/SDX65 modems
Date: Thu, 17 Sep 2026 16:03:44 +0100
Message-ID: <20260917151546.666873639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit 6a4f64c3a3ada43e71ef1e06da89beb36bdaeefa ]

Some Qualcomm PCIe devices (WCN6855/WCN7850 WiFi cards, SDX62/SDX65 modems)
do not properly support Secondary Bus Reset (SBR).

Testing confirms this is device-specific, not deployment-specific:
MediaTek MT7925e successfully uses bus reset through the same passive
M.2-to-PCIe adapters where Qualcomm devices fail, proving PERST# is
properly wired through the adapters.

Prevent use of Secondary Bus Reset for these devices.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/all/20260609163649.319755-4-jtornosm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index db667115b34ed..ac9851e3d65b4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3770,6 +3770,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003e, quirk_no_bus_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x1103, quirk_no_bus_reset); /* WCN6855 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x1107, quirk_no_bus_reset); /* WCN7850 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_QCOM, 0x0308, quirk_no_bus_reset); /* SDX62/SDX65 */
 
 /*
  * Root port on some Cavium CN8xxx chips do not successfully complete a bus
-- 
2.53.0



