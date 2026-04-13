Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C2E2D8364;
	Mon, 13 Apr 2026 16:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098081; cv=none; b=ScRA/CNuBWWKoZRVmNALdqvY9bMc9dUD8kilhltU6hjD7AJkblq/xfvaqyGaG5WA+J0dIwQZ0ulTdaZx5re/GQexqFVzF2d6z1vZov5NowHjA5fUtZDbemqewPnUij5uQiZ8CfJOXIu/vc5hdZ117aBeUaaGb/Eeqrc3Z0c9348=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098081; c=relaxed/simple;
	bh=v6PQ0af9/QMQMsEq6ckC14MX2updPPAWWFRF99ykDCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzyxUESjzqc7ydDYSbqBug2oS3fAqQurEwhY2msDMjcyoiGBny5cabgz3SmvvJsaCHt93JCmRfX8TIUvxM14biN7nPpwnzSKMIytkB0ioiChqNeFrlnzOh5CLrF8zsRNMMg+5RJjKs0IkkEWYr+62LDBvmJmg/4+Vvm6R2uqla8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkH+mRjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkH+mRjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F459C2BCAF;
	Mon, 13 Apr 2026 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098081;
	bh=v6PQ0af9/QMQMsEq6ckC14MX2updPPAWWFRF99ykDCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkH+mRjo8V+vszFHvEVhHtd+EfQc2trd8OLTQdmeVMwVFiNGAm29Z2lhSqWhPiHnn
	 epA25OY72MJjQg1AuMPJnTQTI5dQocBAN/0dpqeYWI+OUCqaa7CdwR3XjM4q3OtK0r
	 wqkGhkAoGc4wKNHTPXdV6vnWZK/phYWwLV25Locc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 386/570] dmaengine: idxd: Fix not releasing workqueue on .release()
Date: Mon, 13 Apr 2026 17:58:37 +0200
Message-ID: <20260413155844.937196566@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index 489a9d8850764..ee208dfdd0cb5 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1271,6 +1271,7 @@ static void idxd_conf_device_release(struct device *dev)
 {
 	struct idxd_device *idxd = confdev_to_idxd(dev);
 
+	destroy_workqueue(idxd->wq);
 	kfree(idxd->groups);
 	kfree(idxd->wqs);
 	kfree(idxd->engines);
-- 
2.53.0



