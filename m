Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A020D2943F;
	Tue, 14 May 2024 11:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685646; cv=none; b=Yc0YidOu9iX72wz6hsdo1qoWzq1FLMXJPv3++S/Jr0uoNb8ByjJQGZfo5O6oHswuZ30KrHLynX9IJL/niYSPAf5Eu7fyUM+5xb0fksGdMF6MGsUZhuWNmX93rtAGzGplltxu7r2z5XrTNjwJ7XqhNDwUuGQA1djmM4k1AGzAgk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685646; c=relaxed/simple;
	bh=Kgoa7cgIiGMYDmYEgibk/RdVEHw3PaXeRxZCOJc3ZDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Adxw4ZKPR9Yw9gMvH9yoqy6xjhLGZx036yscE+WDgl7WyMhU8jkarhgLs7czwrzwsuY9Hud1hCyZk63shqaDMeRWm58YhJS7GftLnootyl1x8jvcIaKLyi6eJGg4edcxJHu3JOpORIBCHTAhGIwfBAxz0nDwm901JxQRD30kkdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK8AedM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK8AedM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09491C2BD10;
	Tue, 14 May 2024 11:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685646;
	bh=Kgoa7cgIiGMYDmYEgibk/RdVEHw3PaXeRxZCOJc3ZDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK8AedM2nginA/fToYKLQrO2xPRAbrTCiQtX6gDsTRCIcI3cpRrx5ktCNofNLaFdx
	 QhiwwsEOXIWtmaoEkayvx3ugteweyj+IRQct42IrpLnORpi/ECUhbou7uSv4Y2s0hY
	 G4zpBssDOT5pXswoiJLSKlDcwn/ry0IhENan6Cig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
	Jeremy Day <jsday@noreason.ca>
Subject: [PATCH 6.6 220/301] drm/amdgpu: Fix comparison in amdgpu_res_cpu_visible
Date: Tue, 14 May 2024 12:18:11 +0200
Message-ID: <20240514101040.563778372@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <mdaenzer@redhat.com>

commit 8d2c930735f850e5be6860aeb39b27ac73ca192f upstream.

It incorrectly claimed a resource isn't CPU visible if it's located at
the very end of CPU visible VRAM.

Fixes: a6ff969fe9cb ("drm/amdgpu: fix visible VRAM handling during faults")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3343
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reported-and-Tested-by: Jeremy Day <jsday@noreason.ca>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
CC: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -432,7 +432,7 @@ bool amdgpu_res_cpu_visible(struct amdgp
 
 	amdgpu_res_first(res, 0, res->size, &cursor);
 	while (cursor.remaining) {
-		if ((cursor.start + cursor.size) >= adev->gmc.visible_vram_size)
+		if ((cursor.start + cursor.size) > adev->gmc.visible_vram_size)
 			return false;
 		amdgpu_res_next(&cursor, cursor.size);
 	}


