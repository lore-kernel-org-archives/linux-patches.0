Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8703016E0;
	Thu, 28 May 2026 20:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999617; cv=none; b=JpmlXp4Jd9kPOJKs+yx6gyBkiH85i0lTbMH2VHP0A/fvYofp9l0DBQZ0fsHtAZr0Qnhiy5MozgAkQYDlfV3anN9DZNVGStmaD6g3aiPAyCc82p4cyWzm9JDpXjvZ1sRoVFxrSv460/d9f+lvRrOfmVjBJkRo25m7I1ZCWZqj2HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999617; c=relaxed/simple;
	bh=bu3QeVXrlo4b++EKVC4xjb/OQzYvrRINRvlFwVHWfzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkMAmh01KzV+mmSUxhVLkO+VpUP12VB3Gr5rJZqrGWvolmeiKj8W/O03wJay/P/kKuyQWz+po+OEVznJTrMF3mmElJNNvK4GYfWH7R0VbnguAvGC6xsXLJV0uiXupqQ0wy9AapCVCg4p7jomjttFRHQQl1gnfvhVbf8Q4TF7HaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmw2ShCu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmw2ShCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE31F1F000E9;
	Thu, 28 May 2026 20:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999616;
	bh=Qqly/oLQEVLf5jk4IPGxnt88cEL8Xa9gmxeiOBv12Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmw2ShCuZsImXdWl09248bVGymjoVNmB/LcFs+uMinQXSr5dN1hZuX835RO6/ZhSo
	 l+u6mMWXvzFzIg2cVps/hADkFNog5+fG5iJXWzRGoStoUbQKRZkvecaMa0N6rcGNO8
	 IcU7XnUl23Xgpc8wE7zDgQgpIQEUps88l8D0cPyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alan liu <haoping.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 131/377] drm/amdgpu/vpe: Force collaborate sync after TRAP
Date: Thu, 28 May 2026 21:46:09 +0200
Message-ID: <20260528194642.154687109@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Alan Liu <haoping.liu@amd.com>

commit b6074630a461b1322a814988779005cbc43612ea upstream.

VPE1 could possibly hang and fail to power off at the end of commands in
collaboration mode. This workaround adds a COLLAB_SYNC after TRAP to
force instances synchronized to avoid VPE1 fail to power off.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Alan liu <haoping.liu@amd.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/work_items/5171
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a8b749c5c5afb7e5daa2bfb95d958fb3c6b8f055)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vpe.c
@@ -562,6 +562,11 @@ static void vpe_ring_emit_fence(struct a
 		amdgpu_ring_write(ring, 0);
 	}
 
+	/* WA: Force sync after TRAP to avoid VPE1 fail to power off */
+	if (ring->adev->vpe.collaborate_mode) {
+		amdgpu_ring_write(ring, VPE_CMD_HEADER(VPE_CMD_OPCODE_COLLAB_SYNC, 0));
+		amdgpu_ring_write(ring, 0xabcd);
+	}
 }
 
 static void vpe_ring_emit_pipeline_sync(struct amdgpu_ring *ring)
@@ -968,7 +973,7 @@ static const struct amdgpu_ring_funcs vp
 	.emit_frame_size =
 		5 + /* vpe_ring_init_cond_exec */
 		6 + /* vpe_ring_emit_pipeline_sync */
-		10 + 10 + 10 + /* vpe_ring_emit_fence */
+		12 + 12 + 12 + /* vpe_ring_emit_fence */
 		/* vpe_ring_emit_vm_flush */
 		SOC15_FLUSH_GPU_TLB_NUM_WREG * 3 +
 		SOC15_FLUSH_GPU_TLB_NUM_REG_WAIT * 6,


