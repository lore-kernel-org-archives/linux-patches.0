Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83DC1CAA79;
	Tue, 20 May 2025 14:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750826; cv=none; b=R+pDk8fofORjTyhCUUy+kv3k5a7L8/+2mHKVateXQcMwQLZ04872ep1vYzGHgwUB0OJ3mV05R5HBBxFkOTpnXvfvuw/jTtfI6Q5For9Q+NkfzkGxHok7o3ymwOFjuqr9l28FcbbsV0GRpjcfl1SY/8ZMS6h4lSVJ/xN3w/1IgZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750826; c=relaxed/simple;
	bh=pWKNPPzDfeX3BP0oShF8ce9WUjuUdSJ4L88zBIXRbuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVDL6/H9n4HSA85F2XyU5c3tRENXOeds0Dhjt1QvTVNokMlMx60QTAxTYnYq1qElXu2mxhzcnOY4sL27enDSpIC7nUx8B2db0gjQs53b1+gMK92XcZugE1lSR1TrVDNJ5tw+FVV5GwR7P6dApBHPCUWJf8ur54KYitqTWxTYOZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qU87ONQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qU87ONQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CCCC4CEE9;
	Tue, 20 May 2025 14:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750826;
	bh=pWKNPPzDfeX3BP0oShF8ce9WUjuUdSJ4L88zBIXRbuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qU87ONQrxpxUHujHQkUAwI1+yYDhU6gXdzYx6UvLZoTkE+RfhXmKzregFCs3qTaTM
	 DAQy+frdsZTGymcRsgfE3ljTY0tggzkbBxnoizRbXhsKAPOxKzWg7AQAwuLSQVZkG1
	 4Nee9BbUnbfrir3mXoeeGdFANfq3Grb9fP+g7izc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.14 133/145] dmaengine: idxd: fix memory leak in error handling path of idxd_alloc
Date: Tue, 20 May 2025 15:51:43 +0200
Message-ID: <20250520125815.748399310@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 46a5cca76c76c86063000a12936f8e7875295838 upstream.

Memory allocated for idxd is not freed if an error occurs during
idxd_alloc(). To fix it, free the allocated memory in the reverse order
of allocation before exiting the function in case of an error.

Fixes: a8563a33a5e2 ("dmanegine: idxd: reformat opcap output to match bitmap_parse() input")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Link: https://lore.kernel.org/r/20250404120217.48772-7-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -604,28 +604,34 @@ static struct idxd_device *idxd_alloc(st
 	idxd_dev_set_type(&idxd->idxd_dev, idxd->data->type);
 	idxd->id = ida_alloc(&idxd_ida, GFP_KERNEL);
 	if (idxd->id < 0)
-		return NULL;
+		goto err_ida;
 
 	idxd->opcap_bmap = bitmap_zalloc_node(IDXD_MAX_OPCAP_BITS, GFP_KERNEL, dev_to_node(dev));
-	if (!idxd->opcap_bmap) {
-		ida_free(&idxd_ida, idxd->id);
-		return NULL;
-	}
+	if (!idxd->opcap_bmap)
+		goto err_opcap;
 
 	device_initialize(conf_dev);
 	conf_dev->parent = dev;
 	conf_dev->bus = &dsa_bus_type;
 	conf_dev->type = idxd->data->dev_type;
 	rc = dev_set_name(conf_dev, "%s%d", idxd->data->name_prefix, idxd->id);
-	if (rc < 0) {
-		put_device(conf_dev);
-		return NULL;
-	}
+	if (rc < 0)
+		goto err_name;
 
 	spin_lock_init(&idxd->dev_lock);
 	spin_lock_init(&idxd->cmd_lock);
 
 	return idxd;
+
+err_name:
+	put_device(conf_dev);
+	bitmap_free(idxd->opcap_bmap);
+err_opcap:
+	ida_free(&idxd_ida, idxd->id);
+err_ida:
+	kfree(idxd);
+
+	return NULL;
 }
 
 static int idxd_enable_system_pasid(struct idxd_device *idxd)


