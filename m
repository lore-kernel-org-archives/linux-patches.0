Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08FC171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F2BC433A4;
	Mon,  8 May 2023 11:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546205;
	bh=k4AN3KzYgRmYY0mmsAwEA6dQroTIOnFgjuf0g8VCZKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOVDEmQqO+VmhJ6YFnEP+uxNBAuow0758rMlwGhV/FHmguifaocTJnUXF548bo4Ht
	 8rwohIWGUj9wKRFfhjOcGdFw3Mx1Ox98vuEIJlUKPX6hPFYUoMiyJlwYUEhIPE2zgu
	 resXKFnD2rK4d9NsjbrYAfQnNxRO+p+cJAssNhCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 262/371] HID: amd_sfh: Add support for shutdown operation
Date: Mon,  8 May 2023 11:47:43 +0200
Message-Id: <20230508094822.466359363@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 1353ecaf1830d6d1b74f3225378a9498b4e14fdd ]

As soon as the system is booted after shutdown, the sensors may remain in
a weird state and fail to initialize. Therefore, all sensors should be
turned off during shutdown.

Fixes: 4f567b9f8141 ("SFH: PCIe driver to add support of AMD sensor fusion hub")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index f17f061aeb792..6ff8f254dc840 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -351,6 +351,14 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	return devm_add_action_or_reset(&pdev->dev, amd_mp2_pci_remove, privdata);
 }
 
+static void amd_sfh_shutdown(struct pci_dev *pdev)
+{
+	struct amd_mp2_dev *mp2 = pci_get_drvdata(pdev);
+
+	if (mp2 && mp2->mp2_ops)
+		mp2->mp2_ops->stop_all(mp2);
+}
+
 static int __maybe_unused amd_mp2_pci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -420,6 +428,7 @@ static struct pci_driver amd_mp2_pci_driver = {
 	.id_table	= amd_mp2_pci_tbl,
 	.probe		= amd_mp2_pci_probe,
 	.driver.pm	= &amd_mp2_pm_ops,
+	.shutdown	= amd_sfh_shutdown,
 };
 module_pci_driver(amd_mp2_pci_driver);
 
-- 
2.39.2



