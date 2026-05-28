Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D729348C45;
	Thu, 28 May 2026 19:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998331; cv=none; b=YtqTkO93Tk5B07lxLVFpKHkJQtk2Rq+b360HcJP7mWKouYrPw4kXy4088QXepFJu4muMsfd8aezWTvvI3bSw7ZgxJLc8YpEM6Bsg8eFQrUc4MSSKQC3/qO43eKTKJmA7m6F4BQ3J308tIeDyoF74VmYqESIpkhkP7d+SQ7akXf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998331; c=relaxed/simple;
	bh=sWjZPeJM5cJ44gqlLpYPERzb0LWdlm5MiA7uf6w1EhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcP0gldfa+88eXYVX3oJrlPwB0y6izmqjVq1ytATTHsjnzHKFupMP9Mnu/32MMDZdznsJ8B2Rvj6ZlwvJpxS/jKLEGiGbxPkSsrjcQFSeAje42kUEfDFRr8n36YRHwt35ewlwUOLrjWo0yb8ikZ72eLwOKQHM6Whrb7C5GYw+gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7lWCjTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7lWCjTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B75C1F000E9;
	Thu, 28 May 2026 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998330;
	bh=jeK7VOrrEtlejF3BYl8Lk/fQzTPyyItmox5l7zAxUbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7lWCjTn7m45ErKRCz1epqdPf8PUrbLuXMQCf7yfa6j4P+KlwfcAiO1DMeljsp4v+
	 qNrz2+eyO0VloxQD5RqfhHhV1Glp7zqBhlHhe8Oz+8VBk1PmLXiUS+MEo8Dj5tKFCN
	 eD5PHhUrkMuqMYj+HrMOYZy+j88Bf8DspzBMPNko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alan liu <haoping.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.0 135/461] drm/amdgpu/vpe: Force collaborate sync after TRAP
Date: Thu, 28 May 2026 21:44:24 +0200
Message-ID: <20260528194650.897848565@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


