Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AD58BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA49BC433D2;
	Tue, 28 Mar 2023 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015525;
	bh=JOqsN6ZFMoynlO9tS75sayp7mIV9h9Vo+ExBZkm8P1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJAkgMQDYmkVcwRY33i/DI4j4FsLIfWNlq9vRLTsWCdH4HYJzS4g1lkCH7AqB2HI4
	 NjoDVGoTDehDQ66Uieg17ruaGKkIMps+QVYl5mJ1yqMn/nSenxqeZ/Iifhf+BN6JW7
	 aM99bHUKBmMtRxvKcWbIIafopNkY/x9IheFw4y7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Wilson <chris.p.wilson@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Radhakrishna Sripada <radhakrishna.sripada@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/224] drm/i915/fbdev: lock the fbdev obj before vma pin
Date: Tue, 28 Mar 2023 16:40:45 +0200
Message-Id: <20230328142619.427816960@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit ed00eba03474adbf525ff03d69705d8c78b76456 ]

lock the fbdev obj before calling into
i915_vma_pin_iomap(). This helps to solve below :

<7>[   93.563308] i915 0000:00:02.0: [drm:intelfb_create [i915]] no BIOS fb, allocating a new one
<4>[   93.581844] ------------[ cut here ]------------
<4>[   93.581855] WARNING: CPU: 12 PID: 625 at drivers/gpu/drm/i915/gem/i915_gem_pages.c:424 i915_gem_object_pin_map+0x152/0x1c0 [i915]

Fixes: f0b6b01b3efe ("drm/i915: Add ww context to intel_dpt_pin, v2.")
Cc: Chris Wilson <chris.p.wilson@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Signed-off-by: Radhakrishna Sripada <radhakrishna.sripada@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230301201053.928709-5-radhakrishna.sripada@intel.com
(cherry picked from commit 561b31acfd65502a2cda2067513240fc57ccdbdc)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fbdev.c | 24 ++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fbdev.c b/drivers/gpu/drm/i915/display/intel_fbdev.c
index d9b42905bad84..968915000519f 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev.c
@@ -208,6 +208,7 @@ static int intelfb_create(struct drm_fb_helper *helper,
 	bool prealloc = false;
 	void __iomem *vaddr;
 	struct drm_i915_gem_object *obj;
+	struct i915_gem_ww_ctx ww;
 	int ret;
 
 	mutex_lock(&ifbdev->hpd_lock);
@@ -288,13 +289,24 @@ static int intelfb_create(struct drm_fb_helper *helper,
 		info->fix.smem_len = vma->size;
 	}
 
-	vaddr = i915_vma_pin_iomap(vma);
-	if (IS_ERR(vaddr)) {
-		drm_err(&dev_priv->drm,
-			"Failed to remap framebuffer into virtual memory (%pe)\n", vaddr);
-		ret = PTR_ERR(vaddr);
-		goto out_unpin;
+	for_i915_gem_ww(&ww, ret, false) {
+		ret = i915_gem_object_lock(vma->obj, &ww);
+
+		if (ret)
+			continue;
+
+		vaddr = i915_vma_pin_iomap(vma);
+		if (IS_ERR(vaddr)) {
+			drm_err(&dev_priv->drm,
+				"Failed to remap framebuffer into virtual memory (%pe)\n", vaddr);
+			ret = PTR_ERR(vaddr);
+			continue;
+		}
 	}
+
+	if (ret)
+		goto out_unpin;
+
 	info->screen_base = vaddr;
 	info->screen_size = vma->size;
 
-- 
2.39.2



