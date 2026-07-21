Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6163D471265;
	Tue, 21 Jul 2026 20:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664348; cv=none; b=HC3oVV3ft1GuxVP3ppkEnTd4RIt9jFVQpd/rEeLoXSxNo1AhyvFeDFFBUcj4Ax5dimGS+wIytitGCJdvQJolKh3vQwrbiYEMkNd+pt5CRfKnZi2e/YXXKYo5GqAFIBVMACJbYeTl8/8Otp0xFpUPxfhNpkx4UmVUYGnPXTsyF4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664348; c=relaxed/simple;
	bh=Bxb1fqYnelSMRJNmhb3xf4S0dYTVvfvLO/asFCPNVo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qBzIWWWaNQwDfZg/FZHhqKP4BtgCqZAByRe0Q1IcN+MQgbtypt3zEds/pHMmT3m/B2wQgqIpfW3XDhTZChZIydrZX6LaX5jLqHnT+m82M4ol4l92SFLN8wCdshpi2Tbt+crqrRiLoQHypQB77uLswdsdDe9LproO4GSM00g++g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vd2grsh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vd2grsh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78741F000E9;
	Tue, 21 Jul 2026 20:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664347;
	bh=PcLn8nGefYhU8poVOS+QKKOnftr1Vzkqrqvr4M9qTWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vd2grsh8WB3hHNPfayYXdZnu6ADLRe3p41V76jfbkkPQe90ia5OeaWHhZ8BAHMXKN
	 dqq1oRnu9QbMkQbZBYEN/9xmCJ2CzXNcniSVQgfkOVNQ4ub52hG0H08gx6jPNERdQv
	 kLZWNzFtTWfunXwTAqUqmW0jqv4v3owzBXJsLxE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Frank Li <Frank.Li@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1167/1276] media: nxp: imx8-isi: Fix use-after-free on remove
Date: Tue, 21 Jul 2026 17:26:50 +0200
Message-ID: <20260721152512.137686750@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
@@ -519,8 +519,8 @@ static void mxc_isi_remove(struct platfo
 		mxc_isi_pipe_cleanup(pipe);
 	}
 
-	mxc_isi_crossbar_cleanup(&isi->crossbar);
 	mxc_isi_v4l2_cleanup(isi);
+	mxc_isi_crossbar_cleanup(&isi->crossbar);
 }
 
 static const struct of_device_id mxc_isi_of_match[] = {


