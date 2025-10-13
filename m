Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B989830AABF;
	Mon, 13 Oct 2025 15:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369486; cv=none; b=Cgl5+SKKhi1g/Re1LlFqH+PwIV6PJrkER0Gmvj0ysHBQqhg5dTAKVtj2hwm59oh3HEbLcQHD6rsvDLVFzDjK/OhPiX4xX0ezzJUL8y9CQA10k09MHJ+uzLDKi/Apgao5PO5VgEiBsBksf0fDZfAH3nD3wMSqY9h5HHYGRPjeMxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369486; c=relaxed/simple;
	bh=HZOlO3XRrXAPkbtCfXbonOBkRqAtcTG+PsDY21kHZec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NA2RszIh3UzaGVTfSxrKrCz6M6ZsfYMTSt1k6j8d39eT7jRyng6WB6gQJ/JM0mrhUv85bp23C8LMAirKeLIhYBvyToFCz68tWDW5lWNwBe2F4p4jFjANBmVWazOxaWGOjVyALOdIjXTZ8GoQLnP6aMx8lfEgB7mbySN8U85NRkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5c4G5Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5c4G5Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43869C4CEE7;
	Mon, 13 Oct 2025 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369486;
	bh=HZOlO3XRrXAPkbtCfXbonOBkRqAtcTG+PsDY21kHZec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5c4G5XhwvMlF5FhWmXCgdoG5cvO8xCw4JA0eIUGlNIpPEg8VniR9hbvyEeSzUiqo
	 FExqSAkLq423uO80ikILayMnG2ofpgCbkykA0dbEUY7GsqMw3NJ+CXVqpMFoDT/99U
	 9xllq6sF430yvyH4GutERfJgXNuLmE1htFA9Z1V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 262/563] media: staging/ipu7: cleanup the MMU correctly in IPU7 driver release
Date: Mon, 13 Oct 2025 16:42:03 +0200
Message-ID: <20251013144420.768944477@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit 01a80b6649e69e4889b8521de022d3ee4bc5cb6f ]

IPU7 ISYS and PSYS auxiliary devices are released after
ipu7_bus_del_devices(), so driver can not reference the MMU devices
from ISYS and PSYS auxiliary devices, so move the MMUs cleanup before
releasing the auxiliary devices.

Fixes: b7fe4c0019b1 ("media: staging/ipu7: add Intel IPU7 PCI device driver")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
[Sakari Ailus: Drop extra newline.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/ipu7/ipu7.c b/drivers/staging/media/ipu7/ipu7.c
index aef931d235108..ee6b63717ed36 100644
--- a/drivers/staging/media/ipu7/ipu7.c
+++ b/drivers/staging/media/ipu7/ipu7.c
@@ -2644,6 +2644,9 @@ static void ipu7_pci_remove(struct pci_dev *pdev)
 	if (!IS_ERR_OR_NULL(isp->fw_code_region))
 		vfree(isp->fw_code_region);
 
+	ipu7_mmu_cleanup(isp->isys->mmu);
+	ipu7_mmu_cleanup(isp->psys->mmu);
+
 	ipu7_bus_del_devices(pdev);
 
 	pm_runtime_forbid(&pdev->dev);
@@ -2652,9 +2655,6 @@ static void ipu7_pci_remove(struct pci_dev *pdev)
 	ipu_buttress_exit(isp);
 
 	release_firmware(isp->cpd_fw);
-
-	ipu7_mmu_cleanup(isp->psys->mmu);
-	ipu7_mmu_cleanup(isp->isys->mmu);
 }
 
 static void ipu7_pci_reset_prepare(struct pci_dev *pdev)
-- 
2.51.0



