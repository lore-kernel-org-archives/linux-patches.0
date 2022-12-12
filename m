Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFF428ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3391C433EF;
	Mon, 12 Dec 2022 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852382;
	bh=VsCVWcMEA6ib6koqt6jhTnfBBbcFlqvLnGyS/hpHQlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=roFr5iXC58CUnCeLlBckHxIMOqDF/XySUn5R5LcL0JXRnDXOs2CVvMH9rCFlAzZrU
	 LnRsDghumhcZsiqUY7aFeJlM71WM5VHHG4R0E3K3NENFZuTU/R0AsX7UJqH9czrcjU
	 DaJvC1yEzTfCF4C/5OxYmjxayZT2ml7eLX/MkY/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zackr@vmware.com>,
	Nicholas Hunt <nhunt@vmware.com>,
	Martin Krastev <krastevm@vmware.com>
Subject: [PATCH 6.0 069/157] drm/vmwgfx: Dont use screen objects when SEV is active
Date: Mon, 12 Dec 2022 14:16:57 +0100
Message-Id: <20221212130937.388201295@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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
@@ -950,6 +950,10 @@ int vmw_kms_sou_init_display(struct vmw_
 	struct drm_device *dev = &dev_priv->drm;
 	int i, ret;
 
+	/* Screen objects won't work if GMR's aren't available */
+	if (!dev_priv->has_gmr)
+		return -ENOSYS;
+
 	if (!(dev_priv->capabilities & SVGA_CAP_SCREEN_OBJECT_2)) {
 		return -ENOSYS;
 	}


