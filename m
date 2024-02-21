Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D518D3D0A1;
	Wed, 21 Feb 2024 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525476; cv=none; b=FMgQQoCKiH3mqKln0rlyJb1vKKHOA5AAIIK2XGdqTQ5RHDjMQjP338fU4sL3WZMnbNOMdcBm+H/BhZEcAFAmHnzW8r2jjB/4X2BijEmeRN88Oy1Wpzrcvu5Dxud2MV5/BhUw1ArzpfxdbMyKrUjlpYlGJ/QfI6kPhHhSpe1607w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525476; c=relaxed/simple;
	bh=vuKME5r6vdivSxKZ9uT8Lmzfwpr7rz+7tStSkB2PBmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BtLpB/1NNHbLz8p5p+o6OPYctWAIo492JrOeBmYKnEPEsvjhaicdH6RPIdsByETUAg0sKDcvK7cA/L/3x50CZIpKtqqu/OSJQlKGWIQog66BbELgn2ydocD9dYQanmMO/8xA1GQxFgdwchgHspjpoaEZAjBZAcEeM7l02jdhA3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XBNkNou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XBNkNou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2ACC433C7;
	Wed, 21 Feb 2024 14:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525476;
	bh=vuKME5r6vdivSxKZ9uT8Lmzfwpr7rz+7tStSkB2PBmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XBNkNoudHlk8Jg8/972uHlZqZWAkwPg+BIZSPBgOWCH0vi48omWKfAHQ7BAh/gMa
	 35lyXvpb273Ymdb6+Xxm4dgtS7AS7PYtq0YtxgqQXW0Z0Cjbtj27owWv32hzm+8bo3
	 9FwQ94gsZ2s1dfRyreC+6p5UD4Zl/T7N7hh+QDIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/267] drm/amdgpu: Let KFD sync with VM fences
Date: Wed, 21 Feb 2024 14:07:59 +0100
Message-ID: <20240221125944.381277298@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit ec9ba4821fa52b5efdbc4cdf0a77497990655231 ]

Change the rules for amdgpu_sync_resv to let KFD synchronize with VM
fences on page table reservations. This fixes intermittent memory
corruption after evictions when using amdgpu_vm_handle_moved to update
page tables for VM mappings managed through render nodes.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
index 95e5e93edd18..7e840e560513 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sync.c
@@ -218,7 +218,8 @@ int amdgpu_sync_resv(struct amdgpu_device *adev,
 		 */
 		fence_owner = amdgpu_sync_get_owner(f);
 		if (fence_owner == AMDGPU_FENCE_OWNER_KFD &&
-		    owner != AMDGPU_FENCE_OWNER_UNDEFINED)
+		    owner != AMDGPU_FENCE_OWNER_UNDEFINED &&
+	    owner != AMDGPU_FENCE_OWNER_KFD)
 			continue;
 
 		if (amdgpu_sync_same_dev(adev, f)) {
-- 
2.43.0



