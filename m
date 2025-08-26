Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF64622DFB8;
	Tue, 26 Aug 2025 13:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215679; cv=none; b=bsHhdUM1nZpI+qNLEQF3kfp1x0qSlCcG0VAGn3FQC1tq9B4X5xVvz1GEbuilsgFgjgkcSTbgrs6Y9doRQlwBfOu7vLoB98ylbDr+aNJHlt8Jtv0DPyJ2AYoEBK+eSUwROxmF+MCGkqd5+RNpDcJAYtK1DWLf9zmHx5I3o4v1kuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215679; c=relaxed/simple;
	bh=FP6LXRbGZ8kGX8bwCh3TqqwzKQoHw0Vr2D9K/giElvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XK5zzvgKa2roKZdeCjYZCDzhHu4Zyt8xAZzy1GaZ9S9MHwTEx+0ksikH2IowpcPcHdP84e0gErdZmT8oCttm3KPLmy53AFNu8KZdslhnZGdEjDW6mzdSZ1p1D4qLstg0OgeOVL3j7CrY5B3/Z2u7OwOQlcn+1sJdddImzxoBFns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHKjWl1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHKjWl1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79183C4CEF1;
	Tue, 26 Aug 2025 13:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215678;
	bh=FP6LXRbGZ8kGX8bwCh3TqqwzKQoHw0Vr2D9K/giElvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHKjWl1AlOWlXA172JmOjzx9lijPbPCahJCSwDOn5ZkKs7RcDrnnJIkM4TnbXbTKO
	 BM55sPI61B+1h4KawPwtp/L4ggkiodaUcyQZaVH+0KpVkMPuzv75A7G+g3Re/GDT1j
	 4Mz7RCNPE9Jz766DOZd3LT8Ihwx5gxpP8mvdQFBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/644] usb: early: xhci-dbc: Fix early_ioremap leak
Date: Tue, 26 Aug 2025 13:03:34 +0200
Message-ID: <20250826110949.565955470@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 2b7eec2ec3015f52fc74cf45d0408925e984ecd1 ]

Using the kernel param earlyprintk=xdbc,keep without proper hardware
setup leads to this:

	[ ] xhci_dbc:early_xdbc_parse_parameter: dbgp_num: 0
	...
	[ ] xhci_dbc:early_xdbc_setup_hardware: failed to setup the connection to host
	...
	[ ] calling  kmemleak_late_init+0x0/0xa0 @ 1
	[ ] kmemleak: Kernel memory leak detector initialized (mem pool available: 14919)
	[ ] kmemleak: Automatic memory scanning thread started
	[ ] initcall kmemleak_late_init+0x0/0xa0 returned 0 after 417 usecs
	[ ] calling  check_early_ioremap_leak+0x0/0x70 @ 1
	[ ] ------------[ cut here ]------------
	[ ] Debug warning: early ioremap leak of 1 areas detected.
	    please boot with early_ioremap_debug and report the dmesg.
	[ ] WARNING: CPU: 11 PID: 1 at mm/early_ioremap.c:90 check_early_ioremap_leak+0x4e/0x70

When early_xdbc_setup_hardware() fails, make sure to call
early_iounmap() since xdbc_init() won't handle it.

Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Fixes: aeb9dd1de98c ("usb/early: Add driver for xhci debug capability")
Link: https://lore.kernel.org/r/20250627-xdbc-v1-1-43cc8c317b1b@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/early/xhci-dbc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/early/xhci-dbc.c b/drivers/usb/early/xhci-dbc.c
index b0c4071f0b16..8963d2b8d8f7 100644
--- a/drivers/usb/early/xhci-dbc.c
+++ b/drivers/usb/early/xhci-dbc.c
@@ -679,6 +679,10 @@ int __init early_xdbc_setup_hardware(void)
 
 		xdbc.table_base = NULL;
 		xdbc.out_buf = NULL;
+
+		early_iounmap(xdbc.xhci_base, xdbc.xhci_length);
+		xdbc.xhci_base = NULL;
+		xdbc.xhci_length = 0;
 	}
 
 	return ret;
-- 
2.39.5



