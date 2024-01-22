Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49D41420A3;
	Tue, 23 Jan 2024 01:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972062; cv=none; b=Xwc2q8PhzwkSz5S7RVW0tC5nGLaUbL/EPImYM6pUtHc98WSfYLPsdynZLAtSBNQsM+PMknImsAMgT/WJWhph/RN4p4nenAbyWdqydmK7S0UbmW5UTw7itMxbDYHJhRtOQ+x5x7A/l1Gi17FXtsxchVxqWEeAtlRDKxZgee/zBtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972062; c=relaxed/simple;
	bh=jD3HWcSG3NUrg52wc6oT3BxGXjcflqfTHKgB+fomEJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G6HUfONB3dYXWFMsjnnB3K62xcy+lt6xBStVodOD63c2jkhbUlc90BvysSkdEKCZhDsfKF2zH5A3ky8aKMdQacLeMyucmJ00x8eni9tkPtbimqzw01Vcqtekr2fCEh2rFb+MZpK5Pr2AVeN/wd+tL0gF8rMfxhaXUwvQ+lZBzek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRsebJQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRsebJQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5F0C433F1;
	Tue, 23 Jan 2024 01:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972062;
	bh=jD3HWcSG3NUrg52wc6oT3BxGXjcflqfTHKgB+fomEJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRsebJQ1bfQBfJt5EJcLMxI/YL0iPNwifJInAGH3SuYP8lqdoEAPIzaPwEhLRZwxI
	 hHtjvzc0c49uiX2IvWMo22EqDlVjBd0kA0dcLcmo+AGNktpnJLtTkE/hr6ReXCYGhJ
	 kJk8qQBlUJwsGIV8OOP/TxzevcY8Q5RFlCNYHe8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <felix.kuehling@amd.com>,
	Dafna Hirschfeld <dhirschfeld@habana.ai>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 392/417] drm/amdkfd: fixes for HMM mem allocation
Date: Mon, 22 Jan 2024 15:59:20 -0800
Message-ID: <20240122235805.334822449@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2d011daf5a39..8a7705db0b9a 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -1019,7 +1019,7 @@ int svm_migrate_init(struct amdgpu_device *adev)
 	} else {
 		res = devm_request_free_mem_region(adev->dev, &iomem_resource, size);
 		if (IS_ERR(res))
-			return -ENOMEM;
+			return PTR_ERR(res);
 		pgmap->range.start = res->start;
 		pgmap->range.end = res->end;
 		pgmap->type = MEMORY_DEVICE_PRIVATE;
@@ -1035,10 +1035,10 @@ int svm_migrate_init(struct amdgpu_device *adev)
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



