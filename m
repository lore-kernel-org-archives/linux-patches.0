Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7243F28DBA
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GcUL1Hdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F94C433C8;
	Mon, 16 Oct 2023 14:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467957;
	bh=9DVsvyLP9wi7nhAzFg6lg11E2jbhETUGY9q87/GU6m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GcUL1Hdyk1HDzvaYRP9m2+YmYoRdQzzZ4yAUN8xcDU3a5YhTgAvVA/VHUeoXfKnzS
	 Y3KBmGWxRwdKIeLFAnqtPkiX8j4lOhvIpuwqkaJnPSrsjMHHgF4SQR9vr56DndIkrX
	 vXJA/rWhxAWrMHvTRVUegDs6Lheno5ui6TW080os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joey Gouly <joey.gouly@arm.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Thierry Reding <treding@nvidia.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.5 123/191] drm/tiny: correctly print `struct resource *` on error
Date: Mon, 16 Oct 2023 10:41:48 +0200
Message-ID: <20231016084018.250316756@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joey Gouly <joey.gouly@arm.com>

commit c1165df2be2fffe3adeeaa68f4ee4325108c5e4e upstream.

The `res` variable is already a `struct resource *`, don't take the address of it.

Fixes incorrect output:

	simple-framebuffer 9e20dc000.framebuffer: [drm] *ERROR* could not acquire memory range [??? 0xffff4be88a387d00-0xfffffefffde0a240 flags 0x0]: -16

To be correct:

	simple-framebuffer 9e20dc000.framebuffer: [drm] *ERROR* could not acquire memory range [mem 0x9e20dc000-0x9e307bfff flags 0x200]: -16

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Fixes: 9a10c7e6519b ("drm/simpledrm: Add support for system memory framebuffers")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Thierry Reding <treding@nvidia.com>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.3+
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20231010174652.2439513-1-joey.gouly@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/simpledrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/simpledrm.c b/drivers/gpu/drm/tiny/simpledrm.c
index ff86ba1ae1b8..8ea120eb8674 100644
--- a/drivers/gpu/drm/tiny/simpledrm.c
+++ b/drivers/gpu/drm/tiny/simpledrm.c
@@ -745,7 +745,7 @@ static struct simpledrm_device *simpledrm_device_create(struct drm_driver *drv,
 
 		ret = devm_aperture_acquire_from_firmware(dev, res->start, resource_size(res));
 		if (ret) {
-			drm_err(dev, "could not acquire memory range %pr: %d\n", &res, ret);
+			drm_err(dev, "could not acquire memory range %pr: %d\n", res, ret);
 			return ERR_PTR(ret);
 		}
 
-- 
2.42.0



