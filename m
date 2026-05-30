Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059ED352027;
	Sat, 30 May 2026 18:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164576; cv=none; b=Z3/CI7IfD0ApGQcDcfr8aWc95FaGsmbjZxu3orMlknNEg9By9VmVga+qKELQQ1zF8hqFRNMXZ12A/X9lev8hbItyIBb7DYROBvr8O+Rm9q1U6SeQ5qdg8x0OWcFznRHxXiH+LsSJrTovySQmbqN8om4k/WQWUCsvNQHOK40mD5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164576; c=relaxed/simple;
	bh=ZKK3F09yfSWmPtOd4ldtn53QhvKgIuXjTMkWYBLr144=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9SzZYo/y/7L86Ym8NJIRmDNKncH/Hcbhnnt++JOu6X1gmqoi4RcT6pYSKR3n5Oys9FoLCDw3zGBiQUt5CYvE0xIIJoN8T00GXYT+zbNFFKEC92cyOksGeIhR5c0LMYAoY84WzzrnZre2m1LLd48uFKOr9SbE/SEBjvMeeq9rxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2jPsQN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2jPsQN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E511F00893;
	Sat, 30 May 2026 18:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164574;
	bh=6Nmhb5ugOixm76Kmg1xvhOfLCyvLHdACjolDLvEndEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2jPsQN0MwtkP3H9H8NH11Bhm+O045a5RwbE7D5UwFmmDxTqYBJQ5pT19O5FY3LSC
	 7M41h1PCGLXT51viqViJ5Kw2IckhgO6kq+CGyJ/j6P6WF6SnSTk5cGPk+enr2zClZB
	 euO7d2Bu+ZfrHPR4vqArDCZrFdkxkqKk7oTe/AMI=
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
Subject: [PATCH 5.15 596/776] fbdev: offb: fix PCI device reference leak on probe failure
Date: Sat, 30 May 2026 18:05:10 +0200
Message-ID: <20260530160255.445766387@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



