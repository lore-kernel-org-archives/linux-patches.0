Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DF27EEE7;
	Wed, 21 Feb 2024 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522200; cv=none; b=AWGjs6vnaUOg5spPvbI/MJN4kagNZK9EEhlMqheWCL69OxwYGWolcctYE+EKd7H8dz1AeXmlDMyP32Tx3dHrUn0F2MCjbV9MEJJFt4HJhG+hTWhs4o+XsQDkRKpW1bSZ8caIuSoPZSh7YHEW3faRIR/M+fGzmXCvYeO9S+IZFRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522200; c=relaxed/simple;
	bh=ppGXb7+LrvHzmpghAraMwVs6vMM5O7tzPB1FA/cDzn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hfy6TTL5kEO2ZICggfCSGPjQLp3ZdUvnM0WeAawfw32cmP73yKsEy7TzJV2yxZRLSl5+pKMdPqqUT9Moa7iGOFybfCzjv1sMNKD//8G9tRM74sn+8lXaVNtb2+RqVyWiA4MdlR/zGdAJczw8+/gIfPgEs1x+nxyGMTQZkQ8fXLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaXOzRMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaXOzRMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6127DC43390;
	Wed, 21 Feb 2024 13:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522200;
	bh=ppGXb7+LrvHzmpghAraMwVs6vMM5O7tzPB1FA/cDzn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaXOzRMltcEcmx/Gx5KXcnDdxV6pOvCmxJNcjpwSJf8Wc5sxuirqxH+YyvE+3Ds+1
	 sjzvRdr8pGpcFbJxkSYfQQPcDz4O2yOk37+t02cckamWIMckEoOh++Wo8qzJSXgtZP
	 w1DNihoyG3FJuJlHla9rJtBE1xcBtEVjIpKxUTpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 085/476] hv_netvsc: Calculate correct ring size when PAGE_SIZE is not 4 Kbytes
Date: Wed, 21 Feb 2024 14:02:16 +0100
Message-ID: <20240221130011.132590394@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2824,7 +2824,7 @@ static int __init netvsc_drv_init(void)
 		pr_info("Increased ring_size to %u (min allowed)\n",
 			ring_size);
 	}
-	netvsc_ring_bytes = ring_size * PAGE_SIZE;
+	netvsc_ring_bytes = VMBUS_RING_SIZE(ring_size * 4096);
 
 	register_netdevice_notifier(&netvsc_netdev_notifier);
 


