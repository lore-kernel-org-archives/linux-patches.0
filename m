Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51E541B356;
	Wed,  4 Feb 2026 15:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218794; cv=none; b=XgwN3wRklgUl407XxambRaRhHPZG/m/TCg6IW9A/ZKo+1cdBuTvepFSlr29vegn1oE/EW0uIoechz9oqwOeoOlzSimfhq+jWhJ/pX5fgjsDMwW4wXxiPSwk9OUU6hn0jc/i1Oinuk3JHBWuooZf3QEe+xzTLJT0YEbov9y7z0GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218794; c=relaxed/simple;
	bh=7OqgB1ARxEzFO7EVWUQ31mBtAMTUcGJPSJm1zbko/10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P20OZT5C/pfvrfc3drJp0+XXJM3jkOpk5rUVj5YQR7Yg3Wl44p7Ez1WHm6reZNFEZJ031PuwQjInYhh0xlfwZAbtbpQx+/RShZ23wQoGP5+Fzwnq9Mi2cGVJcK3Ij0pRWsJg29DfWm25NgXfpOND3Z5fxIn2XVyJKBgjJYm6sxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyNTHhoq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyNTHhoq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5442EC4CEF7;
	Wed,  4 Feb 2026 15:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218794;
	bh=7OqgB1ARxEzFO7EVWUQ31mBtAMTUcGJPSJm1zbko/10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyNTHhoqugWqSczkRAxCtBQtMIaY6Kf/Hx0I9QcX/8/KQrv6xpYO0GF5hIScCaQW6
	 HcHoU52eWqS82IJcdwM3ZB/2GZn4iUsbD8g+pVKU6KZL/veUgb3oGcAYvQ80bXLlD8
	 DrzIQGRv7zYIE+DsLz11G42+hUNt/4NitoUTuCi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 64/87] drm/amdgpu/gfx12: fix wptr reset in KGQ init
Date: Wed,  4 Feb 2026 15:41:02 +0100
Message-ID: <20260204143849.222423200@linuxfoundation.org>
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

commit 9077d32a4b570fa20500aa26e149981c366c965d upstream.

wptr is a 64 bit value and we need to update the
full value, not just 32 bits. Align with what we
already do for KCQs.

Reviewed-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a2918f958d3f677ea93c0ac257cb6ba69b7abb7c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -2958,7 +2958,7 @@ static int gfx_v12_0_kgq_init_queue(stru
 			memcpy_toio(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
-		*ring->wptr_cpu_addr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 	}
 


