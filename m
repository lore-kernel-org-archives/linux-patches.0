Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08201482E4;
	Mon,  1 Apr 2024 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990815; cv=none; b=K1aGgeJ3RzLNxx8/UnGA7VbPVaqHpV62mMiUEfwIcNrM7ud+OOO2TX51YQFKxnQz/awS2QwWREQl/H+DZQ23uwrVeMVQVrpUOvqP6OnvUNEaf4VL+iaeuSstS4NBzYKwVBbO2OyzjeXBRy+WNNzYoyLT1QlQHsB6a4amrBxFrtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990815; c=relaxed/simple;
	bh=X9MVovDmRQdNLp+SQ6XalAwsT73jYnGYG0DNruABDR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/lWhwYwuQHhSqk54Je4kkga4SO9RDaV1Us3z1TWvD3nXOrKV0TAo8mjASRIGuCeq3j9gbtkeuBDusO+/5bzAD7imQaOQwRCN3nUr8x5Hs+kcrrdcNXGqbqAjLFR9HtO4fVphWHIf0XKjql8FDv+V4JQ5mZ3wzc2vr/VdzKPct4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ao+ok+PE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ao+ok+PE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BACBC433C7;
	Mon,  1 Apr 2024 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990814;
	bh=X9MVovDmRQdNLp+SQ6XalAwsT73jYnGYG0DNruABDR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ao+ok+PE9p7rXXKMQOZkOTz5rvm+Ypngopez/FO2TPma2/fNSNnEheDN0mvAsxi4s
	 NxkKP7n63oe/qcIlNgHVzdoWLkViVrMEQF+FB2RH4PsX4dXKdHkdoBMU4tW1y/0rUr
	 7SvQi7i0KD7/j+NSDgUGxxtQY7AGEx+XD63Zop5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niels van Aert <nvaert1986@hotmail.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/272] PCI/DPC: Quirk PIO log size for Intel Raptor Lake Root Ports
Date: Mon,  1 Apr 2024 17:44:24 +0200
Message-ID: <20240401152532.878282256@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c175b70a984c6..289ba6902e41b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6078,6 +6078,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2b, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2d, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a31, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa73f, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa76e, dpc_log_size);
 #endif
 
 /*
-- 
2.43.0



