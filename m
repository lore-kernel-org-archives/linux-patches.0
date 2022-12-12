Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74B128ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50C7C433D2;
	Mon, 12 Dec 2022 13:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852556;
	bh=fxdGncPSS8b9gX0+dSdEQDo5IGcISDZYEcPCnTvxkq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EajIbkX7FphVsf+H6osTT8EasGlvmK3D+MzRh5s/CDS2+w4tY+qBB4ivpBj1/PR5Z
	 3jmOfLJD0qufGgjYB7v0OhJjg8zCbzyFjDhucdyuUG1+0gbOulLEPC5+qP2yHp+H95
	 to9jjS+MKjfsuJk7ynO1o3Xc5rBuMJW5dtcZP0NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronak Doshi <doshir@vmware.com>,
	Guolin Yang <gyang@vmware.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 105/157] vmxnet3: use correct intrConf reference when using extended queues
Date: Mon, 12 Dec 2022 14:17:33 +0100
Message-Id: <20221212130939.060027397@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ronak Doshi <doshir@vmware.com>

[ Upstream commit 409e8ec8c5825591895937b8499b54aa2476fae7 ]

Commit 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")
added support for 32Tx/Rx queues. As a part of this patch, intrConf
structure was extended to incorporate increased queues.

This patch fixes the issue where incorrect reference is being used.

Fixes: 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index dd4fecbd1e2e..c28c4a654615 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -75,8 +75,14 @@ vmxnet3_enable_all_intrs(struct vmxnet3_adapter *adapter)
 
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_enable_intr(adapter, i);
-	adapter->shared->devRead.intrConf.intrCtrl &=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl &=
 					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl &=
+					cpu_to_le32(~VMXNET3_IC_DISABLE_ALL);
+	}
 }
 
 
@@ -85,8 +91,14 @@ vmxnet3_disable_all_intrs(struct vmxnet3_adapter *adapter)
 {
 	int i;
 
-	adapter->shared->devRead.intrConf.intrCtrl |=
+	if (!VMXNET3_VERSION_GE_6(adapter) ||
+	    !adapter->queuesExtEnabled) {
+		adapter->shared->devRead.intrConf.intrCtrl |=
 					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	} else {
+		adapter->shared->devReadExt.intrConfExt.intrCtrl |=
+					cpu_to_le32(VMXNET3_IC_DISABLE_ALL);
+	}
 	for (i = 0; i < adapter->intr.num_intrs; i++)
 		vmxnet3_disable_intr(adapter, i);
 }
-- 
2.35.1



