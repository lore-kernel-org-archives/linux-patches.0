Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7035E63A2;
	Thu, 11 Apr 2024 10:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831721; cv=none; b=osHjr1jL9ClTyA3pqp9atYNmoUUfPjCW7dLTHixwrxXG59BTmEqZa+rNdOZ+bRFZB0OL7o1PB4qnyV6w7zv9zrEyNsOcoeMnU1yxUzZNp37hXWP+K34ttP3+aZcXlcD6nC8WEpFx583OQHfkwfaJ0ZHTbXPzJsV/0spSNX5yv4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831721; c=relaxed/simple;
	bh=t8+2CH8iTY38sKBZgBtby6kLa2nC40lemlZLg21Kbhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=To8d1okvuG3mBW+W2hDQxjergq/pImS0jd1HOV8W65JhprhxAG3wF3j0XflZpApE1cyAObK9cYK9LiguNdS+UAjpc/MjQkPqF2+jXkePd1RyAd7d+YkmwejE7Q0RT7v+ms9ust0YKYJwKUXmdRidtcqzuUH1I6yrDOj+aFo+6P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pqWChNI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pqWChNI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DDFC433F1;
	Thu, 11 Apr 2024 10:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831721;
	bh=t8+2CH8iTY38sKBZgBtby6kLa2nC40lemlZLg21Kbhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pqWChNI7MfkmuTZ2mJfgV9QbTXBNR7y7S2E1ZgacCyKcqW7iUt4AzT/uDu2NPhoUX
	 l3X2G8dzBDjRw2Xx0KpCL4DGCGsVVS6w4hVcXbKm9aW5tlVXX/mI+0jPTngSX0lVTF
	 uty/+PH7C267pKCHnmSDHKxB6ULmQipAr/2oWyL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niels van Aert <nvaert1986@hotmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/294] PCI/DPC: Quirk PIO log size for Intel Raptor Lake Root Ports
Date: Thu, 11 Apr 2024 11:53:49 +0200
Message-ID: <20240411095437.675995680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit 627c6db20703b5d18d928464f411d0d4ec327508 ]

Commit 5459c0b70467 ("PCI/DPC: Quirk PIO log size for certain Intel Root
Ports") and commit 3b8803494a06 ("PCI/DPC: Quirk PIO log size for Intel Ice
Lake Root Ports") add quirks for Ice, Tiger and Alder Lake Root Ports.
System firmware for Raptor Lake still has the bug, so Linux logs the
warning below on several Raptor Lake systems like Dell Precision 3581 with
Intel Raptor Lake processor (0W18NX) system firmware/BIOS version 1.10.1.

  pci 0000:00:07.0: [8086:a76e] type 01 class 0x060400
  pci 0000:00:07.0: DPC: RP PIO log size 0 is invalid
  pci 0000:00:07.1: [8086:a73f] type 01 class 0x060400
  pci 0000:00:07.1: DPC: RP PIO log size 0 is invalid

Apply the quirk for Raptor Lake Root Ports as well.

This also enables the DPC driver to dump the RP PIO Log registers when DPC
is triggered.

Link: https://lore.kernel.org/r/20240305113057.56468-1-pmenzel@molgen.mpg.de
Reported-by: Niels van Aert <nvaert1986@hotmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218560
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Niels van Aert <nvaert1986@hotmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index a467e3ce6fb10..eca4ed45bb4ee 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5944,4 +5944,6 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2b, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2d, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a31, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa73f, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa76e, dpc_log_size);
 #endif
-- 
2.43.0



