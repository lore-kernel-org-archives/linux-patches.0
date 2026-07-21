Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15D4399015;
	Tue, 21 Jul 2026 22:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674509; cv=none; b=QCFKyV7hvRvT6UhdTF8ZUgN2HFdU+ksnQpnHVqQkevZb8AqhkCSzhTIvE2Dlu0knRK5Q5afG0LbCMhpKutZjBx9jMyewxILAe6hkkIreBlpMQDLabcawW7EtCs47FEWi202hP0gqE8kulqeLiLVq2Vrw3dilLtyemE8NFqJnpyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674509; c=relaxed/simple;
	bh=8EZgz9+UWCIELY3emokiX2zk7Xj2ZPAKF5gWYtoHatE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5DTj/+qYajHXBboj8zBNJHepRD37mBFCCB8lqjStwobeuYUyiYcKPxs9YgEhaYqXjqBCx1r/4/VXnprTTmDpfhf/ApA+wxU4qaw8rjMmhnqdmX6LwZ9I5HShLB7rUguT5lfYGGRlC4TRZ8ZfEsL1kdbMnKxwiIuq+4EFuzD2R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frLaLhQ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frLaLhQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338641F000E9;
	Tue, 21 Jul 2026 22:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674508;
	bh=KzKP5fnrm0kkq8l44wnNQaXX1pMOTWj3wnhPLCa2vyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frLaLhQ7etLmlA00OgCTEHvQCq9ZWqik0o8TdFOkW2bBDtGmf4Dt8ZtFEMR+4vQ33
	 /n7TUSEuVNrADBtDfXICRCQ7gbF5tDOuiNG+oXwWVEX+6MzA6RM3shvvNGT1RRvDb4
	 GkJwvQdKS7+Txr9pdWvqROxl9NkQJJiNSIpEGyfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: [PATCH 5.10 568/699] reset: sunxi: fix memory region leak on ioremap failure
Date: Tue, 21 Jul 2026 17:25:27 +0200
Message-ID: <20260721152408.522744360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


