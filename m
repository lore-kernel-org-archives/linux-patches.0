Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F682DB785;
	Wed, 30 Sep 2026 18:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794425; cv=none; b=WqRSLr7+bgB2CQH6yrg4GIkKRbKLUS81FFuR8Sdz5BJXkiroCAJy0ge3JaIIHZzFxzKU9PABCI+hWhbqtad0s1+6iWExusTgu4OIBfMvkR01NLvCd0t9Wf60xyk6DzAHwb76hSbipaJeTYAn5xYKlCd6OW24NvU2kWu9wRsvza8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794425; c=relaxed/simple;
	bh=ne6yCCLbz/cAR9fffTCc3rB/x/BYsN9CIEU4iEOiGAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFNYKBxsm9B0OAAPqO99/oGH3PUSG36TiLHRT/BboHMHEl2zwMCcgXMKN18vCHXv3t8UbCvdJuA4SLd8wxUHJQD9Du5F+WL8Kz09rJ6URkz8xmmAlx8PELSuDRK6BKLgNsgX0bXreFWEUoKtzA+U1rstosvE5blhWt0U+Aq2QTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rU5W8I5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rU5W8I5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C363B1F000FF;
	Wed, 30 Sep 2026 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794424;
	bh=jIcaY4RjLIbc+yyCpbJXFNwSvZfz6bB/GTBwsdYN3pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rU5W8I5Tv22Dd+jU4KeRR8H3VjzwAYN6M8B3MfSvjFXek76iR0MSdx6+1+OhY9smy
	 R9pJz2Uv4jtRxN7/env9hDEN+jPjF3TxhSSo4S0kG/2u/ijMGK2XwGtyseMrkMxTf+
	 jJzPf6FTwayiEQwnAoSMmCH5PiPkCxp6Ckr28J+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0207/1193] PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi, SDX62/SDX65 modems
Date: Wed, 30 Sep 2026 17:14:51 +0200
Message-ID: <20260930152438.805769021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0068ca7cdf367..027f26035053e 100644
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



