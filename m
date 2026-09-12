Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA011288B9;
	Sat, 12 Sep 2026 16:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231176; cv=none; b=XRl1d7ZCDpMSJ7sy9MErp4EwIiNkWU7eSe7UwU6reyx76lX7mZOb9BLGQOqRXWarENLa1Qs36Y9kBRWxRmG4V5Tp3Iox2legMmJTi0mjhfI9zhs6u80J2RFsS4nV/igVX/od2N3i8KaQKTkBnlE3Pncx2WyMh3412gd4S6JzjO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231176; c=relaxed/simple;
	bh=RLvoT5Tyj8ogIukoE77/aGuJfkGQodIbR5pBgchzluA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+qLnDzL8zIfndMSTNuj05tZtrcfJt2fpg6NfkPGKRhj2QLBIkgWwq7u6XWeesOlCwacHXoRDT94JRlQf0dJ5U3SEkpc3Hq+yNHDFkPf3U4SP9ToQ71QmGm3TCWpBTBM39eDOrdO23B1d4QCaSm94kv4iB5N4mrA+ns9AfQkXGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1H+OVU1D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1H+OVU1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EE51F000FF;
	Sat, 12 Sep 2026 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231175;
	bh=a5OtlSpa9wNolxrN9ZOrPrIjN9aJMmR2WCkERmqg2wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1H+OVU1DUrEqdp6IcHX3YNc95tqD5JVZZ8HjYWCkwVwWyE2ePrVgTz64OOX5JawTe
	 A0Bx0L6+UO1ok9HSwBVYg2BeYmYp3P+lWTtCEs9vmU3QCvErixJLtN/o3fC71wMmYN
	 GD2EZCIHOtUy9ij4RCw6y1vARYcIvkDe0j/UVOrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0945/1191] fbdev: tdfxfb: fix PCI enable cleanup with pcim_enable_device()
Date: Sat, 12 Sep 2026 09:01:13 +0200
Message-ID: <20260912065609.449507889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 95a627143a696f70e17be5ed3b1e733bb6724b46 ]

tdfxfb_probe() enables the PCI device with pci_enable_device(), but
several failure paths after that point return without disabling it. The
framebuffer_alloc() failure path returns -ENOMEM directly, and the later
shared out_err path releases the framebuffer and returns -ENXIO without
balancing the PCI enable state.

The successful probe path has the same imbalance because tdfxfb_remove()
releases the framebuffer, mappings and regions, but never calls
pci_disable_device().

Use pcim_enable_device() so the PCI device is disabled automatically on
probe failure and driver detach.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/tdfxfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/tdfxfb.c b/drivers/video/fbdev/tdfxfb.c
index 5554e9ec3d005..2fa4a45c3926c 100644
--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1384,7 +1384,7 @@ static int tdfxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		return err;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		printk(KERN_ERR "tdfxfb: Can't enable pdev: %d\n", err);
 		return err;
-- 
2.53.0



