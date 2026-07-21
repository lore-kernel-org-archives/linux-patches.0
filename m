Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7AB44AB84;
	Tue, 21 Jul 2026 21:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667788; cv=none; b=DGsYhA1qrLYll/tZHiZ9VQslnPcx+MTI+SuNn/j4A5Q1U2cdkeemcqYQn0DeyEMDa9Yp6JdBJd8+VxFzfX+gTVuysUO7xzDZv7uQEY8OPWjW0w54SwI5nTxjr2PNMOy/ePt3nlsCHBnnUx77/VdmWkkIASXQ7GEbEcxi92TFlKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667788; c=relaxed/simple;
	bh=nO1lHYYCrecSxvlq5HgJq1qjJLfO7Z2ee+54EgSS5c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwhhgLWBUKyG70qsWytbvH+cMHupbvK6HK/12jbrAVmkZwCgqqwUQLFA5OR59C5VgUrwbdIO5j1kHPEUHBxaFpMVJ3peakZRsEP1Plkt0m14UL0bxuv3Ji1NdklX9xKTamlfFamvSGB+Nf3xZjzKbSGvoYOx12pmgzbL1qVfYEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZm4vC3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZm4vC3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4DD1F000E9;
	Tue, 21 Jul 2026 21:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667782;
	bh=LVY+Tg9B0jhm+iC7SkLiNMURE7hPTn9Js9/V2+4OqkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZm4vC3OMUZiac9UOTOBusAYtRwQIsW1Dvh2VJMdpmkHTt7Q3plB/j0JSHINC8f6i
	 ykmPbu9Wk8wSgJcmMYxV806gWLTtUtilLkczTev9DDljrXILWjP0CGcs3oJLPEEOh4
	 ZpXhtcMxsh4v1aysKB8royk3fMw9yWusK1kum61c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Frank Li <Frank.Li@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1189/1266] media: nxp: imx8-isi: Fix use-after-free on remove
Date: Tue, 21 Jul 2026 17:27:06 +0200
Message-ID: <20260721152508.403752884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

[ Upstream commit b670bf89824ede5d07d20bb9bfbafb754846081d ]

KASAN reports a slab-use-after-free in __media_entity_remove_link()
during rmmod of imx8_isi:

  BUG: KASAN: slab-use-after-free in __media_entity_remove_link+0x608/0x650
  Read of size 2 at addr ffff0000d47cb02a by task rmmod/724

  Call trace:
   __media_entity_remove_link+0x608/0x650
   __media_entity_remove_links+0x78/0x144
   __media_device_unregister_entity+0x150/0x280
   media_device_unregister_entity+0x48/0x68
   v4l2_device_unregister_subdev+0x158/0x300
   v4l2_async_unbind_subdev_one+0x22c/0x358
   v4l2_async_nf_unbind_all_subdevs+0xfc/0x1c0
   v4l2_async_nf_unregister+0x5c/0x14c
   mxc_isi_remove+0x124/0x2a0 [imx8_isi]

  Allocated by task 249:
   __kmalloc_noprof+0x27c/0x690
   mxc_isi_crossbar_init+0x22c/0x560 [imx8_isi]

  Freed by task 724:
   kfree+0x1e4/0x5b0
   mxc_isi_crossbar_cleanup+0x34/0x80 [imx8_isi]
   mxc_isi_remove+0x11c/0x2a0 [imx8_isi]

The problem is that mxc_isi_remove() calls mxc_isi_crossbar_cleanup()
before mxc_isi_v4l2_cleanup(). The crossbar cleanup frees the media
entity pads, but the subsequent v4l2 cleanup still tries to remove
media links that reference those pads.

Fix this by calling mxc_isi_v4l2_cleanup() before
mxc_isi_crossbar_cleanup() to ensure all media entities are properly
unregistered while the pads are still valid.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260507041318.491594-2-xiaolei.wang@windriver.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
@@ -521,8 +521,8 @@ static void mxc_isi_remove(struct platfo
 		mxc_isi_pipe_cleanup(pipe);
 	}
 
-	mxc_isi_crossbar_cleanup(&isi->crossbar);
 	mxc_isi_v4l2_cleanup(isi);
+	mxc_isi_crossbar_cleanup(&isi->crossbar);
 }
 
 static const struct of_device_id mxc_isi_of_match[] = {


