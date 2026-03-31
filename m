Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36231311592;
	Tue, 31 Mar 2026 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976934; cv=none; b=nM4Nh7AGDQ1N5693LrCmQq5/jTy2NYRasgrH54v2IRacmuGe6HTUO6ts5olhntucHLe5Ke5LLKsqPaSPzrS1xvIo4/uSAncTZDKgufZw9kXG9nm1C7Ag//01lScgGzguDkxQb2Gfuz3OrvOnRJc1+7DEUbsjewoyM44XZqO+lKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976934; c=relaxed/simple;
	bh=zHIhrC4qjL40FU1ZWl/LUcSnmX69jAYX2dQ2SWr9WJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBQbVwUZpfHk0006kwiyPu6N2PQ8sgLwyzvQJ6iWLICJGKRFdqToYJjzfb3og901IxQpAbGZQLn53tioCiQ3xzN6tZMMdqHHrHnLO2dBpRPRvKD3DuCeqN+9Tzfgbdg4Rk/QWSOaCpHlZUaDiUHyY4ge0PREsA3cVxxYTJvPZg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWWcj6gJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWWcj6gJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A4EC19423;
	Tue, 31 Mar 2026 17:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976934;
	bh=zHIhrC4qjL40FU1ZWl/LUcSnmX69jAYX2dQ2SWr9WJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWWcj6gJBRxWDwozF+1uNTQC8CBf9t8KDvzLe2+6LrasrPcv9KLhdiXEbuN3N2KuQ
	 5w8VMSg82oZgH13DQTd09X1Hdj+6UXXvHqXeQ1jjjQrjMV6PQ/VZ0/FWRCTTPOufIu
	 QbpY5HGDM9cpJt2oGhLUTi+LmruZpNaioN9Wq90M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 285/309] dmaengine: idxd: Fix not releasing workqueue on .release()
Date: Tue, 31 Mar 2026 18:23:08 +0200
Message-ID: <20260331161804.059628262@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 3d33de353b1ff9023d5ec73b9becf80ea87af695 ]

The workqueue associated with an DSA/IAA device is not released when
the object is freed.

Fixes: 47c16ac27d4c ("dmaengine: idxd: fix idxd conf_dev 'struct device' lifetime")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-7-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 9f0701021af0e..cdd7a59140d90 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1812,6 +1812,7 @@ static void idxd_conf_device_release(struct device *dev)
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
+	destroy_workqueue(idxd->wq);
 	kfree(idxd->groups);
 	bitmap_free(idxd->wq_enable_map);
 	kfree(idxd->wqs);
-- 
2.53.0



