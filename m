Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B4814A60F;
	Sat, 30 May 2026 18:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166739; cv=none; b=a5OPXBj5RJBUqYGG6dPleMRxl2Vyt0hXaw18F65qxgGtLouOtvtLWu7fZN0Ij0eAjuFURio4qxTiL7sdQk6dChz+FYJpuKzo0qcKv6wlkce2zk7HdgC2avJL2psd9Q/vYp/KzPC35Viop1VHQPUM7x/k4mj+dPEPH3q+VUSe8YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166739; c=relaxed/simple;
	bh=KXBV+hFkwlr/uM47tM5bmt85IImYrTPIBtLf1nZ76F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kR7Lta3BNTcTOcw+wS4lnu6neOSqi1+FYwlFuIOoCTwrZQXvOPzwVS/9WBSZbbk+MBCXe14qX/D0QSqslvo/Tge9pJjq2hLWq1yiHcYU2mY+9/KOoDg9+fGk/TEK+f8lt89XTWFc+q+9TVvhxZn9QA0/LySeXanl6grcaHXq5AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thaCVbcK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thaCVbcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92D31F00893;
	Sat, 30 May 2026 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166738;
	bh=MJuzegkXvfK5JeAUxfhI17AlzW/5fxKjZyzrQVqn2AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thaCVbcKPfw3wH5F8CX/DJcdBTT6mhj1zz8Lt0+SYfxDb0Fv0qI1qy2ewk0QSBbg4
	 X4K0hcqwBzdsqts8+qWzvq+vo0pl+g0so1R0hLFeJ0rxIbAmt0VeyIQFBwynbWSq7d
	 7B83GXjd5uoNDue4PHpJvvGmrELDgb6TQjhDAfJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Ijae Kim <ae878000@gmail.com>,
	Taegyu Kim <tmk5904@psu.edu>,
	Yuho Choi <dbgh9129@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 456/589] fbdev: offb: fix PCI device reference leak on probe failure
Date: Sat, 30 May 2026 18:05:37 +0200
Message-ID: <20260530160236.667209066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 869b93ba04088713596e68453c1146f52f713290 ]

offb_init_nodriver() gets a referenced PCI device with pci_get_device().
If pci_enable_device() fails, the function returns without dropping that
reference.

Release the PCI device reference before returning from the
pci_enable_device() failure path.

Fixes: 5bda8f7b5468 ("video: fbdev: offb: Call pci_enable_device() before using the PCI VGA device")
Co-developed-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Co-developed-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/offb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/offb.c b/drivers/video/fbdev/offb.c
index 4501e848a36f2..593aad22248e6 100644
--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -643,8 +643,13 @@ static void __init offb_init_nodriver(struct device_node *dp, int no_real_node)
 			vid = be32_to_cpup(vidp);
 			did = be32_to_cpup(didp);
 			pdev = pci_get_device(vid, did, NULL);
-			if (!pdev || pci_enable_device(pdev))
+			if (!pdev)
 				return;
+
+			if (pci_enable_device(pdev)) {
+				pci_dev_put(pdev);
+				return;
+			}
 		}
 #endif
 		/* kludge for valkyrie */
-- 
2.53.0



