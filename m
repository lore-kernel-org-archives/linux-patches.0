Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6829628ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC50EC433EF;
	Mon, 12 Dec 2022 13:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850980;
	bh=2uKbLEiF8jST1fXreUTTOC/zVdKLs9K7cEZ8XT7aKAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7COcwInGy4hH3AGUDbwrnqPrnGmC3he2gJbge8ohDbelXnaDy+dAtnUGjOco2bMM
	 btaeA4ep1qLP7ThTvcbyMorsIwwJzuhSrRkdjcZ0PEJ9oSF/t8wsf35FmqZkNkVw/x
	 8VJ+qGTSOz0/fH1fTFXCfV5Me4Sy6TWx7RCt7lhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zackr@vmware.com>,
	Nicholas Hunt <nhunt@vmware.com>,
	Martin Krastev <krastevm@vmware.com>
Subject: [PATCH 5.10 053/106] drm/vmwgfx: Dont use screen objects when SEV is active
Date: Mon, 12 Dec 2022 14:09:56 +0100
Message-Id: <20221212130927.172588930@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zack Rusin <zackr@vmware.com>

commit 6e90293618ed476d6b11f82ce724efbb9e9a071b upstream.

When SEV is enabled gmr's and mob's are explicitly disabled because
the encrypted system memory can not be used by the hypervisor.

The driver was disabling GMR's but the presentation code, which depends
on GMR's, wasn't honoring it which lead to black screen on hosts
with SEV enabled.

Make sure screen objects presentation is not used when guest memory
regions have been disabled to fix presentation on SEV enabled hosts.

Fixes: 3b0d6458c705 ("drm/vmwgfx: Refuse DMA operation when SEV encryption is active")
Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Zack Rusin <zackr@vmware.com>
Reported-by: Nicholas Hunt <nhunt@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221201175341.491884-1-zack@kde.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
@@ -949,6 +949,10 @@ int vmw_kms_sou_init_display(struct vmw_
 	struct drm_device *dev = dev_priv->dev;
 	int i, ret;
 
+	/* Screen objects won't work if GMR's aren't available */
+	if (!dev_priv->has_gmr)
+		return -ENOSYS;
+
 	if (!(dev_priv->capabilities & SVGA_CAP_SCREEN_OBJECT_2)) {
 		DRM_INFO("Not using screen objects,"
 			 " missing cap SCREEN_OBJECT_2\n");


