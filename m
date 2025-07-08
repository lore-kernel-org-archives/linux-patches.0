Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AD42E542E;
	Tue,  8 Jul 2025 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993995; cv=none; b=SqgDlObfkIR8NYctxzuZVZKou7gBlnO9NW4Q9Avgx6+qixBwxjWEWyQ3Kw/HgzSs1EIGxiiCkpS0RkzkGuGqnkm00mdJ30IuHqvQ354FNibHbJvicVz7IqwLUX5K4vhUTCwi7HcZwWQrDtKlFtqgx3ViK05Ouk8GiiJyShmZnYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993995; c=relaxed/simple;
	bh=iRkilgE6EPiduBF5Dc+1lh48wFUoCTVz/NGUQMSRerE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gH/eW7zysEALIfrtQAJwkCmwTX29ABG+fzdw3OWTBdpt/iulRgVjPEao4eHwfE82upHyGXEnP1VEhp8ojNdZoF8rULESXVF54FlSdVgcafpKlbK51FQEX3ibhtfyDcUQnaRgrAv2ZcJ21aYuwVmhYERcexjQPTzp9wJ+xmTcHJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE1U3RaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE1U3RaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DA2C4CEED;
	Tue,  8 Jul 2025 16:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993995;
	bh=iRkilgE6EPiduBF5Dc+1lh48wFUoCTVz/NGUQMSRerE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE1U3RaKqrt+O5rA5ea49q4NEt0USOIvjgly2GYFm5YXSCdRURldIuKm/zvueEEiY
	 2UaXdRaiLbbIOF3AMf8nXhDbungBu0Q0076d3ofs4hRdXHvBwURnI/wK1kelt2JvkR
	 3hXWwM9vlLwTOYYbl4ne6owkCDiX88Rfah43B5L4=
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
Subject: [PATCH 5.15 089/160] PCI: hv: Do not set PCI_COMMAND_MEMORY to reduce VM boot time
Date: Tue,  8 Jul 2025 18:22:06 +0200
Message-ID: <20250708162233.978644495@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1882,12 +1882,17 @@ static void prepopulate_bars(struct hv_p
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


