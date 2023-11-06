Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570FD200BA
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nI76Sp8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9889C433CB;
	Mon,  6 Nov 2023 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276412;
	bh=1vC+aW6xSzcdMkYixblVgb4JBUPnOmvExTMtgTHoQic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nI76Sp8jwHh4VKozBJ0EbM8CIEW0E+DOoEmN+BBuHmLjvbFSeX0pG2uzLDL9JPRJC
	 IOcdW0YwEQvFdDLaDoptreCIZhfAqZUIEZqPwYCQaz1HMEFzCYKwNKGE5PlAJ88wqK
	 dkexI0r3KHkcCeexFK9KtxNl2tlhdmUKKZ0MVkkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/62] drm/amdgpu: Reserve fences for VM update
Date: Mon,  6 Nov 2023 14:03:39 +0100
Message-ID: <20231106130303.039000614@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit 316baf09d355aec1179981b6dfe28eba50c5ee5b ]

In amdgpu_dma_buf_move_notify reserve fences for the page table updates
in amdgpu_vm_clear_freed and amdgpu_vm_handle_moved. This fixes a BUG_ON
in dma_resv_add_fence when using SDMA for page table updates.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index 7bd8e33b14be5..e8b3e9520cf6e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -400,7 +400,10 @@ amdgpu_dma_buf_move_notify(struct dma_buf_attachment *attach)
 				continue;
 		}
 
-		r = amdgpu_vm_clear_freed(adev, vm, NULL);
+		/* Reserve fences for two SDMA page table updates */
+		r = dma_resv_reserve_fences(resv, 2);
+		if (!r)
+			r = amdgpu_vm_clear_freed(adev, vm, NULL);
 		if (!r)
 			r = amdgpu_vm_handle_moved(adev, vm);
 
-- 
2.42.0



