Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BBF28E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774DCC433C8;
	Wed, 20 Sep 2023 11:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210781;
	bh=b0pI8QF9dNR9egM/XNf/eJxNYQU4g8fSrg+p5jwLhpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1t7ateqmXeQuDvDZorM7jKd6z7giPhYhVW+MiYnwXbvJfazCc5cM0zB0+nrcbsBZ5
	 mPsjPjBu5OTiagEbqf60rCUVpqx0TOlPyVea3fPAFbH5e0ZYjehHM47dIqQhxGORWm
	 Cx13dPL4gxQX+XoTHejMEIHrAYm4ej+ToVoK1Tqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Simon Pilkington <simonp.git@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.5 202/211] drm/radeon: make fence wait in suballocator uninterrruptable
Date: Wed, 20 Sep 2023 13:30:46 +0200
Message-ID: <20230920112852.128341215@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit dcbad727513d277144aee482b2ffbcd2255c37aa upstream.

Commit 254986e324ad ("drm/radeon: Use the drm suballocation manager implementation.")
made the fence wait in amdgpu_sa_bo_new() interruptible but there is no
code to handle an interrupt. This caused the kernel to randomly explode
in high-VRAM-pressure situations so make it uninterruptible again.

Fixes: 254986e324ad ("drm/radeon: Use the drm suballocation manager implementation.")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2769
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
CC: stable@vger.kernel.org # 6.4+
CC: Simon Pilkington <simonp.git@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230906195517.1345717-1-alexander.deucher@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_sa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_sa.c
+++ b/drivers/gpu/drm/radeon/radeon_sa.c
@@ -123,7 +123,7 @@ int radeon_sa_bo_new(struct radeon_sa_ma
 		     unsigned int size, unsigned int align)
 {
 	struct drm_suballoc *sa = drm_suballoc_new(&sa_manager->base, size,
-						   GFP_KERNEL, true, align);
+						   GFP_KERNEL, false, align);
 
 	if (IS_ERR(sa)) {
 		*sa_bo = NULL;


