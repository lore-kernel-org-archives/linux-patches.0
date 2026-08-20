Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DFD37F8A0;
	Thu, 20 Aug 2026 15:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238950; cv=none; b=BLU43fppCcEx32ljUzW8EKwskTeNrkGVwJVP3tgI62gyv+BMhXnG+nVbc27YUPSpG8vBC9Wb3cjtY57RGomyrxhutApH+ARTD8FoMRkiz5y8WywXTXgxj7k/50auBma+TD2FIx9+zh5sdq7Pf4B+fr/UPZbaGbgV97guVhNKT7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238950; c=relaxed/simple;
	bh=mxHI0Mry7jXTkFqrEymb0hFv5tfdn6rRnhILTwuJZqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OblSH4qnNkr1HdxE42CDp8nkAPd6wcZuehJOwIccuYtU5U8wCf1zfNNr4uUa+Fko82kqPDGDYvxQSj9U0zVTlV1w4v/evJkiuZOp5+dM/DtgWMjTwcAG7ECypUTbp3n7Qgahww+6ZSpAfw0mysGvDe6czvknIkLYSI0eDFpkTDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hamHNcQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hamHNcQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805E11F000E9;
	Thu, 20 Aug 2026 15:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238949;
	bh=kedS0OasT0YKqdYzi8ooMlG+TSLfAOg95574cNC3inU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hamHNcQ5cuawf59amk6hRf6MuTKR9dGCxnTDpxdsJi7VmM1n1Gynjeg9FjDRq0Omf
	 oQ7F3ot7OBvs/WPrDep3egFGTiFrsp3tQIi4uP60oeJhNfdcVyRuUlVkZJoV5zYaFK
	 YVLC4fXSo76fkz4lnIFsX5rknS/UY+381q5xWFsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 097/217] drm/amdgpu: Reject UVD message with dimensions above 4096
Date: Thu, 20 Aug 2026 16:54:25 +0200
Message-ID: <20260820145240.667622214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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
@@ -654,8 +654,8 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	unsigned int image_size, tmp, min_dpb_size, num_dpb_buffer;
 	unsigned int min_ctx_size = ~0;
 
-	/* Reject invalid dimensions to prevent division by zero */
-	if (width < 16 || height < 16) {
+	/* Reject invalid dimensions */
+	if (width < 16 || height < 16 || width > 4096 || height > 4096) {
 		dev_WARN_ONCE(adev->dev, 1,
 			      "Invalid UVD decoding dimensions (%dx%d)!\n",
 			      width, height);


