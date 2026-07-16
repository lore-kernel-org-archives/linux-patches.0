Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB2736A35E;
	Thu, 16 Jul 2026 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209238; cv=none; b=ngmYgwBpybdyvTJ8pNHkvhjSZ2mCGcmn51LY4OV6IDVRAzjzZJN1lV20zXvw4IcDFGoUfjsIq9bcaQCIYtg7tMysPz8JqCm/rOf0O85X/icJ1UcSgqPJvPAOkrygGcFL5pYh7JpthNoi9v/EqEkZttJ3WiZpJCbssRFkHA8HcrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209238; c=relaxed/simple;
	bh=Ky2O4l7wWfwU+luE8JF+DNhohF42AIOU3pP6o7ll8Hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umhyf1GitQv1z0c/f7f5WsOWFWz+pB3VFFi8Mz/F2PtOYFuGCeKgJAKAgwdpeUkMA9ZwTV97sksw3krIEykhMBebtr6sQmcmhYRpaDQ2IiVnsY0aJShRaqNAv9ngz5FDRQiTSm5buJfAMPsn+gDvbelVF3km7Vayw1u9cc+TBKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9O8+qKJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9O8+qKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A801F000E9;
	Thu, 16 Jul 2026 13:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209237;
	bh=nt5OBwZEgxjYKlF0XS3t40Jki5HPyqA2z7xM5FA/W6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9O8+qKJwx/8/5i1hEj4W3pH5QaZsp6H/+slBZNOzgKbUhb0han83cT5iImbmVP84
	 AfVTUUV/AI6deVFMNXIusei4UbdZvTTwXeNYGdr42KgDtLjGHTvZ+ddZEWdOhGD2R/
	 N1BlnSaXPpSL+kt9Huy12gwN856TjIKtB36x9FmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 7.1 108/518] vfio/pci: Release the VGA arbiter client on register_device() failure
Date: Thu, 16 Jul 2026 15:26:16 +0200
Message-ID: <20260716133050.218292053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2255,6 +2255,7 @@ out_power:
 		pm_runtime_get_noresume(dev);
 
 	pm_runtime_forbid(dev);
+	vfio_pci_vga_uninit(vdev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 	return ret;


