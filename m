Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6A415B2E9;
	Mon, 29 Jan 2024 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548231; cv=none; b=DRXhp+tqvKq2qzDpd73E8MB+4zT0x5uiCbpk/G6hwDCQbeYcrtuqkPwxDvU1JjcDBS5iCmTuplslycHtHerU+eoTK1J04thKPCLbj5OY1RT9ygp2jYNO94eLGE4LoJngI3a62BYUK4zmemiZHE000X616PZo3dzXz/bzLmCISRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548231; c=relaxed/simple;
	bh=OmMktoRcYxEhir6eFTetgo4LVFCh1hjtczzWVNM5J0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZfcPqT1SdRpIXC6iVGf8wT3+6XnuWnwwZYI6s07/NKsqOBCQtEftVhZrctBnH5rkFWIsOhqd7f4g5fRpTZSvp048nFczK5/BgEOZjbIq5TIyxMRagLPPaxCoeAJRxmfp/VtboJZ9/fiNoyJjfHsfv8lEEBpiNlySulFDWanyJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W38FEI2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W38FEI2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253A0C43390;
	Mon, 29 Jan 2024 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548231;
	bh=OmMktoRcYxEhir6eFTetgo4LVFCh1hjtczzWVNM5J0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W38FEI2bNqHWcOuzltYp3FzMiZDBV1Ch9gXL4P5khi+1P0O/65k75ILhLbVNjMhAY
	 o2bpD9z5LCpsjSicgDESm+w2p+4utcnQqIYdHSeeWmneNOD6QsRL8KDfIXMDpCFtP3
	 EhLt8gI3KOfAw4Nt3VxWeJAZnmi0w5StHGC1lziw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 234/346] hv_netvsc: Calculate correct ring size when PAGE_SIZE is not 4 Kbytes
Date: Mon, 29 Jan 2024 09:04:25 -0800
Message-ID: <20240129170023.287091557@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

commit 6941f67ad37d5465b75b9ffc498fcf6897a3c00e upstream.

Current code in netvsc_drv_init() incorrectly assumes that PAGE_SIZE
is 4 Kbytes, which is wrong on ARM64 with 16K or 64K page size. As a
result, the default VMBus ring buffer size on ARM64 with 64K page size
is 8 Mbytes instead of the expected 512 Kbytes. While this doesn't break
anything, a typical VM with 8 vCPUs and 8 netvsc channels wastes 120
Mbytes (8 channels * 2 ring buffers/channel * 7.5 Mbytes/ring buffer).

Unfortunately, the module parameter specifying the ring buffer size
is in units of 4 Kbyte pages. Ideally, it should be in units that
are independent of PAGE_SIZE, but backwards compatibility prevents
changing that now.

Fix this by having netvsc_drv_init() hardcode 4096 instead of using
PAGE_SIZE when calculating the ring buffer size in bytes. Also
use the VMBUS_RING_SIZE macro to ensure proper alignment when running
with page size larger than 4K.

Cc: <stable@vger.kernel.org> # 5.15.x
Fixes: 7aff79e297ee ("Drivers: hv: Enable Hyper-V code to be built on ARM64")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20240122162028.348885-1-mhklinux@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -44,7 +44,7 @@
 
 static unsigned int ring_size __ro_after_init = 128;
 module_param(ring_size, uint, 0444);
-MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
+MODULE_PARM_DESC(ring_size, "Ring buffer size (# of 4K pages)");
 unsigned int netvsc_ring_bytes __ro_after_init;
 
 static const u32 default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE |
@@ -2805,7 +2805,7 @@ static int __init netvsc_drv_init(void)
 		pr_info("Increased ring_size to %u (min allowed)\n",
 			ring_size);
 	}
-	netvsc_ring_bytes = ring_size * PAGE_SIZE;
+	netvsc_ring_bytes = VMBUS_RING_SIZE(ring_size * 4096);
 
 	register_netdevice_notifier(&netvsc_netdev_notifier);
 


