Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38FD19644B;
	Mon, 24 Feb 2025 14:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408491; cv=none; b=KcDwXWEXsWj171FunDQhuYnHrRna9iA9O5R/mxA6BkncjE0LwRR/uA2HQrjvwxEdc+11vnXOgTxqVFCpmoMnhQKAXy0acSLYpEGIf5REIPohFXUqROD6gWRsVJNyl4x+ngiQu88GQcThAX4szqBa95b6z6Xmht/NshADu8DM+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408491; c=relaxed/simple;
	bh=FS57OQUQK1IAUsjHr6y/CqOZf4S5HjAJcx3xutIWC8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8GaIeubK+Qiu7HMszU231aAafylhUleDa4ozXbqCwj4G1ut3HrnMuI5O2EoTVEIkOU8zSTdwMC0PzOxXsuocTHyZxYtqVhccWjPwg1K3x5s7USJ0Xur9Tm3IxVT4Gbps/bcwE4nUvrLwx8TkLtxyNFlxaW0akPdyryO1r9xMyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rE+JIIgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rE+JIIgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBADC4CED6;
	Mon, 24 Feb 2025 14:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408491;
	bh=FS57OQUQK1IAUsjHr6y/CqOZf4S5HjAJcx3xutIWC8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rE+JIIgnxP85EfyQY3GT2hQ1nTxLxPu0csTUKP5Q8Vjg7VAZQzDwZvMNXtniFFQ9Y
	 vssscEaSIpi3c2OBDLfE905gLRgVVssVjoMlo2tKqH2U2Ghkc8PKP1bjyizLQAnbRF
	 Pue5JRMPCmolOTFpKSQ3sXtfsm8LUkn0I0oj926w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Julian Ruess <julianr@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/154] s390/ism: add release function for struct device
Date: Mon, 24 Feb 2025 15:34:15 +0100
Message-ID: <20250224142609.280849632@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Ruess <julianr@linux.ibm.com>

[ Upstream commit 915e34d5ad35a6a9e56113f852ade4a730fb88f0 ]

According to device_release() in /drivers/base/core.c,
a device without a release function is a broken device
and must be fixed.

The current code directly frees the device after calling device_add()
without waiting for other kernel parts to release their references.
Thus, a reference could still be held to a struct device,
e.g., by sysfs, leading to potential use-after-free
issues if a proper release function is not set.

Fixes: 8c81ba20349d ("net/smc: De-tangle ism and smc device initialization")
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Signed-off-by: Julian Ruess <julianr@linux.ibm.com>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250214120137.563409-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index e36e3ea165d3b..2f34761e64135 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -588,6 +588,15 @@ static int ism_dev_init(struct ism_dev *ism)
 	return ret;
 }
 
+static void ism_dev_release(struct device *dev)
+{
+	struct ism_dev *ism;
+
+	ism = container_of(dev, struct ism_dev, dev);
+
+	kfree(ism);
+}
+
 static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ism_dev *ism;
@@ -601,6 +610,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev_set_drvdata(&pdev->dev, ism);
 	ism->pdev = pdev;
 	ism->dev.parent = &pdev->dev;
+	ism->dev.release = ism_dev_release;
 	device_initialize(&ism->dev);
 	dev_set_name(&ism->dev, dev_name(&pdev->dev));
 	ret = device_add(&ism->dev);
@@ -637,7 +647,7 @@ static int ism_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	device_del(&ism->dev);
 err_dev:
 	dev_set_drvdata(&pdev->dev, NULL);
-	kfree(ism);
+	put_device(&ism->dev);
 
 	return ret;
 }
@@ -682,7 +692,7 @@ static void ism_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	device_del(&ism->dev);
 	dev_set_drvdata(&pdev->dev, NULL);
-	kfree(ism);
+	put_device(&ism->dev);
 }
 
 static struct pci_driver ism_driver = {
-- 
2.39.5



