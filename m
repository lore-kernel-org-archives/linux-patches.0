Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28D811706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:55:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C26C433C7;
	Mon, 11 Sep 2023 14:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444143;
	bh=scqkK/qOpKSoQ4s0N5RAxFLmQEWPokkUkjnBAmlBWEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJdYG1HslPchI+q9WPN9mVoFS6Zs62sx+3nX1aNu3WTg86iWbYGR0iIak/Hw6VwG8
	 TNF1hCyoL+XY6+iJRVGwdXXQZ2iWd3xSVZdK6qQWMtuFAnZ45y/R2yl9wnwLpx5XQi
	 bJzkzHMshYqnm36+XIlWoZzwfS5rMMdnx7A+hf0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 626/737] dmaengine: idxd: Expose ATS disable knob only when WQ ATS is supported
Date: Mon, 11 Sep 2023 15:48:05 +0200
Message-ID: <20230911134708.016312236@linuxfoundation.org>
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

[ Upstream commit 62b41b656666d2d35890124df5ef0881fe6d6769 ]

WQ Advanced Translation Service (ATS) can be controlled only when
WQ ATS is supported. The sysfs ATS disable knob should be visible only
when the features is supported.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230712174436.3435088-2-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 0056a7f07b0a ("dmaengine: idxd: Allow ATS disable update only for configurable devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 36a30957ac9a3..d16c16445c4f9 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1088,16 +1088,12 @@ static ssize_t wq_ats_disable_store(struct device *dev, struct device_attribute
 				    const char *buf, size_t count)
 {
 	struct idxd_wq *wq = confdev_to_wq(dev);
-	struct idxd_device *idxd = wq->idxd;
 	bool ats_dis;
 	int rc;
 
 	if (wq->state != IDXD_WQ_DISABLED)
 		return -EPERM;
 
-	if (!idxd->hw.wq_cap.wq_ats_support)
-		return -EOPNOTSUPP;
-
 	rc = kstrtobool(buf, &ats_dis);
 	if (rc < 0)
 		return rc;
@@ -1316,6 +1312,9 @@ static umode_t idxd_wq_attr_visible(struct kobject *kobj,
 	if (idxd_wq_attr_invisible(prs_disable, wq_prs_support, attr, idxd))
 		return 0;
 
+	if (idxd_wq_attr_invisible(ats_disable, wq_ats_support, attr, idxd))
+		return 0;
+
 	return attr->mode;
 }
 
-- 
2.40.1



