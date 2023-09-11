Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9C811706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C189C433C7;
	Mon, 11 Sep 2023 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444146;
	bh=GwH/pKxsGl2EJnxf9TIc5vtWrNkaMOmAtcqQkagf7Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJylyhHCtf/jaAqfDVmZB/GU4XIKV3YjHdOPVMni+ingIgYCO4waF0jddVM51aGne
	 478xjMaYvAOAtWw1ETx0oHRYSidzY/tajlz5eR2yiufLcYZYGLXSOZ+PKYG/2SEchJ
	 XEVhr5A1cpqcDbb+TcC2O2npuvNVHfl4HBIZmgaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 627/737] dmaengine: idxd: Allow ATS disable update only for configurable devices
Date: Mon, 11 Sep 2023 15:48:06 +0200
Message-ID: <20230911134708.045102000@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 0056a7f07b0a63e6cee815a789eabba6f3a710f0 ]

ATS disable status in a WQ is read-only if the device is not configurable.
This change ensures that the ATS disable attribute can be modified via
sysfs only on configurable devices.

Fixes: 92de5fa2dc39 ("dmaengine: idxd: add ATS disable knob for work queues")
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230811012635.535413-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index d16c16445c4f9..66c89b07b3f7b 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1088,12 +1088,16 @@ static ssize_t wq_ats_disable_store(struct device *dev, struct device_attribute
 				    const char *buf, size_t count)
 {
 	struct idxd_wq *wq = confdev_to_wq(dev);
+	struct idxd_device *idxd = wq->idxd;
 	bool ats_dis;
 	int rc;
 
 	if (wq->state != IDXD_WQ_DISABLED)
 		return -EPERM;
 
+	if (!test_bit(IDXD_FLAG_CONFIGURABLE, &idxd->flags))
+		return -EPERM;
+
 	rc = kstrtobool(buf, &ats_dis);
 	if (rc < 0)
 		return rc;
-- 
2.40.1



