Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2764727F163;
	Wed,  4 Feb 2026 15:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218500; cv=none; b=kvgUC/OcOMGoTl6zaC/f5cFwH7eoklvSaKzYWf0t6pkCFqU0TESCixGWS2dVFM3biVzTpn0TyeGgU3wPuck6TsbPIAFUQAQ8KU1eLTmYPkOTB/cEcFp95/DR096uFwFcTytJzqvLogMqGs9KClvL9MF50M/RuYfPtiHgGRxPM+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218500; c=relaxed/simple;
	bh=0r8JJEp5zIspXilY0mT5qMo/D3lYCu/EgINIR7I+gGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pt3OOQafKlVwY9daIOawt78mDZhij246orv4XAPTPqqXr6tcD1Wjd5iA9CVjNgdGP4l06bIzecbrAzpjIQ4RTwDGfcf8Q3BPtCYhjH6m7vU6x5gVQkgmK2mPGm2zbgwj9zzhepX/UFvgjG4zM8mQWF279wBU+1PAhdcc0ECgiKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrNZ83r+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrNZ83r+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBE1C4CEF7;
	Wed,  4 Feb 2026 15:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218499;
	bh=0r8JJEp5zIspXilY0mT5qMo/D3lYCu/EgINIR7I+gGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrNZ83r+1zjUwAIVLAIr8aqp3rLdwwRxKXoQYv0kOrp76mDf30OOQ88XYV+0Q8XzP
	 8k9E+LGCEYrLwYZYe4SPXX4dQYPrClnX/yrN/FPPmXmz3ZBRZcGP1+LWpdCJmd3h2u
	 CX4P/RaQsOX4XjJsrCdIDRwA2WgjxNO0UQk3E5MA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 41/72] drm/amdgpu/gfx11: fix wptr reset in KGQ init
Date: Wed,  4 Feb 2026 15:40:44 +0100
Message-ID: <20260204143847.114966214@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b1f810471c6a6bd349f7f9f2f2fed96082056d46 upstream.

wptr is a 64 bit value and we need to update the
full value, not just 32 bits. Align with what we
already do for KCQs.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1f16866bdb1daed7a80ca79ae2837a9832a74fbc)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -3699,7 +3699,7 @@ static int gfx_v11_0_gfx_init_queue(stru
 			memcpy_toio(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
-		*ring->wptr_cpu_addr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 	}
 


