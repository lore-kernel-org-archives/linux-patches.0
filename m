Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2611D4229A6;
	Thu, 16 Jul 2026 13:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209453; cv=none; b=DFbxIJ3juwwX7VDo4SaHlLpAzh/RKEyUfOEn7hqLzv7hoBB7uxqVVNR6gX7sy/OH2e5Noq1mDa+aaQVfAPH2juwshJZtWUv5KOHrPqRQvkY8xrfBhBIjGnpX0WvVqsvQlwoiAwuzqdgOfuG7C2OZRObSqzYH5KbKpRK5RoffMvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209453; c=relaxed/simple;
	bh=ALb5ILqDIt3TDt2RTGg7rpLqlle+i4Ns2zEQO/Qm1+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwyYx8ob2yw26tHmD9cHqT8NPnYiL3u1mZjWq4IVBV7/m9jZ33Zfj4rRGwrAxz4hKRczOMsW4AT8bO3Evp/Yc/ABH+gIa7IHFKgorJerBTlK4QzlKgoOWB7QiPXyYwNKVwZokFLWTYyf0k3/Ds7l4s9if9b9YvNA8Eh1Lky0mmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IHFMk99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IHFMk99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E891F00A3A;
	Thu, 16 Jul 2026 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209450;
	bh=4WkeAbO9k4NbYhNkNVzyNlmqF+juh6cfUPhjlTAlHmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IHFMk99qnwMc0qBUB+seJQWko5XTP/7RjhbgAGASKo4Kd/Zg5v7mu+iFLpACF1w8
	 xtUyPi8kZPNd5OygaHws5cLMrK7tQ7StoNpwtdTnRTuGiuQy6gD67XDT0nMHcF16r5
	 +SZX5oh1zmuifYRCip1VoH7IkiJe0rVBjQW1Q3NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Frank Li <Frank.Li@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 190/518] media: nxp: imx8-isi: Fix use-after-free on remove
Date: Thu, 16 Jul 2026 15:27:38 +0200
Message-ID: <20260716133051.990318197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

commit b670bf89824ede5d07d20bb9bfbafb754846081d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.c
@@ -556,8 +556,8 @@ static void mxc_isi_remove(struct platfo
 		mxc_isi_pipe_cleanup(pipe);
 	}
 
-	mxc_isi_crossbar_cleanup(&isi->crossbar);
 	mxc_isi_v4l2_cleanup(isi);
+	mxc_isi_crossbar_cleanup(&isi->crossbar);
 }
 
 static const struct of_device_id mxc_isi_of_match[] = {


