Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36600342CA7;
	Tue, 26 Aug 2025 14:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217287; cv=none; b=GsLw4H20J8WcXZHP/t/Xaxfa8q705b55Jreg5zECB9wkRx9ScO6i672pfCJ8KAH41Grstu6VwshKEsBjvg7It9vrJ2wEOcYRHi1Z2Fxa0KkCsxK8EzNirl5iT+e+syVa1vF4nT2Qv9Y63Vdw3VqIVa9CGmZclBdJYS8TUjW781I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217287; c=relaxed/simple;
	bh=ckKSXb9uDHQGtor+t12RmAzhWFr42scmMcYyrSuOrto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRVxxeM30IMdkw1Jgw3ubyAIuEPNzHxhLfWrUYzny04DyDHns3D1m04fqwVafHBgv8kuSxmyWAsHwgjEDywmgaJ5T+tDBmaNzng0yDRJhQFpb0AzevqVFzozid8DknxxxGAw8FMIcokf8xGC0oPGYmYjUrf+eEmCLL38HbAO5P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v4f2cmni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v4f2cmni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE99C116B1;
	Tue, 26 Aug 2025 14:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217287;
	bh=ckKSXb9uDHQGtor+t12RmAzhWFr42scmMcYyrSuOrto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v4f2cmni6Qxx/qjHRqdoJ4vHyIs4vVqOmTYRiCxibREgO5CTqk6C5uCqYcbQDwBVM
	 c2Y/3Id5RVqt+FMjra2sgRafvBJFISyIjhfnrJn3aWoSSr7O44JYIFZD/2+q8VC0I2
	 Sr4z4MQKFc9JsBZUU4x4A/AsrCIzTEDwHVujTUsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/523] usb: early: xhci-dbc: Fix early_ioremap leak
Date: Tue, 26 Aug 2025 13:04:56 +0200
Message-ID: <20250826110926.676553132@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
index 6c0434100e38..7f832c98699c 100644
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



