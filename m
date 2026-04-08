Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1413176E4;
	Wed,  8 Apr 2026 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674716; cv=none; b=Wq9kdvYBKTfGhgKdOcSYZivIlVcj/Q7P+6Dqrd0/g3uSnoGcm9r06HcinZT1RFACZlgcc6/JgxYga+7oMuwA4FugjFZo1CFpBi2gyXLgivyIN1a+Hli/1/AYY6NJvusO0TjTuGRd52L9L3Tyf2WW/tIMjtLjvdJq3zcMy/1p8Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674716; c=relaxed/simple;
	bh=yo1PGd2l8RYgzPxKBKvn1aCl8ln5wqD884yBMYr5XU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2CdklmPK+tH6KzXe11E2KMfMFj6WCaVm/UHRJNbN9GSq8thNypEXYj72kTQ4Bie3bsWDIc3S5TVWXRM2OHZnSB/HZELqzaGc5bd7nHIyRh1NzexjbxEVPoPRzvPh5v58D2G7qAi8IlJpe2EvS7w7XS34hkwv1+vw2+yfPyX8xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEKvohMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEKvohMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6185C19421;
	Wed,  8 Apr 2026 18:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674716;
	bh=yo1PGd2l8RYgzPxKBKvn1aCl8ln5wqD884yBMYr5XU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEKvohMiX/RzdA7Kn3PnrkGm/9yuGXGL/cwNdAT8+7mNlADAG5f1YO2f2/gdyxcp5
	 DSehrEOr0wN6FWhixczC2RxhVSkCYR8RabkVCZdwhv+jRI5gOhVA6LO0/Qzf0e5sYB
	 /JOsImFKrPYrS9o6S9vDynmqnme0mJwrYTG6+S5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 204/311] drm/amdgpu: validate doorbell_offset in user queue creation
Date: Wed,  8 Apr 2026 20:03:24 +0200
Message-ID: <20260408175947.026372427@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit a018d1819f158991b7308e4f74609c6c029b670c upstream.

amdgpu_userq_get_doorbell_index() passes the user-provided
doorbell_offset to amdgpu_doorbell_index_on_bar() without bounds
checking. An arbitrarily large doorbell_offset can cause the
calculated doorbell index to fall outside the allocated doorbell BO,
potentially corrupting kernel doorbell space.

Validate that doorbell_offset falls within the doorbell BO before
computing the BAR index, using u64 arithmetic to prevent overflow.

Fixes: f09c1e6077ab ("drm/amdgpu: generate doorbell index for userqueue")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit de1ef4ffd70e1d15f0bf584fd22b1f28cbd5e2ec)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -550,6 +550,13 @@ amdgpu_userq_get_doorbell_index(struct a
 		goto unpin_bo;
 	}
 
+	/* Validate doorbell_offset is within the doorbell BO */
+	if ((u64)db_info->doorbell_offset * db_size + db_size >
+	    amdgpu_bo_size(db_obj->obj)) {
+		r = -EINVAL;
+		goto unpin_bo;
+	}
+
 	index = amdgpu_doorbell_index_on_bar(uq_mgr->adev, db_obj->obj,
 					     db_info->doorbell_offset, db_size);
 	drm_dbg_driver(adev_to_drm(uq_mgr->adev),


