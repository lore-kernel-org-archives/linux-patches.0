Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC947A64;
	Mon,  1 Apr 2024 16:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988149; cv=none; b=IPmNYK/xnvlkHrLW0w3LdtSuQCfE6b2Kn//KRtDYE8/y3/YPl7qaY6APWTQFwPnFt2BDOi3L/WtyQHXaNaRAuu4/gHigfAZleEkB4ajFfErvbVnPJcITotiUIlmt0TxNGkubiD29cnL2wGS5tRSQPAM3+CAeG/OoPu0LfyX2DDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988149; c=relaxed/simple;
	bh=qohvYUmAjmODXlEswvTBSLfmk2QmaWw3Es15thBz5H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbrAYVwWLKb9sF9mzXiShgUeD0kNfyu7vsPml1JdUTIZV/bO0m5hpljEq6CJiqX1EtY7YUCQIsfpUWlblA61Eipr9F5tH1pWMqiJwe9cVKSpbyxXJEpbxcqJ/UIg5cWI2zxO7FNUekmC5rBj/24KRDEv4Ccp+TogjTg6RUx/s20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KL56BVk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KL56BVk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0A6C433C7;
	Mon,  1 Apr 2024 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988149;
	bh=qohvYUmAjmODXlEswvTBSLfmk2QmaWw3Es15thBz5H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KL56BVk22mVB74EsyONJAD7uDECt5GnT32jGE5NchfRhfemRfcwz8nVP/RM9KqTmz
	 7gj5K2ABqhSQiXUhWZuMywNBs6A0XkYyE2HuT+Ssy+3aPcjW0GUYWXqbgcBgi7ceqZ
	 qhBtFqN33BjWLPj17nF3KcXCuX9DCfoHy123h1Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niels van Aert <nvaert1986@hotmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 098/432] PCI/DPC: Quirk PIO log size for Intel Raptor Lake Root Ports
Date: Mon,  1 Apr 2024 17:41:25 +0200
Message-ID: <20240401152556.047000174@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 528044237bf9f..fa770601c655a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6219,6 +6219,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2b, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2d, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a31, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa73f, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa76e, dpc_log_size);
 #endif
 
 /*
-- 
2.43.0



