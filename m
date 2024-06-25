Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAB014A0B6;
	Tue, 25 Jun 2024 09:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309274; cv=none; b=bWqzqSVn0XaqNTwBY2a+mrhwAsUM4TH9zlLnoLKbPkf1nc995VpiUm+MRN17qnMHMP7r8CQ4eBgjcmuCg58g9UI9fK+xTwzf1Y/FRW5VsJet3UdztkmgHo19eMmCnLZXH7tLqZelyBlt6ODaucuxalTThOi06H+qUxkh9R9kT88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309274; c=relaxed/simple;
	bh=LjHlNsNYqWx6MNrHhYG+zD6ihYo4w2ONlUbnTFSbw7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgGctH+2uWmP6YZaIz6XtHqiMPWPTJaFW7zjFfg6utTsXRtN/TJDKhycwbpntiLiDn6cjyZPQfVCRBQZs8xoZOtqb+mNtlRNTQa3tfOKs/P3iAeYFFNbl8QyDa2RYKCdApPtpwHNiDY29/sKMU6fj90iRvm0V3JbVmSKFbrFTD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHG/nLkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHG/nLkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24245C32781;
	Tue, 25 Jun 2024 09:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309274;
	bh=LjHlNsNYqWx6MNrHhYG+zD6ihYo4w2ONlUbnTFSbw7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHG/nLktj8ERRPDHLE5eqQWxqkgG0dUbJdSj9syq6HIS2qZyNzfMgvvuRnCI5tIvB
	 FebeqMtp2ZiRZPByl6hoqH8Ug0EdLeJ9jUkOEf0s12Box91zD3xqenvSoEarUduJRk
	 W2vkCrUAZUprpenpVY4qh/U2W/kXCIFriQImCPEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Shubin <n.shubin@yadro.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 113/192] dmaengine: ioatdma: Fix missing kmem_cache_destroy()
Date: Tue, 25 Jun 2024 11:33:05 +0200
Message-ID: <20240625085541.511513300@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Shubin <n.shubin@yadro.com>

[ Upstream commit 5422145d0b749ad554ada772133b9b20f9fb0ec8 ]

Fix missing kmem_cache_destroy() for ioat_sed_cache in
ioat_exit_module().

Noticed via:

```
modprobe ioatdma
rmmod ioatdma
modprobe ioatdma
debugfs: Directory 'ioat_sed_ent' with parent 'slab' already present!
```

Fixes: c0f28ce66ecf ("dmaengine: ioatdma: move all the init routines")
Signed-off-by: Nikita Shubin <n.shubin@yadro.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240514-ioatdma_fixes-v1-1-2776a0913254@yadro.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ioat/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/ioat/init.c b/drivers/dma/ioat/init.c
index cf688b0c8444c..e8f45a7fded43 100644
--- a/drivers/dma/ioat/init.c
+++ b/drivers/dma/ioat/init.c
@@ -1449,6 +1449,7 @@ module_init(ioat_init_module);
 static void __exit ioat_exit_module(void)
 {
 	pci_unregister_driver(&ioat_pci_driver);
+	kmem_cache_destroy(ioat_sed_cache);
 	kmem_cache_destroy(ioat_cache);
 }
 module_exit(ioat_exit_module);
-- 
2.43.0



