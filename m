Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42B333C1BA;
	Wed,  3 Dec 2025 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777255; cv=none; b=qr8VAX9KVGcNLqmWm4lh4utLniJ8OWxFhylHpZ9hgTxM5BWNoROgWbRqyBKWuroFcIjKDoM1CNnQbu1bFgEZ3HfEzxxdNlajQR/nhB1aII9nd8LuuBlV4WISpOxpZa3fmIFyXpHuWl4Yynlf6nkpIfcG6cGt99+aQN7eWPWwEJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777255; c=relaxed/simple;
	bh=m3S2KYGE+O9j4MIyByZ9Cc8IzKkW4+VZD4Kmv+s6D0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BYDe1q437KlCRQDv2NSET+maia5mmVa2mz348qn2JV9sfzaYypgCStbQqXvKACqshypCLNy6TPKuadiisPi0LAjMolTNCoixLGnsuYGSCyvQ7nyki+8ZYuodurpBtATC30HvHUfqnxFNF+JVgUYVZ320Qbb7M40fw1apJS3Y7Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QZ4L3+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QZ4L3+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75752C2BD01;
	Wed,  3 Dec 2025 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777254;
	bh=m3S2KYGE+O9j4MIyByZ9Cc8IzKkW4+VZD4Kmv+s6D0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1QZ4L3+Pu9gbrQhZGHEZfnw2r3PP09NMem/y3fZPKzGjj+wEeyLVINoQGLmx2B3Po
	 e37RQpfQlKQ1v5NW77HSHn0qcLeKslN3UrFLpg7fjzQosp3gpHg91KW/MqGUJ7oKBx
	 yKTWPvXLVX7JukeUfTN6V3Yhrc5kp56vBlTqpe2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs update
Date: Wed,  3 Dec 2025 16:28:27 +0100
Message-ID: <20251203152351.182356193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prike Liang <Prike.Liang@amd.com>

commit b4a7f4e7ad2b120a94f3111f92a11520052c762d upstream.

Ensure the userq TLB flush is emitted only after
the VM update finishes and the PT BOs have been
annotated with bookkeeping fences.

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f3854e04b708d73276c4488231a8bd66d30b4671)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -1056,7 +1056,7 @@ amdgpu_vm_tlb_flush(struct amdgpu_vm_upd
 	}
 
 	/* Prepare a TLB flush fence to be attached to PTs */
-	if (!params->unlocked && vm->is_compute_context) {
+	if (!params->unlocked) {
 		amdgpu_vm_tlb_fence_create(params->adev, vm, fence);
 
 		/* Makes sure no PD/PT is freed before the flush */


