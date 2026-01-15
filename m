Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33973C1967;
	Thu, 15 Jan 2026 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497938; cv=none; b=vC8t1Bpu5SYQkrdiRepSop3O7yKym+WdY3sj47KgBZKvNCU8k7UY+EdWf9LRrGLz4PWtrIuGByGGfnej48b/MUUod4SbsFyPPosyHhQDWc7CH15BQ2sTRLWITQksmICVYY6cIzxq9Rk4DO/Nvn8BSbtQf/1nJoBawH580HyYLKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497938; c=relaxed/simple;
	bh=G6T1xrVBKMr2ZsAcOA6YZr8VkzAAKKF1rJojfOW/GPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmZSaXkLacLQebG/dz8ePqXcPhB6/oyZdZQEXx5oM19FHspqo7/QSQH7l1lOmT148vQzLCUjhXn+ktg1XfvRMs5aUzp0d+obvb6ojfntI7mfO6mmvCzv59/Rz/+lo5ttySZCQjlxCmdufXnUVqseyBibCxVzy95bA9tL5iqPPdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+b+t4cI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+b+t4cI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8B0C19423;
	Thu, 15 Jan 2026 17:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497938;
	bh=G6T1xrVBKMr2ZsAcOA6YZr8VkzAAKKF1rJojfOW/GPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+b+t4cISxmyEpxAWugkE0kH3arj0igQaWpKn7+qDyoT+Uy29DoG887FWiTAnvtDy
	 qH4sIkjvShDhcfbP5QPJohgyVQNNeYJeqK+Jrbl8V9sDygtB5F7QOxXulusL8DjTQu
	 2QABh4gPak1x9aJBCKEsQvh7fcYCzZsfY9Z/Ati4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Corey Minyard <corey@minyard.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/554] ipmi: Fix __scan_channels() failing to rescan channels
Date: Thu, 15 Jan 2026 17:45:23 +0100
Message-ID: <20260115164255.537154380@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Jinhui Guo <guojinhui.liam@bytedance.com>

[ Upstream commit 6bd30d8fc523fb880b4be548e8501bc0fe8f42d4 ]

channel_handler() sets intf->channels_ready to true but never
clears it, so __scan_channels() skips any rescan. When the BMC
firmware changes a rescan is required. Allow it by clearing
the flag before starting a new scan.

Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Message-ID: <20250930074239.2353-3-guojinhui.liam@bytedance.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 98ccba19292a..d680e4d46992 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -593,7 +593,8 @@ static void __ipmi_bmc_unregister(struct ipmi_smi *intf);
 static int __ipmi_bmc_register(struct ipmi_smi *intf,
 			       struct ipmi_device_id *id,
 			       bool guid_set, guid_t *guid, int intf_num);
-static int __scan_channels(struct ipmi_smi *intf, struct ipmi_device_id *id);
+static int __scan_channels(struct ipmi_smi *intf,
+				struct ipmi_device_id *id, bool rescan);
 
 
 /**
@@ -2543,7 +2544,7 @@ static int __bmc_get_device_id(struct ipmi_smi *intf, struct bmc_device *bmc,
 		if (__ipmi_bmc_register(intf, &id, guid_set, &guid, intf_num))
 			need_waiter(intf); /* Retry later on an error. */
 		else
-			__scan_channels(intf, &id);
+			__scan_channels(intf, &id, false);
 
 
 		if (!intf_set) {
@@ -2563,7 +2564,7 @@ static int __bmc_get_device_id(struct ipmi_smi *intf, struct bmc_device *bmc,
 		goto out_noprocessing;
 	} else if (memcmp(&bmc->fetch_id, &bmc->id, sizeof(bmc->id)))
 		/* Version info changes, scan the channels again. */
-		__scan_channels(intf, &bmc->fetch_id);
+		__scan_channels(intf, &bmc->fetch_id, true);
 
 	bmc->dyn_id_expiry = jiffies + IPMI_DYN_DEV_ID_EXPIRY;
 
@@ -3313,10 +3314,17 @@ channel_handler(struct ipmi_smi *intf, struct ipmi_recv_msg *msg)
 /*
  * Must be holding intf->bmc_reg_mutex to call this.
  */
-static int __scan_channels(struct ipmi_smi *intf, struct ipmi_device_id *id)
+static int __scan_channels(struct ipmi_smi *intf,
+				struct ipmi_device_id *id,
+				bool rescan)
 {
 	int rv;
 
+	if (rescan) {
+		/* Clear channels_ready to force channels rescan. */
+		intf->channels_ready = false;
+	}
+
 	if (ipmi_version_major(id) > 1
 			|| (ipmi_version_major(id) == 1
 			    && ipmi_version_minor(id) >= 5)) {
@@ -3488,7 +3496,7 @@ int ipmi_add_smi(struct module         *owner,
 	}
 
 	mutex_lock(&intf->bmc_reg_mutex);
-	rv = __scan_channels(intf, &id);
+	rv = __scan_channels(intf, &id, false);
 	mutex_unlock(&intf->bmc_reg_mutex);
 	if (rv)
 		goto out_err_bmc_reg;
-- 
2.51.0



