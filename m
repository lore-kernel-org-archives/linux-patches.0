Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8625235DA67;
	Thu, 30 Jul 2026 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426150; cv=none; b=tqPn1sXqS82BIZwKrTGEcV9zAAeARCG0LawV82yNZOp9BjsQcf/fIuJ5roehUHRT3q71zh5FVLHK1979fWY6AozuM8oDVx2H0pA/1wTRQoDJRVF/WXkP9UrOZsejXis7GwFSIOhN0gePEjEXkvPgv1ybVtph1eYSQYQTuMgBN4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426150; c=relaxed/simple;
	bh=T+FQynRm4QEw6hMl91VrPlN5Y4z5jwNnFHNtJibsPeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNZdVejdRxVTKMhz2xe3pQvNe6IH5PHtis0WXTOglmKQU691kZmmUQwSqAy8pNRB610wPBLsuQ9mWEz3Rm2gaBByg+9eG6UVIaUJeRD/tUxBAW7NRWoDV0uchOYF+pUL6+3z4+sMVYpTQXbCwmxjbCU82jp+ssqxPIqWaQabb34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sphwf2m3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sphwf2m3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16EE1F000E9;
	Thu, 30 Jul 2026 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426149;
	bh=ridC9I37xDLwwv3zAIK+j3NRJwLZYe58Hpn90HsZdfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sphwf2m32zDBF9hnmEaRmC1jJeHjHSIuB7bXpZQqUcjx3gLqtvhjFN5DgZLkO76Vl
	 PfPO8BKSSTNaV5LYPU8X194Xr/0SJn2qlujF4fwKbx0PDUZXHpWIrOdxL/mh2GLFUM
	 caBam35OBeCxFPHpDVZ8xAxPavn5nCfijJPkwvGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 317/602] media: nxp: imx8-isi: Fix missing v4l2_subdev_cleanup() in pipe init error path
Date: Thu, 30 Jul 2026 16:11:49 +0200
Message-ID: <20260730141442.627826490@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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


