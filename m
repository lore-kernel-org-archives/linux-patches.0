Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529238481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860A0C433EF;
	Fri, 10 Mar 2023 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456904;
	bh=6Gs71kEKBpwp4cOkCn7i/3BhX3OpriQWHrFXzoQuGIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=euI0NRbZ+duDZWbzoxWMOkDj7YIpxZO24W6Ij2ZhlFKFG78h1yLGG/R/ltj5np4d9
	 pHYPZSURzq30avHJYnMFYHt+fD8XARPHihdTEylziCbX1tzV5oWLeZAaz5qrRBuSwL
	 IXS7BJULD8lrch+hCnYya3SVi3t0cyJ8ky1DyQAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 164/211] USB: gadget: gr_udc: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:39:04 +0100
Message-Id: <20230310133723.762008484@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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

[ Upstream commit 73f4451368663ad28daa67980c6dd11d83b303eb ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Jakob Koschel <jakobkoschel@gmail.com>
Link: https://lore.kernel.org/r/20230202153235.2412790-8-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/gr_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/gr_udc.c b/drivers/usb/gadget/udc/gr_udc.c
index 85cdc0af3bf95..09762559912d3 100644
--- a/drivers/usb/gadget/udc/gr_udc.c
+++ b/drivers/usb/gadget/udc/gr_udc.c
@@ -215,7 +215,7 @@ static void gr_dfs_create(struct gr_udc *dev)
 
 static void gr_dfs_delete(struct gr_udc *dev)
 {
-	debugfs_remove(debugfs_lookup(dev_name(dev->dev), usb_debug_root));
+	debugfs_lookup_and_remove(dev_name(dev->dev), usb_debug_root);
 }
 
 #else /* !CONFIG_USB_GADGET_DEBUG_FS */
-- 
2.39.2



