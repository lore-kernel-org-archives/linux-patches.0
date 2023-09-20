Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA926208BB
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBDDC433CC;
	Wed, 20 Sep 2023 11:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210708;
	bh=EO07YlRIVSBpvp80E7NjcnsUr0bJb1a0DOmRvz4QVvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=liPGuKV2cvr9z1+TdzaCtHCccMbCQ0Lqhbapdk8y/opPp1klGMye4g9FGG7Jpulsp
	 5pgAw89nxolmR3LBSAjfLoEwNdYLXkmeB5I1jUrS/CeY+xdI8FPrDFcQoG7Q6DnHRf
	 xd4TVxAZRg78+zb59OwRzh/pr6fQsu7vukUW07+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Pilkington <simonp.git@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.5 175/211] drm/amd: Make fence wait in suballocator uninterruptible
Date: Wed, 20 Sep 2023 13:30:19 +0200
Message-ID: <20230920112851.306966386@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Pilkington <simonp.git@gmail.com>

commit e2884fe84a83c562346eb9d92783a3576ce67177 upstream.

Commit c103a23f2f29
("drm/amd: Convert amdgpu to use suballocation helper.")
made the fence wait in amdgpu_sa_bo_new() interruptible but there is no
code to handle an interrupt. This caused the kernel to randomly explode
in high-VRAM-pressure situations so make it uninterruptible again.

Signed-off-by: Simon Pilkington <simonp.git@gmail.com>
Fixes: c103a23f2f29 ("drm/amd: Convert amdgpu to use suballocation helper.")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2761
CC: stable@vger.kernel.org # 6.4+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sa.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sa.c
@@ -81,7 +81,7 @@ int amdgpu_sa_bo_new(struct amdgpu_sa_ma
 		     unsigned int size)
 {
 	struct drm_suballoc *sa = drm_suballoc_new(&sa_manager->base, size,
-						   GFP_KERNEL, true, 0);
+						   GFP_KERNEL, false, 0);
 
 	if (IS_ERR(sa)) {
 		*sa_bo = NULL;


