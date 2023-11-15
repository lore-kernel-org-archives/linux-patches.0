Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66E9364CB
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmsvLXbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52303C433C9;
	Wed, 15 Nov 2023 19:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077738;
	bh=XyLRX7fIKiK36NwH7UgisMhcnHzlJUh4fJaITunIiAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmsvLXbOrXG7sDQlHzqOIpS2JGURynYzN+2ecJ3uNvN2wZjvGvLcM/JgEwAo0gYST
	 N+Qb3CfQsuob1/zNIIkEqvWK7S46PrAnZBJIxkfv+lHM9TgLPP4AfznMfND1ZweQ4E
	 DrsrgvmCyesQaOUFdBXvhqbygfePljz1R7Q/3/Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 488/603] cxl/pci: Remove unnecessary device reference management in sanitize work
Date: Wed, 15 Nov 2023 14:17:13 -0500
Message-ID: <20231115191646.109823308@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 76fe8713dd0a1331d84d767e8e5d3f365d959e8a ]

Given that any particular put_device() could be the final put of the
device, the fact that there are usages of cxlds->dev after
put_device(cxlds->dev) is a red flag. Drop the reference counting since
the device is pinned by being registered and will not be unregistered
without triggering the driver + workqueue to shutdown.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 5f2da1971446 ("cxl/pci: Fix sanitize notifier setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pci.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 44a21ab7add51..aa1b3dd9e64c4 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -152,8 +152,6 @@ static void cxl_mbox_sanitize_work(struct work_struct *work)
 	mutex_lock(&mds->mbox_mutex);
 	if (cxl_mbox_background_complete(cxlds)) {
 		mds->security.poll_tmo_secs = 0;
-		put_device(cxlds->dev);
-
 		if (mds->security.sanitize_node)
 			sysfs_notify_dirent(mds->security.sanitize_node);
 
@@ -296,9 +294,6 @@ static int __cxl_pci_mbox_send_cmd(struct cxl_memdev_state *mds,
 		 */
 		if (mbox_cmd->opcode == CXL_MBOX_OP_SANITIZE) {
 			if (mds->security.poll) {
-				/* hold the device throughout */
-				get_device(cxlds->dev);
-
 				/* give first timeout a second */
 				timeout = 1;
 				mds->security.poll_tmo_secs = timeout;
-- 
2.42.0



