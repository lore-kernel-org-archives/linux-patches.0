Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D6E361657;
	Thu, 20 Aug 2026 16:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243287; cv=none; b=I1IZ85Z/jlz+iEL5s3jgq5OG/qpk40cTQBovFk8C0/THdeGubNEuwZdpgFSzLfHzv1By/CdGTECen4JxlkQQ+CwKtgbW9r3qB2GI6Sk1q8zJWRQLSTyIS7zooakez+XuafuroTJHMrBretG9AvGGqwBnPvkgwiGsuEJfJBfIs7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243287; c=relaxed/simple;
	bh=4uiYaDs0PsliQQtCdGL0xeyox7umEA7PhB4KzzqTBTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZJKnCagSyjiDF2oYpRN5c5tzhaAQRhLA4jPhOXjHfQbgorqu4I9UiV+OehoTFuQPuL/bgolXZO5BEM/zCfXoBCRsmFUvei8dR1ChikegSiZQ6dnIlJukiivx+Z3Y4Q46MET3aTmq6Qo/JTeWlr8y3PVEambuhy7CQBhVN8SoSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHiGw+CM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHiGw+CM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DF91F000E9;
	Thu, 20 Aug 2026 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243286;
	bh=40Vo3f0NibAELXU6QUJ/1qGQJmWplcydeBedk0tO4hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHiGw+CMrNiQwdhqmp+PArSlTpRbINdrIz4Bp5cA143/WP3eseoaSTI5Nme9LUqdU
	 fjU8JXxyTwFdNFHlWmugVRJZwMugWBM9HI0VL3gvWLP/QMBJlI32LK7e86uPnx4gMB
	 B++K/Z0w/0ic3UCYaU383EBOsG/HFo3cnXgdKy7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 043/272] drm/amdgpu: Fix UVD decode image min size calculation
Date: Thu, 20 Aug 2026 16:53:47 +0200
Message-ID: <20260820145232.517009406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

commit b8bb9ba3f101a1b0011f785a577a4a0a38371174 upstream.

This needs to use pitch instead of width. Also reject pitch
over 4096 to avoid overflow.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b41c8cb12e202b220353332ab87dc01a11f69304)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -739,7 +739,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 		return -EINVAL;
 	}
 
-	if (width > pitch) {
+	if (width > pitch || pitch > 4096) {
 		DRM_ERROR("Invalid UVD decoding target pitch!\n");
 		return -EINVAL;
 	}
@@ -751,7 +751,7 @@ static int amdgpu_uvd_cs_msg_decode(stru
 	}
 
 	buf_sizes[0x1] = dpb_size;
-	buf_sizes[0x2] = image_size;
+	buf_sizes[0x2] = (pitch * height) * 3 / 2;
 	buf_sizes[0x4] = min_ctx_size;
 	/* store image width to adjust nb memory pstate */
 	adev->uvd.decode_image_width = width;


