Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D541446AA62;
	Tue, 21 Jul 2026 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648079; cv=none; b=e9tH00xcaQKNwZK7xNpv9k6og0gUw9LQllj6eA8W7tvMq1QxnDrTSLIPM6T5tN783LSrr0OCKYxKjvdeHnAxwm4E149FNLFlzIbDo3zt5OsF5FDyTDM2TtgFo5qcTGIT+5bblHFiu7IJ6DlNs6t8cla2DfRLR0JTquUXvng/8wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648079; c=relaxed/simple;
	bh=tDtxzrzeC36az41WjaUhsn+kZUZ2CocC6gq2Q9FbGu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1sTdAn2vIHXaMeB69xSbe6txMv+HZF+mxVKIxm9DHnweKIuQ0Vx+6F0zEFE1SPyDth4VBHm0DeP7mjIWMAMJ/xOFHHSejqEB0EksxZxGlp8TYZ5mWSix9mk4PysKzyQR0WDqwHa/je+w0HR1cFXbE1FjyA4u8Rd+tUIq06lKk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cENYEZ3+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cENYEZ3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481FF1F000E9;
	Tue, 21 Jul 2026 15:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648078;
	bh=U2DzaQMjfV3Z7YkfUtCXAaG1DvTwU+i2KxDrJwXnZv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cENYEZ3+K6GWlRDMnT7W7o1NbDmuCb1IVFPiBmksySY7X0MpBT+pxorK5moq9W5Uo
	 LXGXaTiwOMNxjZ6UUn7DvtpDgLl1oO5YvjHjn+TdXTCU6euvmb1uztKlsX4GlVAlcI
	 YflhaWZdzDbqED6u6RyC4NDSYiwBvI9Hem3gz02c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0064/2077] drm/radeon: fix memory leak in radeon_ring_restore() on lock failure
Date: Tue, 21 Jul 2026 16:55:37 +0200
Message-ID: <20260721152554.204182971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



