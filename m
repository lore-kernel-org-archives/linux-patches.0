Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69B24676B;
	Tue, 20 May 2025 14:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749892; cv=none; b=RDRKF3aMNNFqvNVtq0mTMrgclC66Hh5+WBrZuwHFuvDEi4M7K/CHEz8EKoEZlFkkHr+LE875iJx3/j0feXorl0bn8qDkUF08UM3mqj2xgYJmVIIg0flsGmb09WeUZHIIQnklarnmkelkF+lV/7ROcdEV2AWqmfQeu/iFmwG4xn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749892; c=relaxed/simple;
	bh=Yr7NEAiFJmijdxDK2tj0bd577Jdr/FPnqBwHcHe3HHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HmqEAcV1UrkhLcv2HaXKEZq6PVrFJ1oF5c1Hb4I/cf5z6MUgDmU1LnNsES83W7nN8qYBJ3SHUIoFVO8AEQ+xaSFkLrOCPSMXhn86FF6eFhstbqBUC+QWaWE1C9U4VzcDZfieZIsLKsmrqk2cRtXjUCTlRDCsusiZR4ZwOqFQrtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8TEzbgj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8TEzbgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9BBC4CEEA;
	Tue, 20 May 2025 14:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749892;
	bh=Yr7NEAiFJmijdxDK2tj0bd577Jdr/FPnqBwHcHe3HHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8TEzbgjG4E7S1r6ge6LFM5L9BaNYCSlJyyf76YqSixkAUnSsuc8551UW1fVHKH3m
	 qZPUJeEkQ7KPiLnBls0R1d8+47xt0wTCujpRXQOH6q2Gyv+wCto/LXowh9HU8cHjI4
	 Bonj9dHi28gKhQtd3X2gYthB3si6LR1OGxRBCniQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 094/117] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_wqs
Date: Tue, 20 May 2025 15:50:59 +0200
Message-ID: <20250520125807.716653780@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 3fd2f4bc010cdfbc07dd21018dc65bd9370eb7a4 upstream.

Memory allocated for wqs is not freed if an error occurs during
idxd_setup_wqs(). To fix it, free the allocated memory in the reverse
order of allocation before exiting the function in case of an error.

Fixes: 7c5dd23e57c1 ("dmaengine: idxd: fix wq conf_dev 'struct device' lifetime")
Fixes: 700af3a0a26c ("dmaengine: idxd: add 'struct idxd_dev' as wrapper for conf_dev")
Fixes: de5819b99489 ("dmaengine: idxd: track enabled workqueues in bitmap")
Fixes: b0325aefd398 ("dmaengine: idxd: add WQ operation cap restriction support")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Link: https://lore.kernel.org/r/20250404120217.48772-2-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -159,8 +159,8 @@ static int idxd_setup_wqs(struct idxd_de
 
 	idxd->wq_enable_map = bitmap_zalloc_node(idxd->max_wqs, GFP_KERNEL, dev_to_node(dev));
 	if (!idxd->wq_enable_map) {
-		kfree(idxd->wqs);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto err_bitmap;
 	}
 
 	for (i = 0; i < idxd->max_wqs; i++) {
@@ -179,10 +179,8 @@ static int idxd_setup_wqs(struct idxd_de
 		conf_dev->bus = &dsa_bus_type;
 		conf_dev->type = &idxd_wq_device_type;
 		rc = dev_set_name(conf_dev, "wq%d.%d", idxd->id, wq->id);
-		if (rc < 0) {
-			put_device(conf_dev);
+		if (rc < 0)
 			goto err;
-		}
 
 		mutex_init(&wq->wq_lock);
 		init_waitqueue_head(&wq->err_queue);
@@ -193,7 +191,6 @@ static int idxd_setup_wqs(struct idxd_de
 		wq->enqcmds_retries = IDXD_ENQCMDS_RETRIES;
 		wq->wqcfg = kzalloc_node(idxd->wqcfg_size, GFP_KERNEL, dev_to_node(dev));
 		if (!wq->wqcfg) {
-			put_device(conf_dev);
 			rc = -ENOMEM;
 			goto err;
 		}
@@ -201,9 +198,8 @@ static int idxd_setup_wqs(struct idxd_de
 		if (idxd->hw.wq_cap.op_config) {
 			wq->opcap_bmap = bitmap_zalloc(IDXD_MAX_OPCAP_BITS, GFP_KERNEL);
 			if (!wq->opcap_bmap) {
-				put_device(conf_dev);
 				rc = -ENOMEM;
-				goto err;
+				goto err_opcap_bmap;
 			}
 			bitmap_copy(wq->opcap_bmap, idxd->opcap_bmap, IDXD_MAX_OPCAP_BITS);
 		}
@@ -214,12 +210,28 @@ static int idxd_setup_wqs(struct idxd_de
 
 	return 0;
 
- err:
+err_opcap_bmap:
+	kfree(wq->wqcfg);
+
+err:
+	put_device(conf_dev);
+	kfree(wq);
+
 	while (--i >= 0) {
 		wq = idxd->wqs[i];
+		if (idxd->hw.wq_cap.op_config)
+			bitmap_free(wq->opcap_bmap);
+		kfree(wq->wqcfg);
 		conf_dev = wq_confdev(wq);
 		put_device(conf_dev);
+		kfree(wq);
+
 	}
+	bitmap_free(idxd->wq_enable_map);
+
+err_bitmap:
+	kfree(idxd->wqs);
+
 	return rc;
 }
 


