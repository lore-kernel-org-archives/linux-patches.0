Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21C1198E60;
	Thu,  6 Jun 2024 14:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682937; cv=none; b=UXncoVmRTGYrQyegFe3m+uoSCAwci7x98DL6MXa8hzgW1NnuTpetpoa4c38HoXUUiR/zURGg5NVhZ47GbyPVO3pjNjF86NmVqlgN/qzmeb/tCRjubSs22GNkXx5O13RsiGovGPDS2WazJdq74tofHuQcuXixInYUrylL5KLHqbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682937; c=relaxed/simple;
	bh=gTBTIlBqeQlslb8qiZd3SiN5z6AR10zkETEabMKdL2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUdt+Scp72I8w/rWIDiy0f66hgjyWPVdzJv4NWkhmzHuFngV+pobk0GBLy3Wd5pAFkoB470xNtq1JFfY/3jBiMG6Eco2/WBdfJhyBjvMKQy4kWAMdTHbPzBD7SCZFy9Phuy4Gg1JpOSZGZshvSRTFdylSY/aFwxQjiC2k14ehy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiaxZFaO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiaxZFaO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D233FC32781;
	Thu,  6 Jun 2024 14:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682936;
	bh=gTBTIlBqeQlslb8qiZd3SiN5z6AR10zkETEabMKdL2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JiaxZFaOwusH6oaCc4ChN0SL9OX72Tuqcduc1OxN8pG3ecHzjs+6DpoTi7XJ+J5HA
	 U/OBGJCCC55PjAuzjqEOy5NeQZti/tw9aCF0yaGWI0w0s4gAblFq+BgM5xp7PH8c5E
	 +PIjVVBuMfAcko/FyeWultY7TypUIGtkMs67QiqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 088/374] ppdev: Add an error check in register_device
Date: Thu,  6 Jun 2024 16:01:07 +0200
Message-ID: <20240606131654.834294209@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index ee951b265213f..58e9dcc2a3087 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -296,28 +296,35 @@ static int register_device(int minor, struct pp_struct *pp)
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



