Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A881FBF;
	Tue, 23 Jan 2024 02:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975793; cv=none; b=D/1kRd60WVm5um/u91hQ9QQ3wRrgo9i+oFUGxlqOznEaeWCfPvGCz73LjWN3kJMonIj/EJzMfMFSpENu4F9a4Lx3GKuWf0cgutzhxR0+ZTPwAfSyKUx55pry2KJCcSbawBzqFL1DQau8ThWr+fS2TkcvG0AHPRDIlOJNyYvIJPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975793; c=relaxed/simple;
	bh=BbuqVBOnd4hQFWrYYt0wA0DUhur9MGGAyxAuEovz1RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOe6O8lpoDICi5WD5eV2Ao8GJloUquUMftppa9/mCmGLmK7u3VP5WVUgFqs3hl1Lvxy2rSV2Z2XkXmzYPe/aqOB9Iu0ZH5FbQeVxD+JVbLtzOeY51PIw+tnwgRnWW1Cv/6rafJpGH7NQczN1LiJUGdyeALwHJyyq8UvQFWaBgC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGWG/2Zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGWG/2Zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8FCC433F1;
	Tue, 23 Jan 2024 02:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975793;
	bh=BbuqVBOnd4hQFWrYYt0wA0DUhur9MGGAyxAuEovz1RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGWG/2ZdVWhDujbTHaBsQdzTXD4rXCczXYalikng26PmsihjkO3tx86FbVY9lxe3j
	 jBJKJp2gQDgTEjiKSJLQNLgOup3TjpoPuZ9LOVAJN8ZNBQN/WmrDj5ll84VbLvl1Ut
	 6ve0D3Mq2Ex6++5swkoxrL8vcUcG6PAiyJZd5iFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Dafna Hirschfeld <dhirschfeld@habana.ai>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 551/583] drm/amdkfd: fixes for HMM mem allocation
Date: Mon, 22 Jan 2024 16:00:02 -0800
Message-ID: <20240122235829.006873671@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dafna Hirschfeld <dhirschfeld@habana.ai>

[ Upstream commit 02eed83abc1395a1207591aafad9bcfc5cb1abcb ]

Fix err return value and reset pgmap->type after checking it.

Fixes: c83dee9b6394 ("drm/amdkfd: add SPM support for SVM")
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Dafna Hirschfeld <dhirschfeld@habana.ai>
Signed-off-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 7d82c7da223a..659313648b20 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -1021,7 +1021,7 @@ int kgd2kfd_init_zone_device(struct amdgpu_device *adev)
 	} else {
 		res = devm_request_free_mem_region(adev->dev, &iomem_resource, size);
 		if (IS_ERR(res))
-			return -ENOMEM;
+			return PTR_ERR(res);
 		pgmap->range.start = res->start;
 		pgmap->range.end = res->end;
 		pgmap->type = MEMORY_DEVICE_PRIVATE;
@@ -1037,10 +1037,10 @@ int kgd2kfd_init_zone_device(struct amdgpu_device *adev)
 	r = devm_memremap_pages(adev->dev, pgmap);
 	if (IS_ERR(r)) {
 		pr_err("failed to register HMM device memory\n");
-		/* Disable SVM support capability */
-		pgmap->type = 0;
 		if (pgmap->type == MEMORY_DEVICE_PRIVATE)
 			devm_release_mem_region(adev->dev, res->start, resource_size(res));
+		/* Disable SVM support capability */
+		pgmap->type = 0;
 		return PTR_ERR(r);
 	}
 
-- 
2.43.0



