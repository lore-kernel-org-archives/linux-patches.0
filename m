Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3672EB5CA;
	Tue, 15 Jul 2025 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587594; cv=none; b=KCUNpy9kFQkm4fze9VAe/lVlkYMhkPsSOx6Mf5+lyAD/6Eflpli2J+jSQjla+NhBxHYI3jHSxR/K6HCu/7n0meYYcKFQJ/N8HoI5MRH23HYaEAQeg91tD3mRJcE5PQdUll5HC7yy9GydmFdwxBLDUCi98wP7OQE0rBZipETC1eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587594; c=relaxed/simple;
	bh=9/aMNvUK0TLd2l17Vw0Cs3x+E3CXag/atrcOwlU+arE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QflWBDgrz2AZG6oLfSUn+iYRi+Fz3AkEdOURVnZvCTU32ltGlPaFu+8J8s0rGvwUPtzaAMfuCfbcJ7UpY9doklFvcCECytqAww2CxcNlx7QWKIBDcBl/kICMkzc8MfA957XPgp+za4bt2xIQgp5MNpD+BVUqi304ZEwdj49DNWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwvx7on7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwvx7on7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD19C4CEE3;
	Tue, 15 Jul 2025 13:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587594;
	bh=9/aMNvUK0TLd2l17Vw0Cs3x+E3CXag/atrcOwlU+arE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwvx7on7OqdiJiDG/lr4sf2832+FW2Dt3IxI17fqXvk2DySw6es1022CWWO6QC29S
	 5OEnylh/jDie8CboC6C2feXT8+mUNa/Wh0RYDOh2K+4eA8CjLzj2xnsOhvtXIMaoxw
	 Xw6NtEDK4W4W/ZjQm5UiCBTN0/KieUhIJUpWuhdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Boqun Feng (Microsoft)" <boqun.feng@gmail.com>,
	Dexuan Cui <decui@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Jake Oshins <jakeo@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.10 071/208] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot time
Date: Tue, 15 Jul 2025 15:13:00 +0200
Message-ID: <20250715130813.795077157@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dexuan Cui <decui@microsoft.com>

commit 23e118a48acf7be223e57d98e98da8ac5a4071ac upstream.

Currently when the pci-hyperv driver finishes probing and initializing the
PCI device, it sets the PCI_COMMAND_MEMORY bit; later when the PCI device
is registered to the core PCI subsystem, the core PCI driver's BAR detection
and initialization code toggles the bit multiple times, and each toggling of
the bit causes the hypervisor to unmap/map the virtual BARs from/to the
physical BARs, which can be slow if the BAR sizes are huge, e.g., a Linux VM
with 14 GPU devices has to spend more than 3 minutes on BAR detection and
initialization, causing a long boot time.

Reduce the boot time by not setting the PCI_COMMAND_MEMORY bit when we
register the PCI device (there is no need to have it set in the first place).
The bit stays off till the PCI device driver calls pci_enable_device().
With this change, the boot time of such a 14-GPU VM is reduced by almost
3 minutes.

Link: https://lore.kernel.org/lkml/20220419220007.26550-1-decui@microsoft.com/
Tested-by: Boqun Feng (Microsoft) <boqun.feng@gmail.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Jake Oshins <jakeo@microsoft.com>
Link: https://lore.kernel.org/r/20220502074255.16901-1-decui@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1820,12 +1820,17 @@ static void prepopulate_bars(struct hv_p
 				}
 			}
 			if (high_size <= 1 && low_size <= 1) {
-				/* Set the memory enable bit. */
-				_hv_pcifront_read_config(hpdev, PCI_COMMAND, 2,
-							 &command);
-				command |= PCI_COMMAND_MEMORY;
-				_hv_pcifront_write_config(hpdev, PCI_COMMAND, 2,
-							  command);
+				/*
+				 * No need to set the PCI_COMMAND_MEMORY bit as
+				 * the core PCI driver doesn't require the bit
+				 * to be pre-set. Actually here we intentionally
+				 * keep the bit off so that the PCI BAR probing
+				 * in the core PCI driver doesn't cause Hyper-V
+				 * to unnecessarily unmap/map the virtual BARs
+				 * from/to the physical BARs multiple times.
+				 * This reduces the VM boot time significantly
+				 * if the BAR sizes are huge.
+				 */
 				break;
 			}
 		}


