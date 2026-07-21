Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305233368B8;
	Tue, 21 Jul 2026 17:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655595; cv=none; b=OEJ/qxjX4vnmIQt9MhPcufy4sIIJVffqKtXfS7uVf0jAT0D+fKS3YQkwf/WxJ4FOFT6MXkNdL7Bm94ud06Z/VsSwK1dg1W4qE2XA19XYHiwDvmX8ZHplHvMi0TLJ5ak6/XS9dTBbgf+21tiuZ8f2AgleUxDzVNEnNpLymFdm5mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655595; c=relaxed/simple;
	bh=L+1sUztipsDiO1lhI237zHgVyOGhuognGoPHMMi4A1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEMQuM9j3IGz7JdrCgqHC98SqHWQTh3VDOsqBVeIipYWetoIxgMakkFfrVORlp4KdPccQdawQbyhzadTsYs7ZlZY2B9WXksV70nvgNiLRXnS/96Lj5XnQR7kyCbA96KOOzxLHuDMVYrWGWe/SUypUuZ43PhSk7NEw6jaVd/KGGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzOkFTzH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzOkFTzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963211F000E9;
	Tue, 21 Jul 2026 17:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655594;
	bh=J690PrTnfowUJ12LV0bh1d95T7k/lf0cti9geiihBEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzOkFTzH0CfVQ7PnBsGEiowc4Ox0FekGYFCxpMvuNOOCS4XEMobfhN8OUHgjkA8XA
	 A1gzcqspZTAtJsEewxPvCmJJGT8w57AC7oPKZOvVBL322/3C1r5Kh9fhfHiHQg8biE
	 Zc2M/MkrWVBd2VOnGC6PyqI+Ti7zHxriXu4XqVuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0068/1611] drm/radeon: fix memory leak in radeon_ring_restore() on lock failure
Date: Tue, 21 Jul 2026 17:03:04 +0200
Message-ID: <20260721152516.364582496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 581ae20c46e4b5..a5dff072c1ac03 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -356,8 +356,10 @@ int radeon_ring_restore(struct radeon_device *rdev, struct radeon_ring *ring,
 
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



