Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B4D3815E3;
	Thu, 20 Aug 2026 17:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247473; cv=none; b=T3LsxE+MT6TrQkjLDnYtdS27cKuZg++6b+LF1M6/JcNdEodYV/0OgWcgYr/xXyJFqQraDw7Z/1g76AaeGUQJBmB7Cpsq7hYcHGGOfJP4lGAEH4WY/Y/rsXjX/lLWRNyKpSp6bDqMrxfk64zMNtqhefWCZbTKySyzKGewcTStii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247473; c=relaxed/simple;
	bh=HNKGPMVAKF07NuzIf+6bvc1EHQd6z/bcliPShfdit6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzfA2VJ1/RoMJhEaWOH9OBaNaPFO3TKlxLsgXFAOa6hnnZq6QgXvjjNfYtY1QbgMoZgi1hHWeng2CxKQuAxxYnq7COsvvJ/a87CCHHymWMF8Ts3Kc8OA8zO0dgpl+v0LvHtGHL8PUNYSvgQD3kG1uIiRWjgltc5mxCgeem4PwM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0vfX7v0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0vfX7v0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E0C1F00A3A;
	Thu, 20 Aug 2026 17:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247471;
	bh=Kwrn2qTruVTEfgO3tDt2u+Alrx4HT0bbPFgFL2FpVsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0vfX7v02qk5u23fFcfILgqr65dAzlTM9J4TLOUAb218wNVNmEgCaad/QKvTwawwY
	 F4l1aPoTdZB06JpfUNVxoyH8IWei0No15TG4oM0KmLxdsDsvR4cPcD42P8CksN/csn
	 LkF8T7BTAKnbQJ6yyc64T/wFHHDT3o2NgRXzYY2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 058/166] drm/amdgpu: Reject UVD message with dimensions above 4096
Date: Thu, 20 Aug 2026 16:55:17 +0200
Message-ID: <20260820145212.898344029@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

commit 8c9aebcdd9f46f7a14b98d6ab18574b7a48fbb08 upstream.

Fixes potential overflow in DPB size calculations.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 05e1387d151f71569fbe122d2c89f9db0c21dc10)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -647,8 +647,8 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	unsigned int image_size, tmp, min_dpb_size, num_dpb_buffer;
 	unsigned int min_ctx_size = ~0;
 
-	/* Reject invalid dimensions to prevent division by zero */
-	if (width < 16 || height < 16) {
+	/* Reject invalid dimensions */
+	if (width < 16 || height < 16 || width > 4096 || height > 4096) {
 		dev_WARN_ONCE(adev->dev, 1,
 			      "Invalid UVD decoding dimensions (%dx%d)!\n",
 			      width, height);


