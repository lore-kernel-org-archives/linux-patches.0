Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBDB41B356;
	Wed,  4 Feb 2026 15:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218788; cv=none; b=j0k9oEsUtxRxpvlDIZDm3MGBBvO6hoiRSKspjwAhjsYDdxYdDdjNTVEGFez0QYdg3wuSKoawS9mJThi/gKHK9jkOXySyINTdvf/Etf7VCLu1fADru/+4NqrZRd0gKNJ3MK8HX+V3syBvayn8h88mpZvL43v3H6TKSfQSyxQgddQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218788; c=relaxed/simple;
	bh=zZE31RSx8ScZudavd+1OK4YDwFB+ctjvB0PBAaXVthQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y32jaFfJ2HUoUpag1/iwJMYau3rGSLhr+sTPPR8mMFV06o4Njh8UJI6Gfv343eXCB/Qr85LObHWv6NEe5LcP1qUOmQeM46m7tkwS+QVhj+kyRW8ZYcWgMEEsiilTatMeEFYeec94Nlj+xOwApWrmDOhTc+JCwhLYqY+1ThW9/ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7l6qzYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7l6qzYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7975CC4CEF7;
	Wed,  4 Feb 2026 15:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218788;
	bh=zZE31RSx8ScZudavd+1OK4YDwFB+ctjvB0PBAaXVthQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7l6qzYUJRFciHF9mSQcspDhR5Gp7qlS4yg/rOrY61YWxRHIZX9JOKgZ2YQjoX4yY
	 rEoR/toUpjaVRIqcwvwIofl7JYT8dr2xxk83D0HutfOKdjZDF8nHIfP5tGsIioOBSs
	 XYoMQ30jgaXSZRXkRG4IwAlpwe26A55ju032ziTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 62/87] drm/amdgpu/gfx10: fix wptr reset in KGQ init
Date: Wed,  4 Feb 2026 15:41:00 +0100
Message-ID: <20260204143849.150847110@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6729,7 +6729,7 @@ static int gfx_v10_0_kgq_init_queue(stru
 			memcpy_toio(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
-		*ring->wptr_cpu_addr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 	}
 


