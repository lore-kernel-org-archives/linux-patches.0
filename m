Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDEF208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezaYng4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D042C433C8;
	Mon,  6 Nov 2023 13:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276740;
	bh=2ndbc8MGuDl7PyOn9+uKqC8xPJzXRRGerOaDe9T+PbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezaYng4wTKHW+mwtKhfaJ+w0V3ADp9end1YjZ20qw7vHeOjpzX9zr83dxZwdHf4KE
	 rLEveH6olF2gzsAVTNoYlKkhRjRcjhHqSM7q81Y+9bdva6YGPxvlC7B5AJ0VNkmg7S
	 9vB6w9xHYQF1WO4I2UrCy1rb9o6xzi524A2KsV0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 52/88] drm/amdgpu: Reserve fences for VM update
Date: Mon,  6 Nov 2023 14:03:46 +0100
Message-ID: <20231106130307.750104709@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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
index 12210598e5b8e..ba3a87cb88ccc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -403,7 +403,10 @@ amdgpu_dma_buf_move_notify(struct dma_buf_attachment *attach)
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



