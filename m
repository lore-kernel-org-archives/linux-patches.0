Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C29456296;
	Thu, 30 Jul 2026 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427648; cv=none; b=IXfEjL9zvP6cjNSvH82B/r9Ry8c5SOp+f/b4EeBGQs3POq2cLJ/4gziPr0E2dqE/XXI+AbnD8IBfSwjzxwub5WoiJWeq2+cCZ8Kyk9D3a/8v1g+B7ck12EzHHN9/aIbSXoQR0Bifd+32K89jyFTQTfWMyNMKdTkpsdw9NpWF334=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427648; c=relaxed/simple;
	bh=x2HoMIxVai+shszkvy/79c+23JzITGYvxWE1blV/6/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjDlRLV95sWBAIlAgGBY9JiCztO6XcHvVQmUhV67QHTj/BTX9K84ZS2zKJX8wZah/HnAhGjbqEOhIBfBy7mofwTCapoKDEBNPNf82lZH/SZxqwtge4aE3Xybdd3ItdsLsRFWEXZf4RzMldPLc53JhaeclSpNTtwDRRPO7+MQyLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xz9fPqTo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xz9fPqTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2021F000E9;
	Thu, 30 Jul 2026 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427647;
	bh=IpHLr57gx3LKWQSjJLW763KspmiRgVEc/ZVmFUdcWe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xz9fPqToni2JBhe8oFOPHYNuonMIYAjkYWE510Mq9eOBtGV35i8TDLiMaAH1w+yUm
	 kPfSJg8bJ+6xLDeuoVZv1TMeEcaYMHLSEJBZgaDSju9WkLv8oDE6ewjan+JG/i1wpV
	 U0KGEMBpabkWFBPsZXfjvN/taNqJZ/S8+Uf7LFlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Frank Li <Frank.Li@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 245/484] media: nxp: imx8-isi: Add missing v4l2_subdev_cleanup() in crossbar and pipe
Date: Thu, 30 Jul 2026 16:12:22 +0200
Message-ID: <20260730141428.808549548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -490,6 +490,7 @@ err_free:
 
 void mxc_isi_crossbar_cleanup(struct mxc_isi_crossbar *xbar)
 {
+	v4l2_subdev_cleanup(&xbar->sd);
 	media_entity_cleanup(&xbar->sd.entity);
 	kfree(xbar->pads);
 	kfree(xbar->inputs);
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
@@ -815,6 +815,7 @@ void mxc_isi_pipe_cleanup(struct mxc_isi
 {
 	struct v4l2_subdev *sd = &pipe->sd;
 
+	v4l2_subdev_cleanup(sd);
 	media_entity_cleanup(&sd->entity);
 	mutex_destroy(&pipe->lock);
 }


