Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37DABA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65065C433D2;
	Tue,  7 Mar 2023 17:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209811;
	bh=5/a51Nfi6YYbil90NZNM0K4WgsFihGtPP9T9zaNPPhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPUL9cZVNOtWIb7o0R+paMBeDSzx3E9PSB/lWV7DFkc7nulqeE29nsVWSgEPMceto
	 tiDD5EoB+CiZHmYdQmakM1c/xP7D4ap2oX+aj0ormyF07CdW1pW0G6wXhBWrRvk2uY
	 05yLnDWh/+3MeLYQZOB2r/dq6ps81SpclngKmUw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Dave Airlie <airlied@redhat.com>,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0340/1001] drm/ast: Init iosys_map pointer as I/O memory for damage handling
Date: Tue,  7 Mar 2023 17:51:52 +0100
Message-Id: <20230307170036.228522811@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit b1def7fadfa544bd2467581ce40b659583eb7e79 ]

Ast hardware scans out the primary plane from video memory, which
is in I/O-memory space. Hence init the damage handler's iosys_map
pointer as I/O memory.

Not all platforms support accessing I/O memory as system memory,
although it's usually not a problem in ast's x86-based systems.

The error report is at [1].

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Fixes: f2fa5a99ca81 ("drm/ast: Convert ast to SHMEM")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jocelyn Falempe <jfalempe@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Link: https://lore.kernel.org/lkml/202212170111.eInM0unS-lkp@intel.com/T/#u # 1
Link: https://patchwork.freedesktop.org/patch/msgid/20221216193005.30280-1-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ast/ast_mode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 66a4a41c3fe94..d314b9e7c05f9 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -636,7 +636,7 @@ static void ast_handle_damage(struct ast_plane *ast_plane, struct iosys_map *src
 			      struct drm_framebuffer *fb,
 			      const struct drm_rect *clip)
 {
-	struct iosys_map dst = IOSYS_MAP_INIT_VADDR(ast_plane->vaddr);
+	struct iosys_map dst = IOSYS_MAP_INIT_VADDR_IOMEM(ast_plane->vaddr);
 
 	iosys_map_incr(&dst, drm_fb_clip_offset(fb->pitches[0], fb->format, clip));
 	drm_fb_memcpy(&dst, fb->pitches, src, fb, clip);
-- 
2.39.2



