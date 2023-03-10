Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CFD8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70545C433D2;
	Fri, 10 Mar 2023 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457480;
	bh=KRBEIVoE9JmHAOpRSWS3UjsvllJYFulQOA9LVXLoDQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/r+Phzg9cs90lNnmKAPKm6F46KsPF7WJY6qnxh6BjGqGTI9cCMDa8r3CZ3a/3qCG
	 hF3RN/3lZlRoA39YKH1H2dx1XVs+fOCghJO4f9TM70k5bnyrMjNfy+XiijJX2UbIi1
	 0Cc3rW8/Sxudku0L5qNHj645RjmuOWfmnvVMt030=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Cernekee <cernekee@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/200] USB: gadget: bcm63xx_udc: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:39:19 +0100
Message-Id: <20230310133721.796514904@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit a91c99b1fe5c6f7e52fb932ad9e57ec7cfe913ec ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Kevin Cernekee <cernekee@gmail.com>
Link: https://lore.kernel.org/r/20230202153235.2412790-9-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/bcm63xx_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/bcm63xx_udc.c b/drivers/usb/gadget/udc/bcm63xx_udc.c
index d04d72f5816e6..8d58928913007 100644
--- a/drivers/usb/gadget/udc/bcm63xx_udc.c
+++ b/drivers/usb/gadget/udc/bcm63xx_udc.c
@@ -2258,7 +2258,7 @@ static void bcm63xx_udc_init_debugfs(struct bcm63xx_udc *udc)
  */
 static void bcm63xx_udc_cleanup_debugfs(struct bcm63xx_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(udc->gadget.name, usb_debug_root));
+	debugfs_lookup_and_remove(udc->gadget.name, usb_debug_root);
 }
 
 /***********************************************************************
-- 
2.39.2



