Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F78262A6;
	Tue, 31 Mar 2026 16:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975488; cv=none; b=RwlZSK1Lr6E83AcVNXJkW5ctJvm0EZa+I8OJtp14lj4SgGBe7ZfCqN+hGDOgbuTudJTlHupq5j8TDwpLy5zpR+xx/oQAzZIVc+N6dfAZSsRG3chIjb/OQ6NHobX1AdTkPFN50XVeqkteO6PHtdLNYs/HDdzS43nVrvbvI+IC8xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975488; c=relaxed/simple;
	bh=EFJSi+l/gkEYO9/uSnE79an/Xpxt9EZVFkq9S6vW/n8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcErwllpe5tVMY6p2CVs+/AqMIfUc+JOdYx/dH2jvaJJjfRYspPS+PAXc7i4XKlwHsdFBw53+XVDg+rM9gyoTdDummI4GqurY2JJtA/WstRRSAPQSlFCVWL18eh4440JNTrLCX8xqVJwS4R+PhFK6iHSD4odOBgsu+lR77EDSOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJJbz8zk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJJbz8zk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB39C19424;
	Tue, 31 Mar 2026 16:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975487;
	bh=EFJSi+l/gkEYO9/uSnE79an/Xpxt9EZVFkq9S6vW/n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJJbz8zkzit+kGPVT9NJLXLiESWIeDRqBRmAIggkhDvSevcRplWbAo4qqxXCZSZoM
	 CtqpdEPdZFwNXGRZmtEeR/zh5zuDcvACCcXL3MPl94HKI7mOF9FXP2KdoE5+Onm+kq
	 IXmLv9/8+7orGCyda3mt2SXsgfkvmzhUjXD/dFsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 315/342] dmaengine: idxd: Fix not releasing workqueue on .release()
Date: Tue, 31 Mar 2026 18:22:28 +0200
Message-ID: <20260331161810.513225488@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



