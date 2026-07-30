Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D9143E09D;
	Thu, 30 Jul 2026 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422625; cv=none; b=EvxinB83c/KETikgW2uueSwIsaJbKYltY853OeX2rK/z8zOJynpGk6pbXbWdg0LZOfMldjvyn7wCH3AQp0j35i6i3bkcuMB4AwxdTt+iSPA8/41d72AjVy2aJfC7aQfYwIzi/cltrdTAegnqog9K1wWe7NLGWUk8EuJupGFnMVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422625; c=relaxed/simple;
	bh=nFHd+qSj3NpCmmLQbIQLYzZlii2BtNR6Ram0bwhKGp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSlypPu6LLYfCQYyLnCE/cnvYZWIivL2n+ToIH521HZcv24fwNN+KhyqkZl8rBHVa2pdp8hAkBdqym1wJuuRWl/6l8PQY11M/Ay84HRge6IfFtA0K/QojF6dNUKdN59IJqR4CFCJQKXke5IvRvBQBdLC8tVxeAK8vuzCjeCUYAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFZN49Pa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFZN49Pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C64E1F000E9;
	Thu, 30 Jul 2026 14:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422624;
	bh=4xmtnxzouGg6F7LXT/WZ8hfm90HAoJe2iiBCjO6APqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFZN49Pa+nquAmHKyzneHbNN06bbNjHJrk1IP9tN6nU79z8iXFjspE1GqMr48NApj
	 oFFA3Sed5lZjqs4Ji3rBlKPQVrHmxY1KM5WtchMzx1HRLzC14W959RP0zQ6ei//ddX
	 iJr692unJTYJ9IA18p82MTNCcIP4f8SFLOKGf7fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 500/744] media: nxp: imx8-isi: Fix missing v4l2_subdev_cleanup() in pipe init error path
Date: Thu, 30 Jul 2026 16:12:53 +0200
Message-ID: <20260730141454.913119967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

commit 8262de0663318124824aaafd97ddb5d7bb53bd77 upstream.

After v4l2_subdev_init_finalize() succeeds in mxc_isi_pipe_init(), if
platform_get_irq() or devm_request_irq() fails, the error path jumps to
a label that only calls media_entity_cleanup() and mutex_destroy(),
missing the v4l2_subdev_cleanup() call needed to free the subdev active
state allocated by v4l2_subdev_init_finalize().

Add an error_subdev label that calls v4l2_subdev_cleanup() before
falling through to the existing error cleanup.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260507041318.491594-4-xiaolei.wang@windriver.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
@@ -796,18 +796,20 @@ int mxc_isi_pipe_init(struct mxc_isi_dev
 	irq = platform_get_irq(to_platform_device(isi->dev), id);
 	if (irq < 0) {
 		ret = irq;
-		goto error;
+		goto error_subdev;
 	}
 
 	ret = devm_request_irq(isi->dev, irq, mxc_isi_pipe_irq_handler,
 			       0, dev_name(isi->dev), pipe);
 	if (ret < 0) {
 		dev_err(isi->dev, "failed to request IRQ (%d)\n", ret);
-		goto error;
+		goto error_subdev;
 	}
 
 	return 0;
 
+error_subdev:
+	v4l2_subdev_cleanup(sd);
 error:
 	media_entity_cleanup(&sd->entity);
 	mutex_destroy(&pipe->lock);


