Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865014ABBBC;
	Thu, 17 Sep 2026 16:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661301; cv=none; b=bFGFcRTQubBtU81YQLukhwuCik9JnpU0Zppd3E/yMcjP+Dn9otIDqAivaaz06ey55p33mHneki9HZTJJKs62qZJLpRgTdH3nMjQR6KhOJVYLTi7pyrLIzp8M4kBZhNorn7oNG27X11hImwO6vTbLwunD+14lH11i4zjL3qRq08k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661301; c=relaxed/simple;
	bh=PX2iob1O7WL6IvVQj6G0dXuYitPa5xmsQ+CN81aOW00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odbqDZNsuK2Me+m6uXk5qf6cNyC2RTatTsTAbPecECN3NW34WCmX+/ocSB5B55TyKNYDxuQmKHuRh52q/3tnQTfbOkbNGYcrH5zsb876C8MfEe/XF5jzMKRjKgCIix4SA+/pTJZtBLz1GCQdVXyoxCN4jMafFYqh1Q0JKzRJTk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXQat+rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXQat+rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9091F000FF;
	Thu, 17 Sep 2026 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661300;
	bh=EXRsma3ura4aJ1NwfdjXu6HUMaMQRBrt3uTv2pUOqec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IXQat+rhDZk3rAI0sQHrq6LZtHlEJhcZynlxCceDnY5uZQ/sdYm4iPb4Wae4wDgHj
	 nbqQc5KwVuvwumteMKXd5fVoqJlTXJmR2k2hzzmnhKxSXr6noKhdPQ+MIQxQN2kMjz
	 P+1I1HSw3I7XXoDpbGqHFfLLvM+0yszEJ7I47bAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0149/1250] drm/amd/ras: reset CPER ring on corrupt entry size
Date: Thu, 17 Sep 2026 15:59:04 +0100
Message-ID: <20260917151556.105316688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 4d695e66d7027a0c78302e47ac76293675fbbb4d ]

When CPER ring overflow handling advances the read pointer, it trusts the
parsed entry size from the current ring contents. Corrupt CPER data can
produce an entry size that does not advance rptr after dword conversion
and pointer masking.

In that case the recovery loop keeps testing the same location while
holding the CPER ring mutex. This can hang the worker that is writing the
next CPER record.

Detect a no-progress rptr update and reset the CPER ring to an empty
state instead. This drops the corrupt contents and lets the writer leave
the recovery path without spinning.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
index 425a3e5643608..2694facb06c73 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cper.c
@@ -465,7 +465,7 @@ static u32 amdgpu_cper_ring_get_ent_sz(struct amdgpu_ring *ring, u64 pos)
 
 void amdgpu_cper_ring_write(struct amdgpu_ring *ring, void *src, int count)
 {
-	u64 pos, wptr_old, rptr;
+	u64 pos, wptr_old, rptr, next_rptr;
 	int rec_cnt_dw = count >> 2;
 	u32 chunk, ent_sz;
 	u8 *s = (u8 *)src;
@@ -506,9 +506,19 @@ void amdgpu_cper_ring_write(struct amdgpu_ring *ring, void *src, int count)
 
 		do {
 			ent_sz = amdgpu_cper_ring_get_ent_sz(ring, pos);
-
-			rptr += (ent_sz >> 2);
-			rptr &= ring->ptr_mask;
+			next_rptr = rptr;
+			if (ent_sz >= sizeof(u32))
+				next_rptr = (rptr + (ent_sz >> 2)) & ring->ptr_mask;
+
+			if (next_rptr == rptr) {
+				/* Corrupt entry size, reset the ring to avoid an infinite loop. */
+				rptr = ring->wptr;
+				*ring->rptr_cpu_addr = rptr;
+				ring->count_dw = (ring->ring_size - 4) >> 2;
+				goto out_unlock;
+			}
+
+			rptr = next_rptr;
 			*ring->rptr_cpu_addr = rptr;
 
 			pos = rptr;
@@ -517,6 +527,8 @@ void amdgpu_cper_ring_write(struct amdgpu_ring *ring, void *src, int count)
 
 	if (ring->count_dw >= rec_cnt_dw)
 		ring->count_dw -= rec_cnt_dw;
+
+out_unlock:
 	mutex_unlock(&ring->adev->cper.ring_lock);
 }
 
-- 
2.53.0



