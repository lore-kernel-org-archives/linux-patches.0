Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FC31DB360;
	Mon,  6 Jan 2025 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177280; cv=none; b=On2CldzTmaOFqsf7CWPVWYS3N1DezrsEwBcIxFVgH8TTUwx1TvXTVMIEGwfP+wOG0egYhRyuc6gO6XrOSK+pwhh3Q0SUO3X79EuYnXzq2GjOX51doPN2n0FA6xV+ekvsqx8/xW7HRgSr4nUAm2WsxQkDxVmIbg7pFJ4zps+/fRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177280; c=relaxed/simple;
	bh=1VOdgh2e9OhO3qltFKHJhUcUHjC2h3aPZjRfxxjSfEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NLjHOWs40pFPtujB2XdSUX+zxOneANqiG6XLfuWNXacQq2MMV9LtDCjKDmGINeI4ubXaspugzQoy7hzlSd/iECtF9PEJ3nt63N4pQgpyP64t1akx/C36CpvlYbW7AWj3A/PVoirzXmEyR4uX1+qQB5XIR/LmtTh9pjX9OGqzytg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQWmzEPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQWmzEPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64731C4CEDF;
	Mon,  6 Jan 2025 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177279;
	bh=1VOdgh2e9OhO3qltFKHJhUcUHjC2h3aPZjRfxxjSfEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQWmzEPtIjl05RPzSRBItSuwQUVoZE/KVE1BwKAEUKbZYdTBDG2AkToRFr0VNZ3B9
	 NNdmmr2FYQhnxALFdwBiGQ9Ffvq2m3IzRzFr9G5UtUMPJUC5myGqtsDkTqYXhjrKD2
	 5pNv3RrGrBElEX3/l61TDqxtzxf74X2Sq/Bhka2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Vadim Pasternak <vadimp@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/222] platform/x86: mlx-platform: call pci_dev_put() to balance the refcount
Date: Mon,  6 Jan 2025 16:15:15 +0100
Message-ID: <20250106151154.797945599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 185e1b1d91e419445d3fd99c1c0376a970438acf ]

mlxplat_pci_fpga_device_init() calls pci_get_device() but does not
release the refcount on error path. Call pci_dev_put() on the error path
and in mlxplat_pci_fpga_device_exit() to fix this.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 02daa222fbdd ("platform: mellanox: Add initial support for PCIe based programming logic device")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20241216022538.381209-1-joe@pf.is.s.u-tokyo.ac.jp
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index a2ffe4157df1..b8d77adc9ea1 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -6237,6 +6237,7 @@ mlxplat_pci_fpga_device_init(unsigned int device, const char *res_name, struct p
 fail_pci_request_regions:
 	pci_disable_device(pci_dev);
 fail_pci_enable_device:
+	pci_dev_put(pci_dev);
 	return err;
 }
 
@@ -6247,6 +6248,7 @@ mlxplat_pci_fpga_device_exit(struct pci_dev *pci_bridge,
 	iounmap(pci_bridge_addr);
 	pci_release_regions(pci_bridge);
 	pci_disable_device(pci_bridge);
+	pci_dev_put(pci_bridge);
 }
 
 static int
-- 
2.39.5



