Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A48E1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D889C433D6;
	Wed, 23 Nov 2022 09:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196020;
	bh=gi5P4OAPwMamd83ml8Ecx26GVKfsP21eNmi7b2AhGJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEuk4S7eZbD9PFcX/J2/MCI6dBohbH46ZnVh8EGU08Q2fZJwTPhgfbtrHO0YNvX0m
	 Uunt8WJX2nt4kzaXteaDUGSrfp+q1ZAnQ9n8sMp5cx5e6NhhAaFZWUmvgwgToPKVye
	 tN0EvN2MSr2a4CEr8umKcK6kNCgDHvn5npgSDX+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 067/181] drm: Fix potential null-ptr-deref in drm_vblank_destroy_worker()
Date: Wed, 23 Nov 2022 09:50:30 +0100
Message-Id: <20221123084605.250150181@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 4979524f5a2a8210e87fde2f642b0dc060860821 ]

drm_vblank_init() call drmm_add_action_or_reset() with
drm_vblank_init_release() as action. If __drmm_add_action() failed, will
directly call drm_vblank_init_release() with the vblank whose worker is
NULL. As the resule, a null-ptr-deref will happen in
kthread_destroy_worker(). Add the NULL check before calling
drm_vblank_destroy_worker().

BUG: null-ptr-deref
KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
CPU: 5 PID: 961 Comm: modprobe Not tainted 6.0.0-11331-gd465bff130bf-dirty
RIP: 0010:kthread_destroy_worker+0x25/0xb0
  Call Trace:
    <TASK>
    drm_vblank_init_release+0x124/0x220 [drm]
    ? drm_crtc_vblank_restore+0x8b0/0x8b0 [drm]
    __drmm_add_action_or_reset+0x41/0x50 [drm]
    drm_vblank_init+0x282/0x310 [drm]
    vkms_init+0x35f/0x1000 [vkms]
    ? 0xffffffffc4508000
    ? lock_is_held_type+0xd7/0x130
    ? __kmem_cache_alloc_node+0x1c2/0x2b0
    ? lock_is_held_type+0xd7/0x130
    ? 0xffffffffc4508000
    do_one_initcall+0xd0/0x4f0
    ...
    do_syscall_64+0x35/0x80
    entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 5e6c2b4f9161 ("drm/vblank: Add vblank works")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221101070716.9189-3-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_internal.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_internal.h b/drivers/gpu/drm/drm_internal.h
index d05e6a5b6687..f97a0875b9a1 100644
--- a/drivers/gpu/drm/drm_internal.h
+++ b/drivers/gpu/drm/drm_internal.h
@@ -104,7 +104,8 @@ static inline void drm_vblank_flush_worker(struct drm_vblank_crtc *vblank)
 
 static inline void drm_vblank_destroy_worker(struct drm_vblank_crtc *vblank)
 {
-	kthread_destroy_worker(vblank->worker);
+	if (vblank->worker)
+		kthread_destroy_worker(vblank->worker);
 }
 
 int drm_vblank_worker_init(struct drm_vblank_crtc *vblank);
-- 
2.35.1



