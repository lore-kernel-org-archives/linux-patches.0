Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0FD1AA1C3;
	Wed, 20 Nov 2024 12:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107555; cv=none; b=jgMairfFkM8Ec8cKk1A8fKi8YhhcDxQT+E+59Me973lpBt2nER3dPKHNThFddy3Y0QVWrW37Q+5sLuRYM/7rd9IYAB1ckP+r1XxbArPQi6WlYkppA80NdgXiVLxC6aL9+/S7tGJDBmFlc4ryf1Rxq0upjugNR4U/dQhIl6haHRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107555; c=relaxed/simple;
	bh=vtppHxGOuvM8wNrj8lpbQ32lfYGbNNwPR7bAdOrL+ug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UP7dsBJ3tysJl6sq0b6m9GCNARFK8gHCCezRruU2fCdvrTfg89XE+1TNlI1qiqjpjjQSLB+HUHgsfWhqnIH2QP+g0Q9zoHzvgeb/bY2Pr6EvTF3fAa7PvqlvrxnUcwprNpVgPU1jNjhDvTPY2SC6le4tQc6pxmZTiOAJ4P1YhOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17d0so6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17d0so6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B29C4CECD;
	Wed, 20 Nov 2024 12:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107555;
	bh=vtppHxGOuvM8wNrj8lpbQ32lfYGbNNwPR7bAdOrL+ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17d0so6V8AfpEWrAX+nMqNxJL0IzsaKenJouLyxiN9cBncCYTsftpxZM1DJO4p43c
	 nqgyS2vUoh1jXc+LgauaTLVna7rnaMjUc1iu1vncBcPY84tX0jzaAq1if5qdqO+amP
	 z6MyDvse7q1gG9bkXDXH+UdLM8IZwSTStJpor6qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.11 096/107] drm/amdgpu: enable GTT fallback handling for dGPUs only
Date: Wed, 20 Nov 2024 13:57:11 +0100
Message-ID: <20241120125631.888448161@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 5a67c31669a3aca814a99428328d2be40d82b333 upstream.

That is just a waste of time on APUs.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3704
Fixes: 216c1282dde3 ("drm/amdgpu: use GTT only as fallback for VRAM|GTT")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e8fc090d322346e5ce4c4cfe03a8100e31f61c3c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -180,7 +180,8 @@ void amdgpu_bo_placement_from_domain(str
 		 * When GTT is just an alternative to VRAM make sure that we
 		 * only use it as fallback and still try to fill up VRAM first.
 		 */
-		if (domain & abo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM)
+		if (domain & abo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM &&
+		    !(adev->flags & AMD_IS_APU))
 			places[c].flags |= TTM_PL_FLAG_FALLBACK;
 		c++;
 	}


