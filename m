Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96322D7DDB;
	Thu, 30 Jul 2026 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424624; cv=none; b=MWa2mRhuUfD7uFDjVhazecDhQ0+EM0nJBp9Vtbp4qaLzCxNBZ6yEsGza7rz4IJPWrjjFQUnY9rFShQCAaq0rQiMGDRv9pDBEOONw6QOGMxgQ5fzqG+N0zckk9BhJliWiYIRVQs0yze3INy25kn4A4TU7erWTKOjEefz29We0ouA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424624; c=relaxed/simple;
	bh=68ZWgvcMnjgXbAkGzPC5qhy2xP1fs0gDMDywl1ePa0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXb4ETNc/oVt0Rq3mE/w/kY6qog5Cs3tJUabn/tld4FOEqth3gQzyD6iMQTOHjR5adZ45J6CCsmbWJsZO0FP9PYO5TN63Vmn6DSPa4Qs2/Jst3RRvX5FQPpbHSL9k8AA+NMsto4QxVnJFPKyperyPz2gveI7NeOek85dHhLfoWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eu9TBKVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eu9TBKVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AED61F000E9;
	Thu, 30 Jul 2026 15:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424623;
	bh=YiTT8hvL6jdhQbaTLdPk3T2iiHrUws8WakzfwM2k1Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eu9TBKVDlXW4zv7l2CaL2R1eYWfiI6K+xIwzFEccJKIQ1a6ut0PizdomGYEjb6wYI
	 mUYC4Whvh1xyFj1phSU6Y9JQwWCmZnd1gtANSfAa3ehNOG4zHiyjF12gzhmviExoqI
	 L5fejCSHZxT9B/kPy9KQehsMiJzhrN2CqJdPMMjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 415/675] media: nxp: imx8-isi: Fix missing v4l2_subdev_cleanup() in pipe init error path
Date: Thu, 30 Jul 2026 16:12:25 +0200
Message-ID: <20260730141453.952555004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


