Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2023C3C1E;
	Tue, 16 Jun 2026 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631973; cv=none; b=UAM/yv3LF1kps/imk7G/0wXQmVdS7w/jBwaSr7GW5cK5bMWsmHHOul+M8jCYL3/NlueM1xeBZgdTdVhB7IkQWj7EcHL9Lur+ENqGUOH01da7FRK7BUFeMsBBwPbvlRAVXoVTSGfM2YzceTlbcgaBuR6HSPhghYy+3d439YSdsxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631973; c=relaxed/simple;
	bh=9kL45s4tnzJno8DbPEgJuhBKTEcmAIl+JvkoYDMEAgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EtCZKCCetZTNGFFsDEyKon03vtTgm7HCdsbdpU+a2z6xHIQssaiIdw/1IHjm0DxOJ0xGaf4gmgkcFUefOXk0TobDKA6n272TVePS+OlUS0PaMHAfFZlOdQrw7hITRRZoKgcPLd2rcxLq0PsexZb74Bwj+rPOzfkgd5XcGR4jPjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2Q6dXlP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2Q6dXlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CE61F000E9;
	Tue, 16 Jun 2026 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631972;
	bh=eKbIhFCRrW5SyIke5JUsMHGAWf/mcLAQLIiI7kC0haE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2Q6dXlPO5Pqi4PN87B4OEpkyUX2GpG0RANge2ZKgc+vq4t2tzKgkJmb8OsVgiueG
	 HhXlKbv+guxYQ1Mj26SXNvmNJbvrhxz/MwFr9q4bsajv9Bph6Y1N8xjdwee4Mw+JXZ
	 FRaN9VYSFvtAigO5zf7RUo7Lxonv/66WlpuVCw9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 322/522] drm/amdgpu: restart the CS if some parts of the VM are still invalidated
Date: Tue, 16 Jun 2026 20:27:49 +0530
Message-ID: <20260616145140.914850334@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Christian König <christian.koenig@amd.com>

commit 40396ffdf6120e2380706c59e1a84d7e765a37b6 upstream.

Make sure that we only submit work with full up to date VM page tables.

Backport to 7.1 and older.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Tested-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 59720bfd8c6dbebeb8d5a7ab64241b007efd9213)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1227,6 +1227,7 @@ static int amdgpu_cs_submit(struct amdgp
 {
 	struct amdgpu_fpriv *fpriv = p->filp->driver_priv;
 	struct amdgpu_job *leader = p->gang_leader;
+	struct amdgpu_vm *vm = &fpriv->vm;
 	struct amdgpu_bo_list_entry *e;
 	unsigned int i;
 	uint64_t seq;
@@ -1268,7 +1269,8 @@ static int amdgpu_cs_submit(struct amdgp
 		r |= !amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, e->range);
 		e->range = NULL;
 	}
-	if (r) {
+
+	if (r || !list_empty(&vm->invalidated)) {
 		r = -EAGAIN;
 		mutex_unlock(&p->adev->notifier_lock);
 		return r;


