Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB0E41DED0;
	Thu, 30 Jul 2026 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423331; cv=none; b=GFVVZVvdglcVFV+nczSI7F/lIUFSYWYFk+zZPSBqYT/kBAaZU7mWm1wGm6xsJWqlT/LtS38sk5ZwpiFQTDnE72jsXV/9+q5ebkDkn8CcJgkGGNqdnhwiqxCxdkr0gjtoiZ0X9DuF94zBC+zcDSG3zO8fTeeHqBeg47FnWay+1ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423331; c=relaxed/simple;
	bh=hBM0NJ+DAp7TzQxZB1rDkiTweGDonEE/TYK93QMe2Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTRS0xp7UujsWvfbyjA0acFHJhkPQUVeznvusuhkVRRwDP8ZZdQH1osXCO3tRHtJlrnKycp1Lm4dMTdwDtNmdVqsjsOlPbcgcsN3cvD7NFsllApdyu0qARRH8LdtefnTjLraO83watCdIlif9NN58Ag3VW7xSvwE+r3H1eEzN0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rK9lS40L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rK9lS40L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92E61F000E9;
	Thu, 30 Jul 2026 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423330;
	bh=NGsg3sJNSrPZXRow9sOpMj0l6ZjNCDDunYHns5mZa3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rK9lS40LUeeE2l8khAuUrrHiuS+JtSlRMyilcwjje0e28h6GeDfpmF0hYBxRblsdp
	 xPWHWKAoH32uxudU9DAns27552ImHSgHWVIqLYmAxOd13H1Jf5rx/CHBWIw0B1qus5
	 Ml8QOQbJP5GwrXsEJ+/klpGNHO6Gx8Cd5Kea0Uqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyuan Zhang <boyuan.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 703/744] drm/amdgpu/jpeg: fix jpeg_v4_0_3_is_idle detection
Date: Thu, 30 Jul 2026 16:16:16 +0200
Message-ID: <20260730141459.217213488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Boyuan Zhang <boyuan.zhang@amd.com>

commit c44af3810fc8b3adf6910a332038aa566560c8fa upstream.

jpeg_v4_0_3_is_idle() initializes ret to false and then accumulates ring
idle status using &=. Since false & condition always remains false, the
function can never report the JPEG block as idle.

Initialize ret to true so the function returns true only when all JPEG
rings report RB_JOB_DONE.

Signed-off-by: Boyuan Zhang <boyuan.zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e9df8e9d04e0593d17ddb069f3b7958991cd18c9)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_3.c
@@ -1010,7 +1010,7 @@ void jpeg_v4_0_3_dec_ring_nop(struct amd
 static bool jpeg_v4_0_3_is_idle(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
-	bool ret = false;
+	bool ret = true;
 	int i, j;
 
 	for (i = 0; i < adev->jpeg.num_jpeg_inst; ++i) {


