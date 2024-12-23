Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA4E7E0FF;
	Mon, 23 Dec 2024 16:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970389; cv=none; b=OyvHPewYibGjAKN9CXl24vnWYSw0cI/uK9ZcYDNHmZ9wTpLercHSkTnYa1BDJ3oxfJCecZZL+MiV6RNtx4jMy4CTSOBaknTjDHQUWklQScnlFWY87wcYhqvorp/YswarIlQOdkoIfSHQ39+9hwDIOwygmiZ2QoqNfiMfUVovn70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970389; c=relaxed/simple;
	bh=YoFy0nkjFEywrECaM/z6KwwoqOIUPbjhtO211Hx8gSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BF+F3CYwWzLT0EaIjq456BSOzam9u7X6Ftccb5HHnXgHJrl6eaMgRL7+ahDxJvYux/SwlJL2AkNa6c3/Ja8zcRMjEuZoh3Uu9Lj5ch+kQ2LKcp43j3dMvaFjubkuyamBXXXOKgunZtU3sFT2UBs6Wk1lVycgLD0DLnXNlkLkzjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkqH47zx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkqH47zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75087C4CED3;
	Mon, 23 Dec 2024 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970388;
	bh=YoFy0nkjFEywrECaM/z6KwwoqOIUPbjhtO211Hx8gSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkqH47zxX2P+2fO73BKl7p+YY6QZxa/iHQjSrxYjfb/Nk+L9E5GS+mLtxdznvDouE
	 dxMc8PaRPD8gfx3I/VfAX0rATZ936a60mzR3YvBS3NHZCc21cRKiohfAPzrvxzCEwi
	 g+GyiVKjKCQS4c+hfnSY7WN8kG5dKedpnnHyB1yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ni <fan.ni@samsung.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/116] cxl/pci: Fix potential bogus return value upon successful probing
Date: Mon, 23 Dec 2024 16:58:27 +0100
Message-ID: <20241223155401.012691227@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit da4d8c83358163df9a4addaeba0ef8bcb03b22e8 ]

If cxl_pci_ras_unmask() returns non-zero, cxl_pci_probe() will end up
returning that value, instead of zero.

Fixes: 248529edc86f ("cxl: add RAS status unmasking for CXL")
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/20241115170032.108445-1-dave@stgolabs.net
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 8bece1e2e249..aacd93f9067d 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -911,8 +911,7 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		return rc;
 
-	rc = cxl_pci_ras_unmask(pdev);
-	if (rc)
+	if (cxl_pci_ras_unmask(pdev))
 		dev_dbg(&pdev->dev, "No RAS reporting unmasked\n");
 
 	pci_save_state(pdev);
-- 
2.39.5



