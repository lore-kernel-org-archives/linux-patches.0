Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C289F34FF79;
	Tue, 16 Jun 2026 18:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634774; cv=none; b=clH/2PABaha90/Xmg23MuvNsphSyIsaVK3X8AxUbiwOl8T9tIA6gx0kX1SDUlDXVSAd1UDi4XH9nevYbpGP0p6ujMmlSdgUvDuF/abbY8xWESFhfK7LaFQ7/tuQX5xb38lFEMKGyhsHXaAEd4xuZnUwLGKGQ2DEtufT96XidCDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634774; c=relaxed/simple;
	bh=U7AsURxa5ZqxmcO1Gc6Lmx93jvKGAOQQ59vhcCbpXtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcYh0AHOd4VydVJQu/NVJiP6ugGeNhQmLLaM6alQ83hYpBQ9meP2L2TICudjIccR8zZCIYgCUyDdVbMKI2MBMfNlTp7vgngICvAKHUAxZSx/6WW026oxskQdMdjszJTnmcqoWUaY1dNF+I/JUdndT0rG+QsS0pqv+eei29u1KE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKUsm6jm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKUsm6jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874DA1F000E9;
	Tue, 16 Jun 2026 18:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634773;
	bh=a7p4sCgW/NMzlR/wLScdfovi7I3jiqw57WDPaZgHD88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKUsm6jmJVl2nOoH3QF3T3OGLeRgpk9vljikXgefjVQEOx19f7Vj992x92NqLupCa
	 gxfsb+E0fktru4FE7e56iBSDiMtXGffWSnZptsH2kle/DzjZkMtFUXUbhYaII5hgWc
	 6ky6pppOO+g/Ct2Q6IgYU9OtKSfI4SwFk6E98AMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/411] scsi: sd: Add error handling support for add_disk()
Date: Tue, 16 Jun 2026 20:28:54 +0530
Message-ID: <20260616145116.888978054@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 2a7a891f4c406822801ecd676b076c64de072c9e ]

We never checked for errors on add_disk() as this function returned
void. Now that this is fixed, use the shiny new error handling.

As with the error handling for device_add() we follow the same logic and
just put the device so that cleanup is done via the scsi_disk_release().

Link: https://lore.kernel.org/r/20211015233028.2167651-2-mcgrof@kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 1e111c4b3a72 ("scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3458,7 +3458,13 @@ static int sd_probe(struct device *dev)
 		pm_runtime_set_autosuspend_delay(dev,
 			sdp->host->hostt->rpm_autosuspend_delay);
 	}
-	device_add_disk(dev, gd, NULL);
+
+	error = device_add_disk(dev, gd, NULL);
+	if (error) {
+		put_device(&sdkp->dev);
+		goto out;
+	}
+
 	if (sdkp->capacity)
 		sd_dif_config_host(sdkp);
 


