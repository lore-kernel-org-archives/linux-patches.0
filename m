Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C6E4D1794;
	Thu, 17 Sep 2026 17:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664631; cv=none; b=THVsF+Dcr3QYd3wcJ7l0uI52kwIjQTw1weBQE+t9hPsygMe5nZQ3xs6WZEDXo7E3Ff62MpMQYK6zh/jiWwKdtOSPkiYItj0vO5rzDquv1so0lRDszasRvbw1Po/KoURRIIqX9AZSX2a/ehhJOngqg7GLgqnEFlqNtx643x/rtTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664631; c=relaxed/simple;
	bh=DNF3jNG4zd4fIOTHSVkko/r6S26cUkQhLCCVhXY8JIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIXb/CqmGJXIoTC2TiKP5/YFyzZqr8hvZcni2YI7c0x9xWeLJqkLwzCgSbHQSoba3qhaEzjLsaaeO6sbxMIS1o+5nzVSNKqQrSB7pjpMOgVVxMuY2WFXVvZobUqM5tYVtnJRoq7t9LWmiDn5t6RJ+yTjBEyEy/9p6sXaO/oFB7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRUf0n/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRUf0n/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9101F000FF;
	Thu, 17 Sep 2026 17:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664630;
	bh=909I4nqkF/e2ZL8BcBvLqfAFWY7/r7c6Nlbq6nHOkfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRUf0n/9o4jbbgp6lM8eWkHPJajVYWD1UhqkGJvkxkuSdldofRDnmkDt2QKnl7tqH
	 +5lQacppB7zk4SDbIyF6BxNMvc1QPjOwAd4f/RjIOxdee/+sMPIdmGAdUhcInOZYfS
	 YwPw3WEQkiTl9O3FrpxdgBlbc6VJweeV1loMgLXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0387/1250] PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi, SDX62/SDX65 modems
Date: Thu, 17 Sep 2026 16:03:02 +0100
Message-ID: <20260917151602.529080406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 60cbb80922614..e8067ff59e2a5 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3779,6 +3779,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
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



