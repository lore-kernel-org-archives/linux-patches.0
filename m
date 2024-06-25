Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13258149C47;
	Tue, 25 Jun 2024 09:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309066; cv=none; b=t3Ed2hT7ftnPpCBy11yevsgQU6zmIsv/ac8cn9UX4QylhzDaOImhtImjgwi4r0aGIaAsICPPnzX02EdXpgC1RTnbPmv4SxcANCMp13ihze9yenEJrii69bk3oAuQ2Ak50b1Z+EQU1hy2RX6OjzU3ICS7xc1Ndp7MAX+jqdlFJ10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309066; c=relaxed/simple;
	bh=YkJ6I/pBdq1gvkziOLsFtlAyoxITPKhuG3e1PAnkmqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLwkL6JAXVmXlKUqCZQR+st9Rb3TGDMjM0BmYZ8t6HwUY7DZo8R4l+gRYcdiXKDdSvQS4w+rszTcoWgyGUOmMjHpNQHSy9T+3wncFCiPMbcPMBQHLqevxUH6SMDqQ9t8tCWGx1QUjfeWuqsGcVc5zJO3mvKUK5Ei3rzcUkOmFAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VtyEZNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VtyEZNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85083C32781;
	Tue, 25 Jun 2024 09:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309065;
	bh=YkJ6I/pBdq1gvkziOLsFtlAyoxITPKhuG3e1PAnkmqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VtyEZNe8r/R+JJnMn6BEZoOmBOHHbgduV9bbBOp3e2B9DNqSp0bFPmNDD2km2Jcp
	 PPiTJW+ZBiXr6T6bVqO/4PcDieg39/Y43SPD5jseYsMhYRjc37mKSAl8/1b/2v6Hhr
	 ENBcNANnHG6pbuVlxEVVFVk4KQnPc7/qdeo3Ves0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Heintzmann <heintzmann.eric@free.fr>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/192] PCI/PM: Avoid D3cold for HP Pavilion 17 PC/1972 PCIe Ports
Date: Tue, 25 Jun 2024 11:32:04 +0200
Message-ID: <20240625085539.167242774@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 256df20c590bf0e4d63ac69330cf23faddac3e08 ]

Hewlett-Packard HP Pavilion 17 Notebook PC/1972 is an Intel Ivy Bridge
system with a muxless AMD Radeon dGPU.  Attempting to use the dGPU fails
with the following sequence:

  ACPI Error: Aborting method \AMD3._ON due to previous error (AE_AML_LOOP_TIMEOUT) (20230628/psparse-529)
  radeon 0000:01:00.0: not ready 1023ms after resume; waiting
  radeon 0000:01:00.0: not ready 2047ms after resume; waiting
  radeon 0000:01:00.0: not ready 4095ms after resume; waiting
  radeon 0000:01:00.0: not ready 8191ms after resume; waiting
  radeon 0000:01:00.0: not ready 16383ms after resume; waiting
  radeon 0000:01:00.0: not ready 32767ms after resume; waiting
  radeon 0000:01:00.0: not ready 65535ms after resume; giving up
  radeon 0000:01:00.0: Unable to change power state from D3cold to D0, device inaccessible

The issue is that the Root Port the dGPU is connected to can't handle the
transition from D3cold to D0 so the dGPU can't properly exit runtime PM.

The existing logic in pci_bridge_d3_possible() checks for systems that are
newer than 2015 to decide that D3 is safe.  This would nominally work for
an Ivy Bridge system (which was discontinued in 2015), but this system
appears to have continued to receive BIOS updates until 2017 and so this
existing logic doesn't appropriately capture it.

Add the system to bridge_d3_blacklist to prevent D3cold from being used.

Link: https://lore.kernel.org/r/20240307163709.323-1-mario.limonciello@amd.com
Reported-by: Eric Heintzmann <heintzmann.eric@free.fr>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3229
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Eric Heintzmann <heintzmann.eric@free.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6ea01007031a4..a41a1a6155411 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3040,6 +3040,18 @@ static const struct dmi_system_id bridge_d3_blacklist[] = {
 			DMI_MATCH(DMI_BOARD_VERSION, "Continental Z2"),
 		},
 	},
+	{
+		/*
+		 * Changing power state of root port dGPU is connected fails
+		 * https://gitlab.freedesktop.org/drm/amd/-/issues/3229
+		 */
+		.ident = "Hewlett-Packard HP Pavilion 17 Notebook PC/1972",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_BOARD_NAME, "1972"),
+			DMI_MATCH(DMI_BOARD_VERSION, "95.33"),
+		},
+	},
 #endif
 	{ }
 };
-- 
2.43.0



