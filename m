Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39755A79B;
	Thu, 16 Jul 2026 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210625; cv=none; b=Qleo12QKDPmtyLvbiOKW05mFK5hgsRCI/ifsKmSmxk122srSC5xXikPky0c5sAbXYRMZ9AZ6Wf4bvNMmvI8MWdKnD0YCqhXbO8CTy8sNr987ncKQXMwU4O5ZsrHE8woF8JVNpfp5N4Ndta7kNIUadME6F7IpNcn2aAUSV70i2hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210625; c=relaxed/simple;
	bh=s/5r9FPMElCKj9Wa5E7VFfPgwQMZDaxuQ+aWSpfwNP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJtpMHlZGxa2veTssl1YhCg+a0o/vURw9bNqb4C86ZXdmyK8CaqV/0FoKK3kyIXz1ofPhFsnU6Sa08yyvXRBOyEH4YqlBErJpwHSaTXxiOItE9HIYol5UlCi3JXCexTf0aCvNUqi9qpGv45pxTQygKwT+CqTjm360ZUEZ2/tnsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkF/3aIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkF/3aIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649641F000E9;
	Thu, 16 Jul 2026 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210623;
	bh=QWnh2GwsP1I4ods9HGDDRU5GuJaRyI84Nlq2WRYamt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkF/3aIe8C9ZEi7v4OzoLBhQat1XnlQsllAM2i5uutUIiU+BNrai1vEgspqB51XF/
	 aIVxUt/R+wdtKlW5p+8yxixxjIDGGs+yM+UIDHES+hfcUg23QrFi+VwOpGklbpGUfE
	 vnPD8te+9FaJVT4FzNf/cwkw4bj3zLgxFzXKPJ4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.18 118/480] vfio/pci: Release the VGA arbiter client on register_device() failure
Date: Thu, 16 Jul 2026 15:27:45 +0200
Message-ID: <20260716133047.258363326@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Alex Williamson <alex.williamson@nvidia.com>

commit daedde7f024ecf88bc8e832ed40cf2c795f0796a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2237,6 +2237,7 @@ out_power:
 		pm_runtime_get_noresume(dev);
 
 	pm_runtime_forbid(dev);
+	vfio_pci_vga_uninit(vdev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 	return ret;


