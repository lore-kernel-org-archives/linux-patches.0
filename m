Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4C630C618;
	Thu, 30 Jul 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424619; cv=none; b=r2zY5k5IpZU5HCTX4yu08JQLd7ro443Ean315G7O+OldU14IAQhceZ8UEEe2HMYorkt3It81NfMQ2qPm61u4PqsjCDN6SuuZWcJ3Zz3dfvYnL/x7xqWchtV1UvrARWWb0aTbX74WQMMANbCvoDFVDeFZihsmuj/zSKSvkbTN8Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424619; c=relaxed/simple;
	bh=scKoOQJ1v3OIAUZv//SL5+1e3AYrSavlcm6TeCBE/+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdwomoU3bpK7KmgIShQzrbpxB9R9/mbDGUQ7Ke5f0MIP0egFn+7pPP1FXyfYJPg+31GbQA17MHndKdcOsLWbmQ6uqCgpSY2W2QwEHw7WpLqdnLS4O2/NWq32621ekM2SiSuY2fJtL+Bm2xsrmBVSwQLvXtTkENcmdghIyfkbjDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqAX/qwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqAX/qwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB261F000E9;
	Thu, 30 Jul 2026 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424617;
	bh=/P7DiGIsHhc2/8wgAum3zu7WYf9f83/GGUQ0MZGO+yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqAX/qwSJO+L2w7YbuiEZUxp9Hi5780NX4RNXzk67w8U9FDzu6p8RbItFgBycbvRQ
	 Vh+tOlIh2C3eoCYgovuM2Um+DitPeLcvtvVqJF4pstjZ5aK2m/OY+HhWi+diSuT7qj
	 8I/yyBOfg+b5GomlWhSVp3n9e/PQSBooROITQkUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Frank Li <Frank.Li@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 413/675] media: nxp: imx8-isi: Add missing v4l2_subdev_cleanup() in crossbar and pipe
Date: Thu, 30 Jul 2026 16:12:23 +0200
Message-ID: <20260730141453.910695376@linuxfoundation.org>
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

commit 567418eedd25b3d86d489807682030b4b98b73d9 upstream.

Both mxc_isi_crossbar_init() and mxc_isi_pipe_init() call
v4l2_subdev_init_finalize() which allocates the subdev active state,
but neither mxc_isi_crossbar_cleanup() nor mxc_isi_pipe_cleanup()
calls v4l2_subdev_cleanup() to free it.

This causes a memory leak on every rmmod, reported by kmemleak:

  unreferenced object 0xffff0000d06fc800 (size 192):
    comm "(udev-worker)", pid 254, jiffies 4294913455
    backtrace (crc 36eeae58):
      kmemleak_alloc+0x34/0x40
      __kvmalloc_node_noprof+0x5f8/0x7d8
      __v4l2_subdev_state_alloc+0x1fc/0x30c
      __v4l2_subdev_init_finalize+0x178/0x368

Add the missing v4l2_subdev_cleanup() calls before media_entity_cleanup()
in both crossbar and pipe cleanup paths.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260507041318.491594-3-xiaolei.wang@windriver.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c |    1 +
 drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-crossbar.c
@@ -492,6 +492,7 @@ err_free:
 
 void mxc_isi_crossbar_cleanup(struct mxc_isi_crossbar *xbar)
 {
+	v4l2_subdev_cleanup(&xbar->sd);
 	media_entity_cleanup(&xbar->sd.entity);
 	kfree(xbar->pads);
 	kfree(xbar->inputs);
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
@@ -819,6 +819,7 @@ void mxc_isi_pipe_cleanup(struct mxc_isi
 {
 	struct v4l2_subdev *sd = &pipe->sd;
 
+	v4l2_subdev_cleanup(sd);
 	media_entity_cleanup(&sd->entity);
 	mutex_destroy(&pipe->lock);
 }


