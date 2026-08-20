Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A79E377016;
	Thu, 20 Aug 2026 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238363; cv=none; b=XLflCjAlyYzd+C2Mm0Ffv3KmsQotHnwegrb5CNQ7pRHiJjznlYQq8GMcoy8hVZRJtVRsdK7R5056GL/e7rhIfgmtrJBNX+zqMD4mrX1XKgtS+93ZLyy7zesAgo0YTRTftPRh0wp6kv8ahB7H/06V2/Z7Baq+5BfkGl95eftk6GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238363; c=relaxed/simple;
	bh=Klx1HHzTSj3uBboiALvjJ3gWn93k5snQW4kfHFUOZ0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQ9zO8MFjoQLIRYyUa2bOTjxa15md4YM9sZXPOHWq9PIwzLh5clyxmPIGKYr3D3VWsGiBuTxuVDSY9cZUCehXsPd45csSJ3O8UcXry3QDppYdheqnMmVc3YY2HXrpakjHpemjW/AM+e0vNX1ZIZHinaOUGGNpd+/FUJSG6o7cvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8+JAVzr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8+JAVzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAB21F000E9;
	Thu, 20 Aug 2026 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238362;
	bh=FIg5swHJ5PcIYrsQxw6DM/PbBI2+2ez6pKgp/qs03D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8+JAVzrPrhnvq7YQIVoSAdpW1LnZ5bu2728xBHxDgkuBZbeKHXPYYP3rIZgFNwBn
	 4RUtcWsTffhcH507LQ6gnBnBihbBJqTbiVBYKJjZxYXiPSAn5QIEyigxE39vkxvhC5
	 J9Om6awEvfy1O79sJg5zP63LKwLBRrPtdGvVlTFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 121/228] drm/amdgpu: Fix UVD min buffer sizes
Date: Thu, 20 Aug 2026 16:54:23 +0200
Message-ID: <20260820145248.306900225@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

From: David Rosca <david.rosca@amd.com>

commit 18727670b44753865b81c56a9338c0d7bd102c54 upstream.

Use correct size for message buffer = sizeof(struct ruvd_msg).
Add ITSCALING_TABLE_BUFFER size.

Signed-off-by: David Rosca <david.rosca@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 37519d007e4261febbcf35b3045f8344f3145497)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -975,15 +975,16 @@ static int amdgpu_uvd_cs_pass2(struct am
 				  ctx->buf_sizes[cmd]);
 			return -EINVAL;
 		}
+	} else if (cmd == 0x204 || cmd == 0x206) {
+		unsigned int min_size = ctx->buf_sizes[cmd == 0x204 ? 5 : 4];
 
-	} else if (cmd == 0x206) {
-		if ((end - start) < ctx->buf_sizes[4]) {
+		if ((end - start) < min_size) {
 			DRM_ERROR("buffer (%d) to small (%d / %d)!\n", cmd,
 					  (unsigned int)(end - start),
-					  ctx->buf_sizes[4]);
+					  min_size);
 			return -EINVAL;
 		}
-	} else if ((cmd != 0x100) && (cmd != 0x204)) {
+	} else if ((cmd != 0x100)) {
 		DRM_ERROR("invalid UVD command %X!\n", cmd);
 		return -EINVAL;
 	}
@@ -1113,11 +1114,12 @@ int amdgpu_uvd_ring_parse_cs(struct amdg
 {
 	struct amdgpu_uvd_cs_ctx ctx = {};
 	unsigned int buf_sizes[] = {
-		[0x00000000]	=	2048,
+		[0x00000000]	=	3556,
 		[0x00000001]	=	0xFFFFFFFF,
 		[0x00000002]	=	0xFFFFFFFF,
 		[0x00000003]	=	2048,
 		[0x00000004]	=	0xFFFFFFFF,
+		[0x00000005]	=	992,
 	};
 	int r;
 


