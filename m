Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E74471439;
	Tue, 21 Jul 2026 20:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664223; cv=none; b=lWHHw1x6vSdMpx+GQ/3oN8XWxVOPg17DTQ+jsLuzO69lpR8iT1DDa9FIW5XxSemR9ttW5+qJqfu7ZMIaEQ77T5POuiZTZ34muGKoDp5oajHzyzM02s6tL1Ii1QW7AvhexIb+3EgmHa0Hu/ShG13xNrvcRz3nXySnlF6MrvXalL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664223; c=relaxed/simple;
	bh=O9n4+0xTC81YDYNNuKyh4XUA65M4dehBkLr1CjJjCow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhQVNRitM85ttlVeUE9UY57pLOeJ+D2VM6ua3fS3L7/qQXsFQ2wUBBDtgJXMyukTEtg51JmX3/NM7IHnTNfsP2cs/aUOJj9XRxXFf4FHZNyHZfM7lEcBJ9korQbhWs5hzyxKieHCFv6eQY6pqvo8qAd0W/15tH5e+C7eGBTa/vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VajlXBgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VajlXBgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467381F000E9;
	Tue, 21 Jul 2026 20:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664220;
	bh=7h4yuBmJFccKLh5D8rOf/oGVOanzBiu3NIKuJZctolA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VajlXBgdHELdtTLo2vqMOqGClu5ccxFJuzSlRbd+l2qUgvieAQMLJejWBzSHlLk6/
	 R/+OgEHFQWJwLCAfFrXeQqkNVZ9iOi0HwfqmOtWO/2OPjnZoBtMcrU8sp6CfZpb//7
	 QlS+4M1uDWNxqJFxs7LOoO7+quwZ1oYbyVN4QhSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 6.12 1119/1276] reset: sunxi: fix memory region leak on ioremap failure
Date: Tue, 21 Jul 2026 17:26:02 +0200
Message-ID: <20260721152511.037058936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit 1a8c89f8c112c75e84ff9a140f969e372aed0c9a upstream.

In sunxi_reset_init(), when ioremap() fails, the memory region obtained
via request_mem_region() is not released, leading to a resource leak.

Add an err_mem_region label to properly release the memory region before
freeing the data structure.

Fixes: 8f1ae77f4666 ("reset: Add Allwinner SoCs Reset Controller Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/reset-sunxi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/reset/reset-sunxi.c
+++ b/drivers/reset/reset-sunxi.c
@@ -44,7 +44,7 @@ static int sunxi_reset_init(struct devic
 	data->membase = ioremap(res.start, size);
 	if (!data->membase) {
 		ret = -ENOMEM;
-		goto err_alloc;
+		goto err_mem_region;
 	}
 
 	spin_lock_init(&data->lock);
@@ -57,6 +57,8 @@ static int sunxi_reset_init(struct devic
 
 	return reset_controller_register(&data->rcdev);
 
+err_mem_region:
+	release_mem_region(res.start, size);
 err_alloc:
 	kfree(data);
 	return ret;


