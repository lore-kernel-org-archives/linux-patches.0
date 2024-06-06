Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CEB19AD62;
	Thu,  6 Jun 2024 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683335; cv=none; b=PPUW8MCwowpB5DegvtWSFDNQgOr3ncyl+O1KyAmgoqyEIEndbwyoIoWklni82hmGaBfAe67cMHgjxB6OLFjnsrRy1ue42LqgPGiGaJpNwsbxY2p9vP1dnDeNhjOGUWPpPo2V9mHZYvIKiGj0z/yN1F/RpLTpzoFA4xFqD29nvec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683335; c=relaxed/simple;
	bh=v7asjrtK06xf2SanxW5oQdTvlD2hL8E9lwLXcUxRoFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LB+dlfH5BzBYB7YLtZi6anAA/iYTdfpEJaQIRVoKKPGoECzpRe1YeWkgZ1l5DaAwHm/5Bx50O5W0ccby5BX5I7CMfoenjY1T//nSgxIJoTrCAr0WO3fLY98mJMCmASDTYR8QYxWKPn3Qg3XUoI62+OmqjglPrQooxOSSspDxxa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbdfAgyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbdfAgyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C91C2BD10;
	Thu,  6 Jun 2024 14:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683335;
	bh=v7asjrtK06xf2SanxW5oQdTvlD2hL8E9lwLXcUxRoFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbdfAgyFyYLDzs3Lq2WnIBd0Gk6h+QuvOEar2zDZKly2/t4+LJRq70t+yDA6CBXKo
	 F8W7FblLbTuV91PQJp+oY7F3J1QIFy8B0W8lYaXtM4+2qB1KalJj+MjryTBkun7i+r
	 v7D8VJou5cg/symcPOUYkKZWeSA/VX92I/lqo/DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/473] media: ipu3-cio2: Request IRQ earlier
Date: Thu,  6 Jun 2024 16:02:26 +0200
Message-ID: <20240606131707.079157682@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c b/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
index 1bbe58b24d99d..2ae7130880533 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
@@ -1798,11 +1798,6 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 
 	v4l2_async_nf_init(&cio2->notifier);
 
-	/* Register notifier for subdevices we care */
-	r = cio2_parse_firmware(cio2);
-	if (r)
-		goto fail_clean_notifier;
-
 	r = devm_request_irq(dev, pci_dev->irq, cio2_irq, IRQF_SHARED,
 			     CIO2_NAME, cio2);
 	if (r) {
@@ -1810,6 +1805,11 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
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



