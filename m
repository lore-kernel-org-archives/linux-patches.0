Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3313F3F5BE1;
	Wed, 20 May 2026 17:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296739; cv=none; b=gU6+Uwn3K9MsIjzg5koGcQIsEFGfSjEkIiFQeEInXnpOHCyVx/0+du/zI6JCQonwmi90zxOsvdfCCGDvgsc9/xW42qNUrZ9oMgWbzCnqsfv89dN+tqQHJsn4jSDxBsPytdqNKJ/5sKXR8x8x8arwtYRbt9kCZFvmY308pNm7jRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296739; c=relaxed/simple;
	bh=yzNR0C4IXfNev++BZGPzgRqSPFm51P+M50kPgdt3mTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gH2xLz9E5qaH4JF5Ci6hl/Ce7jBJ3Jfaz83k9AvzV/5U1/GJUveSUi8BLa//Ax2BV2z4dABk1EfPYLegFIsl9EqQKcUp6xmLjyOgukEgNChWIIwbt2hG5cqhs6jqGrzUK8fXK9zG20f4yiub8fFbkfAE4VZiU+82WQzJXjPzSbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJim5LcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJim5LcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2E91F000E9;
	Wed, 20 May 2026 17:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296738;
	bh=dF50Bn1nbC7lGgPmjkdwg2NA8RMrr/zyAJ2sosmdOgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJim5LcZnXl1NdcvsWEzVgYDmqAPTPPLuVtXiabmaeHXWq5OwC+oHzta/1VXmkumz
	 XSXLxPfOt8uaqYpDLNnYTyrd3IevfuQKlNK4MSMVdz1fPCFc77Kdn8QSN4nxChKyzx
	 v0iWfnTwn4QsI2tCmvArfHm6Rhm/BDvYb8OhQzD4=
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
Subject: [PATCH 7.0 0872/1146] fbdev: offb: fix PCI device reference leak on probe failure
Date: Wed, 20 May 2026 18:18:42 +0200
Message-ID: <20260520162207.972538216@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index f85428e13996b..166b2dff36f59 100644
--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -640,8 +640,13 @@ static void offb_init_nodriver(struct platform_device *parent, struct device_nod
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



