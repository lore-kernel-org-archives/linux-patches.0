Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154068481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872E3C433EF;
	Fri, 10 Mar 2023 14:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457127;
	bh=sJZDY+aWkKUI3CILtPsReX7IbCQldm3Pb8oHvdYdd3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV/iB/cdE5HQ74Ir7hO587KZ1wRNVHXKWc1KMVqxGiUe8t00lj2ZZLjj3zWB+TA/T
	 RKYRB+y0MNWgHDWVMxmvY5sF8gwbPOfxI4gPg5e1EzJ9ytomvofJMD9qsMJXn4AEfe
	 Gw6HU7+1qFXgtPPWciIQGiIiUC4NpOA0cVv1PKJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/200] driver: soc: xilinx: fix memory leak in xlnx_add_cb_for_notify_event()
Date: Fri, 10 Mar 2023 14:36:51 +0100
Message-Id: <20230310133717.191068505@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 1bea534991b9b35c41848a397666ada436456beb ]

The kfree() should be called when memory fails to be allocated for
cb_data in xlnx_add_cb_for_notify_event(), otherwise there will be
a memory leak, so add kfree() to fix it.

Fixes: 05e5ba40ea7a ("driver: soc: xilinx: Add support of multiple callbacks for same event in event management driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20221129010146.1026685-1-cuigaosheng1@huawei.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/xlnx_event_manager.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/xilinx/xlnx_event_manager.c b/drivers/soc/xilinx/xlnx_event_manager.c
index 2de082765befa..c76381899ef49 100644
--- a/drivers/soc/xilinx/xlnx_event_manager.c
+++ b/drivers/soc/xilinx/xlnx_event_manager.c
@@ -116,8 +116,10 @@ static int xlnx_add_cb_for_notify_event(const u32 node_id, const u32 event, cons
 		INIT_LIST_HEAD(&eve_data->cb_list_head);
 
 		cb_data = kmalloc(sizeof(*cb_data), GFP_KERNEL);
-		if (!cb_data)
+		if (!cb_data) {
+			kfree(eve_data);
 			return -ENOMEM;
+		}
 		cb_data->eve_cb = cb_fun;
 		cb_data->agent_data = data;
 
-- 
2.39.2



