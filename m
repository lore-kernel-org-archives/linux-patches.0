Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B997F2F744F;
	Tue,  6 Jan 2026 17:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721580; cv=none; b=lgVU2o+hU75iCmlIiyJBu+5YKNGZPxXj2gPUdK732u0N1vRrx2OkJyUW0xnwBQtY91TWXw4CaVO6xte2qQdDoZpQc23YeNW+GNy0h6Zmophzx+gWBTjZuN8DnDrOyM1QSioBw+xmQt+KiDfHXCWaofpLJZlGZPYi4lOPqOjiLj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721580; c=relaxed/simple;
	bh=hN1vPZF3rCkXKJhF7/12iLtWEiYmY1bzy2P1fQUupkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fMl3gXVFXlgQBPNhCW33eQQRQ9cc98TmzHNN5KJ6kFf2tLh03gUko1R1BWS+oJlOKpf6H0Ry99Xr4+9HG9r+VbXpO7RgglLS3TEvSSd+HbEPeGhmsmjvbeN06Fhv3MIcC9oB4PI3WcYIPAueW/U3fHTAM3mkBPTVag3mFv0UIQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nk19CLjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nk19CLjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7977C116C6;
	Tue,  6 Jan 2026 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721580;
	bh=hN1vPZF3rCkXKJhF7/12iLtWEiYmY1bzy2P1fQUupkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nk19CLjwUcnzJCSBI0z6yAqEuQKuazkyJmNOp88QpaS6DyBR3CTfviiscEQev5but
	 SNpwK9+YTd2GRQ/ZxlCl4ylCAbmQ8Ef03XMGHfLxv2PpHycFB3P8wgVzbuMWXaKEDN
	 2LHaH4DpOEzzMSkKFSvV/Vfod8rIKyVoqD1E6LRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 011/312] drm/amdgpu: dont attach the tlb fence for SI
Date: Tue,  6 Jan 2026 18:01:25 +0100
Message-ID: <20260106170548.261873817@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit eb296c09805ee37dd4ea520a7fb3ec157c31090f upstream.

SI hardware doesn't support pasids, user mode queues, or
KIQ/MES so there is no need for this.  Doing so results in
a segfault as these callbacks are non-existent for SI.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4744
Fixes: f3854e04b708 ("drm/amdgpu: attach tlb fence to the PTs update")
Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 820b3d376e8a102c6aeab737ec6edebbbb710e04)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1066,7 +1066,9 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_upd
 	}
 
 	/* Prepare a TLB flush fence to be attached to PTs */
-	if (!params->unlocked) {
+	if (!params->unlocked &&
+	    /* SI doesn't support pasid or KIQ/MES */
+	    params->adev->family > AMDGPU_FAMILY_SI) {
 		amdgpu_vm_tlb_fence_create(params->adev, vm, fence);
 
 		/* Makes sure no PD/PT is freed before the flush */


