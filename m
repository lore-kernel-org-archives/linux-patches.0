Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ADA18859B;
	Wed,  4 Feb 2026 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218122; cv=none; b=moKgpj/jWommz2jvHGNMSQLIB2XKJuZ0i3pYXX4yITnSuJXiZBLAPo2DX+j95WtX8GFUOySr1/NPkuuc9pKI30Na9uBQQTVY9TXjf9oh/3AWfeNFKqEgKmLQ6wzTo8+MSOKs1ps+4Qmk0P6xKMmHb92U6docXqlwclz2WEXA4iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218122; c=relaxed/simple;
	bh=1Qf4uWsiwyXIxQTLN8Hx7z7677NDvvQ8jHF8W0hddeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HRSTCylJOronZxJkHJ7rLkL6jUwbJVckCXnm4kk5wXI94TRJxuzQcqW19oldmvNr3i5iqQdlz/5Yqor/qnuK7usyO8KsyGsuCNRaEKMYJorGkc27rmsSkF+WnRFqNjyGG6opwfx7JD6DQio8SRXIoreanrsZZSBAgPQ8wXR/cwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjucrjBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjucrjBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C230C4CEF7;
	Wed,  4 Feb 2026 15:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218121;
	bh=1Qf4uWsiwyXIxQTLN8Hx7z7677NDvvQ8jHF8W0hddeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjucrjBhM/sSo9b5k5MWNocZ9Cs7HttQmawy7G6MtMXyYe/Ou8xVP9LdSABLk71mK
	 A7hECeS/4n2PxP4EgOCs4FogHwx9AbKYSmUHDZkGPzvt7jp4l5AR/ZESsm4HH2VaXS
	 TG0YBQJDvPq4CtS8LANWhZqFE0qC9NQMNfqlXzww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 218/280] drm/amdgpu/gfx11: fix wptr reset in KGQ init
Date: Wed,  4 Feb 2026 15:39:52 +0100
Message-ID: <20260204143917.452623937@linuxfoundation.org>
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
@@ -3716,7 +3716,7 @@ static int gfx_v11_0_gfx_init_queue(stru
 			memcpy(mqd, adev->gfx.me.mqd_backup[mqd_idx], sizeof(*mqd));
 		/* reset the ring */
 		ring->wptr = 0;
-		*ring->wptr_cpu_addr = 0;
+		atomic64_set((atomic64_t *)ring->wptr_cpu_addr, 0);
 		amdgpu_ring_clear_ring(ring);
 #ifdef BRING_UP_DEBUG
 		mutex_lock(&adev->srbm_mutex);


