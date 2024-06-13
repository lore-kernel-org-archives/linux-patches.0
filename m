Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD2B143878;
	Thu, 13 Jun 2024 11:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278885; cv=none; b=Gy0Dbom0ZeiJ1W0YxAzwYYGQTEfKxk46CKXKTk5WXEvEwhFGx11TOqZ4PLsr6+p9IxNX9n/RwHaooXs4mUFaE5TrYnmq9zf5+Irk+AlQNTIIurGy5DZM1L+iXHagThJS4m1iFb+jk6IMgzYczI6NK8c4OFw38t4xXVK+7tRPgXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278885; c=relaxed/simple;
	bh=Y5CHcKxbOvzrlvl4HNHQWpVL5Djn4PbP/Y6s92vwzzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0MJIarJUw8NcZGgdclosaCx6anpbnj+wLTGpbs+YlX2x17i/DLB8e1t7lGOH2ftmhxt17p8Qur/VVsOLKibCU5oxPcMlezfG3nbgUD9kymNzScFk3g3iSlLskweo0UWFTWNYh205RQ3jST1SICysoiZGoKuUEWmurjjGkEt0nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGtXE8RD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGtXE8RD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9688C2BBFC;
	Thu, 13 Jun 2024 11:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278885;
	bh=Y5CHcKxbOvzrlvl4HNHQWpVL5Djn4PbP/Y6s92vwzzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGtXE8RD4L5Np2x/SuqeC/Q4ZoXukEhsctu9OaJHNNBoqVDOxzFZE+Txa39Fw9ycY
	 IVFDr4GeFQWfPu7kKAhFaGvWRLb3n0JsYg+Ii9QIv+3dVs/8Spl5U0Qjh6d1mnVN1e
	 0eUqEfyOTU6O7AmwnOslfeEgvgrzd94/nA5aI9UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/213] ppdev: Add an error check in register_device
Date: Thu, 13 Jun 2024 13:32:30 +0200
Message-ID: <20240613113231.940681999@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huai-Yuan Liu <qq810974084@gmail.com>

[ Upstream commit fbf740aeb86a4fe82ad158d26d711f2f3be79b3e ]

In register_device, the return value of ida_simple_get is unchecked,
in witch ida_simple_get will use an invalid index value.

To address this issue, index should be checked after ida_simple_get. When
the index value is abnormal, a warning message should be printed, the port
should be dropped, and the value should be recorded.

Fixes: 9a69645dde11 ("ppdev: fix registering same device name")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
Link: https://lore.kernel.org/r/20240412083840.234085-1-qq810974084@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ppdev.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index af74b05d470c3..6422a184a58aa 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -300,28 +300,35 @@ static int register_device(int minor, struct pp_struct *pp)
 	if (!port) {
 		pr_warn("%s: no associated port!\n", name);
 		rc = -ENXIO;
-		goto err;
+		goto err_free_name;
 	}
 
 	index = ida_alloc(&ida_index, GFP_KERNEL);
+	if (index < 0) {
+		pr_warn("%s: failed to get index!\n", name);
+		rc = index;
+		goto err_put_port;
+	}
+
 	memset(&ppdev_cb, 0, sizeof(ppdev_cb));
 	ppdev_cb.irq_func = pp_irq;
 	ppdev_cb.flags = (pp->flags & PP_EXCL) ? PARPORT_FLAG_EXCL : 0;
 	ppdev_cb.private = pp;
 	pdev = parport_register_dev_model(port, name, &ppdev_cb, index);
-	parport_put_port(port);
 
 	if (!pdev) {
 		pr_warn("%s: failed to register device!\n", name);
 		rc = -ENXIO;
 		ida_free(&ida_index, index);
-		goto err;
+		goto err_put_port;
 	}
 
 	pp->pdev = pdev;
 	pp->index = index;
 	dev_dbg(&pdev->dev, "registered pardevice\n");
-err:
+err_put_port:
+	parport_put_port(port);
+err_free_name:
 	kfree(name);
 	return rc;
 }
-- 
2.43.0



