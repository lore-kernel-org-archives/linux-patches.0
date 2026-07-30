Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBBA431A5C;
	Thu, 30 Jul 2026 14:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422619; cv=none; b=bJ0LA/fMQX1GSL0nLJnhD7Gxk4c1fO0CRol/ndSRlI2a2Um6nlCoKlhhrbBVWapVfHeWvLRU9thRz0CGKgrXs2MKFzJv6/3SLZ083Tf/RF/6qJ+Tqe8pCkXUfguYKpdDFUEP/Bg4Bb2A3oNXDGxlZcvzXoFyHR81K2YA/FPpBfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422619; c=relaxed/simple;
	bh=6l/EWG4Chz7yFQuy3MQAKcgAajw4v2dmSeaOYKoTtP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SX8+J2Jk/m77fW+oM2SR9yHsdCbBlF5Y+Sjqkji8hIq+BlKtaOYSECfK2qasjs6IOEJNTk56Rd2l+jnuF/FNJjFARlUqFa3y2dy13i3QghxstRgz2zr/q5vlzb1EhqrUcpTF2Wdmr5Cf8rEvQ1nZ7mo+sK7iG9zlSraWdvuft9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh3P6735; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh3P6735"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631A21F000E9;
	Thu, 30 Jul 2026 14:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422618;
	bh=h6fUwB79QBu4izyZjrVzXU0T3LBRdeTLGjyDPMJJRiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rh3P6735HgvkxLDTPKyD0fLOWcJNx9ZSY0sZj5vSGXpU31Y4vD13AtDvUTATcYmjk
	 ueTVRfOxUEkyqBTw8ec9QnGiuWeUSIf+7sD1oyzNR2JZ4pey0XkQfdHMRLghyzVzDl
	 63adjc4sWsFYCiDySvh+3UWVQ7OwPl69ue3GxRVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Frank Li <Frank.Li@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 498/744] media: nxp: imx8-isi: Add missing v4l2_subdev_cleanup() in crossbar and pipe
Date: Thu, 30 Jul 2026 16:12:51 +0200
Message-ID: <20260730141454.871821851@linuxfoundation.org>
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
@@ -491,6 +491,7 @@ err_free:
 
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


