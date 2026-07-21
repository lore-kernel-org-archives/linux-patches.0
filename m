Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A8444AB96;
	Tue, 21 Jul 2026 21:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668719; cv=none; b=YtyyU8PpLS08VLs/56iEoBFUOcJdh2p1s11ge8a04O9O3Y8CJeXv3+tlRyJmbGDdC3eIYKNR/D/RPIDTmice3pi3e1O7qhvuwu8DwxB3waJrQ1pu2hLO64//hATzTOBjHMY38K6t0CrKZaHSq6NYG4lP5mq2mhgVG6PlApw8wk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668719; c=relaxed/simple;
	bh=VtgwsC1PT61ppPYc//ZoPh3qUiuq5O6gmgWs4D1zAew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ge5vismAsJX8cV8fXaH7O7CtfzOM/AWGJVP5PXY/lQWGgsUBdaiXltuAsBaho9nM8XcSHfxKV51ZgEUEVAqFcTzyKCdrCqGZ30+WUkksH/3/asykGJ4nkLYBelrW/8Ch13mG4MasSEIZ+2ODDtZEMEdBr5/nqEo2RGu/oS9jmhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQs9SMo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQs9SMo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FD61F00A3A;
	Tue, 21 Jul 2026 21:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668718;
	bh=gu6U3KC8FyhwSxgJRTAMkN/zO85ou5lCJ/R7QNh1qO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQs9SMo2xCGzt5iG+q72AZ7wTQc2fX79BQYFXsM+HlCMhcDYs3SpQO662YhfABbmL
	 pQiUD7cCz1AfpEK6vkVm6AAm80VvmT6pwbK0OCGKPPopK+58vpBRhXW/OVGilDA39h
	 VgQt5P+HCON7YOo+kQ89Q9fhQvMJT7tOBAcrzb2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0280/1067] drm/radeon: fix memory leak in radeon_ring_restore() on lock failure
Date: Tue, 21 Jul 2026 17:14:41 +0200
Message-ID: <20260721152430.865193413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7e207276df374f..e009ee1559c8ed 100644
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



