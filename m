Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA97D1E500C;
	Tue, 12 Aug 2025 18:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023477; cv=none; b=ZUIL/mKvtDG61mag7929fQfeM49HxMFr8CFGWXmIPYtqgVCUUTsGrzw8HDaM5qiGFXknQtU/VB0dRPFj1L6NYSDSx0f24G/Kybo8xO4KHWguYu3WetvCH+XnrCznTrizByPXVq2mCAxRYS7rC/Uv8K8sItgE2y98zO/BqYHQmus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023477; c=relaxed/simple;
	bh=h0hgFh+Lg88gRqLx4SWLh/iUhnLNt4dsfhFH5NAKENo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4t0+hbc+5NDEpiRPz5GNv3Nk46yNFdlWA3fcFaH9Njlz2pBifJnhBAUz94iNcPaG5Xp6FyoUVRN8+/BDbqNYlNZ473mYscSP6mjxEFJOBk3N5Nq58ox2WVjPO+aMYGm746XZBfLdId1GaBVWau/km/DO2YlpQDjLA5MIuJh7Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyGeINki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyGeINki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4598BC4CEF0;
	Tue, 12 Aug 2025 18:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023477;
	bh=h0hgFh+Lg88gRqLx4SWLh/iUhnLNt4dsfhFH5NAKENo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyGeINkiGlhBFn3dJiHh72uif0FuFNfiROekbLGJ8k3aGVfLR9BUxFRWDRDM1q/PY
	 n18VBIrJdZOPVtCbI+IypiTYo2hUbi1alsbCPLKVUGJbRRX6ne9D/uf4eUP+5feYEx
	 IvkSuYvWQiI15LtHHD4Fr5o06TcI2BQGUZ1Qoob4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 090/627] usb: early: xhci-dbc: Fix early_ioremap leak
Date: Tue, 12 Aug 2025 19:26:25 +0200
Message-ID: <20250812173422.733482328@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 341408410ed9..41118bba9197 100644
--- a/drivers/usb/early/xhci-dbc.c
+++ b/drivers/usb/early/xhci-dbc.c
@@ -681,6 +681,10 @@ int __init early_xdbc_setup_hardware(void)
 
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



