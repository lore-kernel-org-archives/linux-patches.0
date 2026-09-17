Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70A650B418;
	Thu, 17 Sep 2026 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664015; cv=none; b=CV0uiJTYAVC+bYgUF4tKtulNe0ITYjaT+xJYrsrZYVxVuQcTJnGEZagur4rO9PoyUuH6OJIjxf4aNmhbaKdnIFRGvs8B4jFmWc7tnRTquYg9XK0W+4ZXb9gNVRsozgQeRVwGoEIUVq9fqE240/Y4ykMGJm9XOynZPS9wc7l7Xec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664015; c=relaxed/simple;
	bh=+HNlX5cbLcEakTjWNPZYTK6dYX1t9P70RvFQ86oK2qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWr6jNqlcyU7nDd5qo9x1/BiU/Pn0lYDDaey2HNH8Hudb1ItR4gh7F8PLDcXNV37QhQQLZqTZ+boFN80UjQDifAJksIrKd9zqURkfafRpf2hDAJ53tVS71Wj8KBV0P4J/pAcIvnpRF7p6zNqPuyOdnZt9Hrda454Vjxt0MzChtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZAZaqZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZAZaqZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABBC1F000FF;
	Thu, 17 Sep 2026 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664013;
	bh=PW/Wlmr68L8euhXy3MdQydMvVjcEnpijBmJvl8YWRAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZAZaqZYdmQnqtL2GbqzLOFP6KvnxK4mUdzznnB5loC1xsH8orky3qRq7wImurTCz
	 WJcUJxx08qCSrJaf3LUMvd8Y4bcoD4389F0ga6BoA7ekWMP9bQrFI8LTgjigbQUffM
	 DrNzS5Yrj6AWyutIWG9YN7amKZaU2jZ4IIW2S3vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0230/1250] net: thunderx: fix PTP device ref leak in nicvf_probe()
Date: Thu, 17 Sep 2026 16:00:25 +0100
Message-ID: <20260917151558.376077794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 2bcf59eefb9f00a2b1d426b639ee49c305a80695 ]

cavium_ptp_get() acquires a reference to the PTP PCI device
through pci_get_device(). If any initialization step fails
after cavium_ptp_get(), the PTP PCI device reference is leaked.
Add a common error path to release the PTP reference before
returning from probe failures.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20260525082611.61817-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 1be2dc40a1a63..e4dfd5cc15802 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2104,8 +2104,10 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	err = pci_enable_device(pdev);
-	if (err)
-		return dev_err_probe(dev, err, "Failed to enable PCI device\n");
+	if (err) {
+		err = dev_err_probe(dev, err, "Failed to enable PCI device\n");
+		goto err_put_ptp;
+	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
@@ -2259,6 +2261,8 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_release_regions(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
+err_put_ptp:
+	cavium_ptp_put(ptp_clock);
 	return err;
 }
 
-- 
2.53.0



