Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B2752F283;
	Wed, 30 Sep 2026 17:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790558; cv=none; b=PiVHFmcf3yDYd9M8kRn57hJc4WySk2RaHFfitE7pOhqG4PMHaqBxWO3N9R1PTOh8Ju7bGMOzI4QuxOFvhwgbyhtSBsgkJwJKPLH/qp2WMVM80LQWJ45dXpdqbRnR1aZMXUemYdJkLQ+tJnz8+CjnK8afysANiovz/6G3LE6XkoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790558; c=relaxed/simple;
	bh=SkQP3lBuMuozn24SGhJe0mppLjjaG3NqQ28bjqJiPew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8gbxBxDyQ+EwJ2P0trG+XuLWPhl/8AoMXG/S8pN0h7i5CMh/ZxIrYb/O2PDx00wAOzXh/bWX0jPLeDmK6llQkoS9N5Y1VyUtRQKw/YkLZUUTUAsOD65K7WFrvNKzv+NaxKkoWX1EoRFj/9Hm7tKH0VWsh9cFurIxg0JgxyzWHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2IluWqm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2IluWqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833571F000FF;
	Wed, 30 Sep 2026 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790557;
	bh=zevDJHAcVWGfInMTF2HjeuvE08rykfYsmq4njpz13HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2IluWqmflpa+kRVKFe9B6O0oA4UPPR4Rr/+nUzS+LFIMYk0tes65e+f3CiLJ+blp
	 FpycFk96dRBhy85eCrPu/pB3oe/ztZIEfORrIXcmIjEYsBPTWB6h+6NGwHQYx5OyVN
	 7l+r+CaJtBrjF9e+4QL9JUIPXq9BHsHh/wqI5za0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin.Cao" <lincao12@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 869/877] drm/amdgpu: fix ring timeout issue in gfx10 sr-iov environment
Date: Wed, 30 Sep 2026 17:29:40 +0200
Message-ID: <20260930152433.486463995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin.Cao <lincao12@amd.com>

commit b529093999ff052916b35356dc66eddb83258ead upstream.

commit 26c95e838e63 ("drm/amdgpu: set the VM pointer to NULL in
amdgpu_job_prepare") set job->vm as NULL if there is no fence. It will
cause emit switch buffer be skippen if job->vm set as NULL.

Check job rather than vm could solve this problem.

Fixes: 26c95e838e63 ("drm/amdgpu: set the VM pointer to NULL in amdgpu_job_prepare")
Signed-off-by: Lin.Cao <lincao12@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -300,7 +300,7 @@ int amdgpu_ib_schedule(struct amdgpu_rin
 	amdgpu_ring_patch_cond_exec(ring, cond_exec);
 
 	ring->current_ctx = fence_ctx;
-	if (vm && ring->funcs->emit_switch_buffer)
+	if (job && ring->funcs->emit_switch_buffer)
 		amdgpu_ring_emit_switch_buffer(ring);
 
 	if (ring->funcs->emit_wave_limit &&


