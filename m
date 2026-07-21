Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3914415F0E;
	Tue, 21 Jul 2026 20:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665601; cv=none; b=VoSPQ5In1PmP7MTspA1yFnbhVdmu0ZTl+fTJ628nPqPjPc3V8i00/LY5PF3qseQolPQr0kstBss3ggQsXVmhTl7Bj37JNgoH061Z303j5StfKBtPITWHf178qfo10UCKhtP+KOcblEa1WFrPfi+zxJfO2QtFFOgAxud03JAoKHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665601; c=relaxed/simple;
	bh=jGfsGgGMz972l/XmtkTHAew2lXbT0mC155PlHzqqtUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghx1srxKatH/5lIn0Udc6Q0X6I/LAcPhotuuKLyI1IwtxncCiwGB15yq6EhfisSB6vbEI8cgwePkKRNByY+dl0+Zr0lsl0RWp2Y7GBZWYLlSlCUDIj1+gNzXWt8tvJysH5bzAXGxC79cDbxotaoQIzn5mof05idwyJUYb6TmVS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AtPQCWfF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AtPQCWfF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD7D1F000E9;
	Tue, 21 Jul 2026 20:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665599;
	bh=qdQbQu0UIM4wPK1B3WcvMDxqh7/3RwGHyEIoy4otlBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AtPQCWfFrpu6R4fpNQk3VKgUOOXcjR2lNcvYXt/TU4zGIwT9W+Tuc2UD5niOBYgxY
	 ngTPufs0Kd1ymzenMCKzCv5UJgmC9Z1JKrZ9HBns4xqaTqSgVBhkPIzSXDIie0WQM5
	 lm08RwhZgmGRJcZxpsV8dPWuswVsoY/vnsdOu4Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0363/1266] drm/radeon: fix memory leak in radeon_ring_restore() on lock failure
Date: Tue, 21 Jul 2026 17:13:20 +0200
Message-ID: <20260721152449.950386806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 82f1d6042611d45b8b9de423bbcb4e0ced9ec62b ]

radeon_ring_restore() takes ownership of the data buffer allocated by
radeon_ring_backup(). The caller (radeon_gpu_reset()) only frees it in
the non-restore branch; in the restore branch it relies on
radeon_ring_restore() to free it.

If radeon_ring_lock() fails, the function returned early without calling
kvfree(data), leaking the ring backup buffer on every GPU reset that
fails at the lock stage. During repeated GPU resets this causes
cumulative kernel memory exhaustion.

Free data before returning the error.

Fixes: 55d7c22192be ("drm/radeon: implement ring saving on reset v4")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_ring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index 8626171e9a6db2..537d9e21dc528f 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -354,8 +354,10 @@ int radeon_ring_restore(struct radeon_device *rdev, struct radeon_ring *ring,
 
 	/* restore the saved ring content */
 	r = radeon_ring_lock(rdev, ring, size);
-	if (r)
+	if (r) {
+		kvfree(data);
 		return r;
+	}
 
 	for (i = 0; i < size; ++i) {
 		radeon_ring_write(ring, data[i]);
-- 
2.53.0



