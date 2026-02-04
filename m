Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0064D42AA9;
	Wed,  4 Feb 2026 15:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218119; cv=none; b=qLqSVAa4lGrdHi5eQJZfWdQXXXYjdCR0jz5RY4W2zKmRDSI7k6NypscmcwLG1CH8DNvoUbnI2eyLrdPy5MOtUTWCfZaF0M2MOEEMh5BsR9ax8sqR63dhABMU/KzkMm069HE+nq4EHmTZyw/e3aH98XtLo5zNpy1Fxr/mpmCo+bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218119; c=relaxed/simple;
	bh=rGHecmpUtna0kXbFE72TgBF4oDyb/vQsDIcjDiKICTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CCclNufHbFAvUEv0HIEPka/XAFnrRH8KWgzUGIn1gnq2l8/9DGzSB7eFQGZavXVUwEed1Rh5jymz2qxqWUyPjMuFVl0dpFkbMLH4ZiNcXvhNdJzH/0JDLKAuhF1zm0K5r+m85pfY8KT7OXahnfCnBrFUSkQH4XoO49ONPy68Wyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jIh09ytv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIh09ytv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1833BC4CEF7;
	Wed,  4 Feb 2026 15:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218118;
	bh=rGHecmpUtna0kXbFE72TgBF4oDyb/vQsDIcjDiKICTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIh09ytvHiAzI20HTvbZmBUQhi9ku5r4MpoT+R177VvQdqb7zvLbE1H/kBUHTJwCL
	 LmhZ5TC6SQBbn99/g0NZwJGUwoCg6TCNS0RgXpjtKB0qRBKOiYiUHMWjU8LlXZDZot
	 GBMU/XxOVSe/NbQ3RlMtvWic1IUViOxSGARdfIck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 217/280] drm/amdgpu/gfx10: fix wptr reset in KGQ init
Date: Wed,  4 Feb 2026 15:39:51 +0100
Message-ID: <20260204143917.416912706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit cc4f433b14e05eaa4a98fd677b836e9229422387 upstream.

wptr is a 64 bit value and we need to update the
full value, not just 32 bits. Align with what we
already do for KCQs.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e80b1d1aa1073230b6c25a1a72e88f37e425ccda)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -6584,7 +6584,7 @@ static int gfx_v10_0_gfx_init_queue(stru
 			memcpy(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
-		*ring->wptr_cpu_addr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 #ifdef BRING_UP_DEBUG
 		mutex_lock(&adev->srbm_mutex);


