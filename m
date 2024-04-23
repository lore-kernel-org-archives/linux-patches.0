Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D611420BE;
	Tue, 23 Apr 2024 21:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908709; cv=none; b=ExcaQEA+29nhfy/QPYBpG4tFsNnF0YqH9RnK41yggERrFljvl/zcyMLPgCldFtAo6KdnyK9VVDn3oXe83HI1pIwKJiEZvY7lvlQTSjtclVjdsRTr+Pa1qVciDm71LudYfxN5nrvbvLN7PgL0ZtMkQAK7iqPJdsDYDWsDmgUWqkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908709; c=relaxed/simple;
	bh=W5R/gXNLsubgP1ofWaa2232rch0CXbxaisOYUVs7VPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMlUIrqXZtqjT/9PNmuv24jjooJOfOliILldkLzXqa0Gczb6iaq+i4NwsI8EZLNe6ed8padMDZWpODLsz/CNw7hEoEQxnYQyzOBRW3qaCP3FWp/h37vdzWXWqEvBKv9AC6+A9sufBuwCyklSYiPIdszkYiQIR21l/cogoRof5Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APr+NIyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APr+NIyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2370C116B1;
	Tue, 23 Apr 2024 21:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908708;
	bh=W5R/gXNLsubgP1ofWaa2232rch0CXbxaisOYUVs7VPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APr+NIyHtmT9Fd+9lFCYn3ABB9BqseYM/rNSTox8TiBI9yT5uDdA2GhuUoDwvUaUf
	 d2w5k8gyVQT3hSgMsFEEueV/w7L2CWhIWxIRXYaKZv+1Uw3WwcyzTTdoEBxDI73auM
	 dSKrdLzX4nxdRWpoGxagRXnuTraQgWP5mFTEJxiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@kernel.org>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/141] PCI: Make quirk using inw() depend on HAS_IOPORT
Date: Tue, 23 Apr 2024 14:38:53 -0700
Message-ID: <20240423213855.355112439@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit f768c75d61582b011962f9dcb9ff8eafb8da0383 ]

In the future inw() and friends will not be compiled on architectures
without I/O port support.

Co-developed-by: Arnd Bergmann <arnd@kernel.org>
Link: https://lore.kernel.org/r/20230703135255.2202721-2-schnelle@linux.ibm.com
Signed-off-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3959ea7b106b6..5aca621dd1c22 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -268,6 +268,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_2,	quirk_isa_d
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_NEC,	PCI_DEVICE_ID_NEC_CBUS_3,	quirk_isa_dma_hangs);
 #endif
 
+#ifdef CONFIG_HAS_IOPORT
 /*
  * Intel NM10 "TigerPoint" LPC PM1a_STS.BM_STS must be clear
  * for some HT machines to use C4 w/o hanging.
@@ -287,6 +288,7 @@ static void quirk_tigerpoint_bm_sts(struct pci_dev *dev)
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_TGP_LPC, quirk_tigerpoint_bm_sts);
+#endif
 
 /* Chipsets where PCI->PCI transfers vanish or hang */
 static void quirk_nopcipci(struct pci_dev *dev)
-- 
2.43.0



