Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3ED27732;
	Thu, 16 Jul 2026 14:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211817; cv=none; b=ZAild6FAOECU8e2+mPk6jwo4pePA4UbYxlGIBr5G/W4hXpcnpz684S6d+rmT78eLUjsjH6kzQEU1io7l1pTj68I536CN2LUHQSAttVJBxSkroqdEOeo86AavJ11SwUZk/CscGzUaT3k/f3o9XlV4TSfUIZiDZcyyfRZnyycu4g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211817; c=relaxed/simple;
	bh=nxO0qBLO8KRsAa40N9orbbacDh5wjnS563zCJ1YgYRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaOQt3kEnZi3oRPOqhpPpqgIvFlBOpFKpoL9bMo/Lt0TlN5mFEFPZireYA9UqX2sdBILm//gL2daGR/t5khGxkXFCKy8Tr5tot/m8aeZb289fyQ2vt3iFnWAtvmND19AWM7FBPQg7GVOlgSzHUB1/ydn1F6coZYrhyXVRiqySA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hF0iFWM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hF0iFWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D281F000E9;
	Thu, 16 Jul 2026 14:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211816;
	bh=ha0w+sNXbIGWE76JmGVIS14homHfn57IOLNAaQbPgxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2hF0iFWM6MJqdziWW2q6aiGLpb0WZvDEcwdj3gds/Vh/yOeY30sf6B5zyKu9eursi
	 8HnKVUd++XRSm4YbAi7UOG5YWS7q5lSWsNRxFNge+UbamhgQElbmwDg+2G/0kDH4XV
	 wR63f6TYCfX6qrp76hWMWXQJLDL8DJu/QwNK+ZC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.12 089/349] vfio/pci: Release the VGA arbiter client on register_device() failure
Date: Thu, 16 Jul 2026 15:30:23 +0200
Message-ID: <20260716133035.303860166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2243,6 +2243,7 @@ out_power:
 		pm_runtime_get_noresume(dev);
 
 	pm_runtime_forbid(dev);
+	vfio_pci_vga_uninit(vdev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 	return ret;


