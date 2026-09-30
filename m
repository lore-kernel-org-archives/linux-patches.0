Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9273A4BE423;
	Wed, 30 Sep 2026 17:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790970; cv=none; b=nI4lEhbsx4tApA3ekhCFm5r6qDlxzme3P1+IEtbiRv8D8gJ5RHslNxmqAaSZHnuRvFP5cJz4ib/2WgvKPVsKOKLbRWoQxSf5h5eiul1QsGpGtzn2ItJJ4/NusJRXN+T17LAsOXhMxRhh5HgJVKx+UvxubsqvE7tok0qVh9rJfjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790970; c=relaxed/simple;
	bh=RZUPSB0WF41ChEpVEA6eShSOchHZOihd5sLAmSfpurQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bh7OtCuTbvhiwYSgB5v+lFgG6ZIIe+1Mn7usmf7/RFauvEd7ixvRI/9Vh1soy9BkoDD8KpBs6BFu+DLCzvJviixK7KGwC5vSbs5INUSlTcXz8EHj08z0ISVxvLA3hTupA3FnHZvPGkQKvSgiT8vex3vnv40CZznqODaVNehkJys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4IzvTkJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4IzvTkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63BC1F000FF;
	Wed, 30 Sep 2026 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790969;
	bh=42lfi66egdTbQ+EnV60N6E9dnvGhtJIyQUQLXdPMYFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4IzvTkJwVjQQkC/Aoe0e3yex40VHOfYl+TfonWWSffErnTimFJbnMphat1uBiYMm
	 kwEpFoG1AqiUA2sGAq1NCedSGIpbM/j8XKZOb8UVh6YQe4s3Hgnuc4DBJJwzV6vvsX
	 WjkqK5ow5E/fCL7ZGzh0FD1PvXWXs7nHVNON/mtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/752] PCI: Avoid SBR for Qualcomm WCN6855/WCN7850 WiFi, SDX62/SDX65 modems
Date: Wed, 30 Sep 2026 17:20:09 +0200
Message-ID: <20260930152401.184358884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7562f688f74d7..5859414d478c1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3642,6 +3642,9 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
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



