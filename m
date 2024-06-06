Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5FE1B1406;
	Thu,  6 Jun 2024 14:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683370; cv=none; b=NJptSJExA9S8rQcZhgkSgSJYmfe7BiwYop67wANtzlZKLax6P5obnqV9oWsVmdqsLeYr1+/K2j78QADVusiyg3va4lg39YM31aI6FH/Xdc8a4UN2kcwi5DkKDgA+qZNhn4srfdKS87EoUW/k//coL8sw9puzIkJavXif0dCIb40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683370; c=relaxed/simple;
	bh=YK3zgT4BJiaCGj5ZZ5HPX5fBmdEDKAL2ESToI0HgLTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ+fbueLkHFY3yyMqoM/uW4iVtu2AQ2lsmqol/ftsI4ywWf5R9gQR5RUeZfBc5+F5uEyLht8anU4bhmbUKXUGv3IXG0u4P0lKZY/39LNcTiI3CKnbgiQAhm1pBGnwMzEQRlGFg/oSbINQIKw89NQz1RgaWdWT1ZIaSira6freAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8hq04dK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8hq04dK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53B7C2BD10;
	Thu,  6 Jun 2024 14:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683368;
	bh=YK3zgT4BJiaCGj5ZZ5HPX5fBmdEDKAL2ESToI0HgLTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8hq04dKaMTpwzam/p/fT9hcb7JlEBRns4Ch/c3zuzo6h84v0CTzgPM+BzqxPeNV6
	 TaslFv45UDcnsnsdLCMz+CGRPG8dGyXf15fASW+igttC5BRh/6b/QLVzLd5i3D4Abp
	 4ynosaxADbqAOnAtZDiDX9xUiqyfmV3eI0wTTHbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 310/744] media: ipu3-cio2: Request IRQ earlier
Date: Thu,  6 Jun 2024 15:59:42 +0200
Message-ID: <20240606131742.344870558@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit a069f79bfa6ec1ea0744981ea8425c8a25322579 ]

Call devm_request_irq() before registering the async notifier, as otherwise
it would be possible to use the device before the interrupts could be
delivered to the driver.

Fixes: c2a6a07afe4a ("media: intel-ipu3: cio2: add new MIPI-CSI2 driver")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 5dd69a251b6a9..423842d2a5b2b 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1803,11 +1803,6 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 
 	v4l2_async_nf_init(&cio2->notifier, &cio2->v4l2_dev);
 
-	/* Register notifier for subdevices we care */
-	r = cio2_parse_firmware(cio2);
-	if (r)
-		goto fail_clean_notifier;
-
 	r = devm_request_irq(dev, pci_dev->irq, cio2_irq, IRQF_SHARED,
 			     CIO2_NAME, cio2);
 	if (r) {
@@ -1815,6 +1810,11 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 		goto fail_clean_notifier;
 	}
 
+	/* Register notifier for subdevices we care */
+	r = cio2_parse_firmware(cio2);
+	if (r)
+		goto fail_clean_notifier;
+
 	pm_runtime_put_noidle(dev);
 	pm_runtime_allow(dev);
 
-- 
2.43.0



