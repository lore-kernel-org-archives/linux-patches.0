Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C476298CC4;
	Tue, 21 Jul 2026 22:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672696; cv=none; b=BkZ2wNEeHlPlyQyOuIhdxYtCu8bHJNvMrOu+AC/Uf/HrP6QYie+uJ19/l88O7Sji+BctJxQW2lfDYEaFDeQkpifS9cW4Jr37Dagf3x6vjR6FdxKvArvCqE6wJ0p/CqDVmQLRNaJyQl61ugSoGS9Rq+7vZ5icQaqPUKfRCSU2uPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672696; c=relaxed/simple;
	bh=0zS8whnGmoqBQHW7NbkCyU94uuMSHi7NemBjms2ZNZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ubp+6h6pRAo8Zt/yl/8GNqQRnCx/4Lyef61Se5O1n5aIPZmEJ1q5yZaVDLl8PnDynoIJItPSPbxF5q9BbXhOxCb+jec7+a8k78JOjewyhGLCA2lj52Xwr5hdYdbk7F1o0UX0JY5AHaKA70sp7j/m4wsJctBb7ZSohxLsdFgl2aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fb7i2eWr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fb7i2eWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EB21F000E9;
	Tue, 21 Jul 2026 22:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672695;
	bh=+x2//r9qZ1wueqPfZ38UFfrpsSs3MaM9uMGVLAngNXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fb7i2eWrnbeK7R10AowvHAy5iLmOSE+V5I5gkzA2CmBIU+/S2vlpCQG2oxo3qYy5J
	 PbhpGYCRI3EIwUyjYE6zX+F9j10BTUQH0I3eabwVpljHNDj+jq5l4ZvD0P9epPgKVA
	 RVE7gyYgXSCZU0dRrJ6bjcSL2EeoCTUFYORXkbtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 5.15 720/843] reset: sunxi: fix memory region leak on ioremap failure
Date: Tue, 21 Jul 2026 17:25:55 +0200
Message-ID: <20260721152422.243619062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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


