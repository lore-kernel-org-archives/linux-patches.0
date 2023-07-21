Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725E51F94B
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02BBC433C7;
	Fri, 21 Jul 2023 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966007;
	bh=hS+Xg/DrKR6EKh5yzc07Atl0E0hgpsvMw4Yrj/Ymimo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmUkJld/JUMhN3SHW0P82g3Ahqn2fBKvgl8migjm0hfv8oeaL1WDUe0Tn4FJ/r8XI
	 meO7mk1SPAodhXQsvrWs7w1k8i6pVoDPhMISj6Wkopn/MveeutjIkKpBsE/GDgr4Cm
	 bGXDaoctfjRqm6gDH4bEocIecHXAF2lsHhAZZe0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/532] drm/amdkfd: Fix potential deallocation of previously deallocated memory.
Date: Fri, 21 Jul 2023 18:01:08 +0200
Message-ID: <20230721160623.298395483@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit cabbdea1f1861098991768d7bbf5a49ed1608213 ]

Pointer mqd_mem_obj can be deallocated in kfd_gtt_sa_allocate().
The function then returns non-zero value, which causes the second deallocation.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d1f8f0d17d40 ("drm/amdkfd: Move non-sdma mqd allocation out of init_mqd")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 7f4e102ff4bd3..ddaafcd7b8256 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -113,18 +113,19 @@ static struct kfd_mem_obj *allocate_mqd(struct kfd_dev *kfd,
 			&(mqd_mem_obj->gtt_mem),
 			&(mqd_mem_obj->gpu_addr),
 			(void *)&(mqd_mem_obj->cpu_ptr), true);
+
+		if (retval) {
+			kfree(mqd_mem_obj);
+			return NULL;
+		}
 	} else {
 		retval = kfd_gtt_sa_allocate(kfd, sizeof(struct v9_mqd),
 				&mqd_mem_obj);
-	}
-
-	if (retval) {
-		kfree(mqd_mem_obj);
-		return NULL;
+		if (retval)
+			return NULL;
 	}
 
 	return mqd_mem_obj;
-
 }
 
 static void init_mqd(struct mqd_manager *mm, void **mqd,
-- 
2.39.2



