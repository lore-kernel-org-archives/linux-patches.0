Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD30949897;
	Mon, 18 Dec 2023 14:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UX5Zc7kH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EA1C433C8;
	Mon, 18 Dec 2023 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908358;
	bh=DEV9pM3+KTR6xwGabJSKCskp1Yq547HqHQeOv5depVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UX5Zc7kHeZXNGxJOs8w9NPaLm5XmelJbvVN9oWphpKXti6HRtrqq2H/7EXks0kkAL
	 RxqZCPuKOfNJXmhpbHSsvZWf4VBcW+Y/zUpUl6EHWcF9Ohtmwlu01TNb6ZQwkGK4qb
	 1TiOPkuww7lkdHwttArvkq7cXExIUQ1gZ6jfWce0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 146/166] drm/amdgpu: fix tear down order in amdgpu_vm_pt_free
Date: Mon, 18 Dec 2023 14:51:52 +0100
Message-ID: <20231218135111.655356149@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit ceb9a321e7639700844aa3bf234a4e0884f13b77 upstream.

When freeing PD/PT with shadows it can happen that the shadow
destruction races with detaching the PD/PT from the VM causing a NULL
pointer dereference in the invalidation code.

Fix this by detaching the the PD/PT from the VM first and then
freeing the shadow instead.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: https://gitlab.freedesktop.org/drm/amd/-/issues/2867
Cc: <stable@vger.kernel.org>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm_pt.c
@@ -642,13 +642,14 @@ static void amdgpu_vm_pt_free(struct amd
 
 	if (!entry->bo)
 		return;
+
+	entry->bo->vm_bo = NULL;
 	shadow = amdgpu_bo_shadowed(entry->bo);
 	if (shadow) {
 		ttm_bo_set_bulk_move(&shadow->tbo, NULL);
 		amdgpu_bo_unref(&shadow);
 	}
 	ttm_bo_set_bulk_move(&entry->bo->tbo, NULL);
-	entry->bo->vm_bo = NULL;
 
 	spin_lock(&entry->vm->status_lock);
 	list_del(&entry->vm_status);


