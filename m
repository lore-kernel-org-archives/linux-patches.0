Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746DD377A8A;
	Tue, 21 Jul 2026 22:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672757; cv=none; b=WA9HOIcKMiNpFp+4JWAYI1emyzY31ENDm/qNBiPhcI8QyV/hwBXDbbhkNineP0wtKpoMCrvW8nPxMRwuexZgqPiANGbfRkD4v/sjio7qSeel/CGQFNSE+DrZklyHnH1UTaDnZuoyXJ2k/bQmq8SXdLEYh3yLRRD4yziMy7F7oSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672757; c=relaxed/simple;
	bh=CF86CxRUWXGLEUL+r6FL4S8alnRyrz969vhyDNogjKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxReb95mBBZcGSLVdNMn5XkwpRa9H5Cll7lOf+pRRudIVVRpzsbJGwCYUENctuWD/Ftwo89HyzAI/Chx4OHCcjl2rUnJmfc4+tt9uPA2R0TjSKmGiASrWKD8E7v171JI+4pSpJeySmCLKIr4jBsYnxNUMf3cLbC3ft0owwz/6WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqRsdgcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqRsdgcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1D11F000E9;
	Tue, 21 Jul 2026 22:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672756;
	bh=Yiwg3A7kzQzu61MPd4p/EFIfOYWxWq2Z92cvmYrHIxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqRsdgcAwWgsqODuQzK8que3mX2YC14KUtCZ31p3Xk/xB4Kl71f3mcbjLsfrCZ5TB
	 3yeCLLCx35KGIaEVUPO3CbHUg+1iFJLg1cBCX/3cSPPgBQzjOVz1EDCj2wJ4zo/JII
	 XhloOpM8O5ylZJ9YBYe2xT8sjl/iPG685nf/aZmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 745/843] vfio/pci: Release the VGA arbiter client on register_device() failure
Date: Tue, 21 Jul 2026 17:26:20 +0200
Message-ID: <20260721152422.808137896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@nvidia.com>

[ Upstream commit daedde7f024ecf88bc8e832ed40cf2c795f0796a ]

The re-order in the Fixes commit below displaced vfio_pci_vga_init() as
the last failure point of what is now vfio_pci_core_register_device()
without introducing an unwind for the VGA arbiter registration.

In current kernels this is mostly benign because vfio_pci_set_decode()
only uses pci_dev state, but the original failure path could leave a
callback with a freed vdev cookie.  The stale registration also becomes
unsafe again once the callback follows drvdata to the vfio device.

Add the required VGA unwind callout.

Fixes: 4aeec3984ddc ("vfio/pci: Re-order vfio_pci_probe()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260615191241.688297-3-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1899,6 +1899,7 @@ int vfio_pci_core_register_device(struct
 out_power:
 	if (!disable_idle_d3)
 		vfio_pci_set_power_state(vdev, PCI_D0);
+	vfio_pci_vga_uninit(vdev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 out_group_put:


