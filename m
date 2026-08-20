Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52802DB788;
	Thu, 20 Aug 2026 17:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247478; cv=none; b=ca3wYdopRsWWWU9hBCBizHppKaGL+T9jFgeJ64Uu7KPGkpZl2v1iLmTFtvzySTKKzetzm8T7fuoYlVXlAKzvnLH4slGT16DV1JuASwdU+luHMZurmOXAdR2mzelft/RVng1EDr4aYkcLBWxrgppjXysHpmxbJfonpY+KHDvAGbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247478; c=relaxed/simple;
	bh=Db1Bqbs7rC5iaxQBsjl9lT13ib+lPUY0QmCOzCOyf+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqlgwbuVEOgid27zrGKqfP/FQMHX/kl0i2A/Oq6Ji+yWQBlsrtxXD43qLhOznt+o4EgKphKGylrgicNAQFcACif4/PeO/eC1B7ODFX5ZsdlIethdo7utFYogaPxwsSnuGUwaQXc8quwdGc60oqEqbk/fSGtTkUWfsWLqvpSD29w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9DBp1Po; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9DBp1Po"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5AB1F000E9;
	Thu, 20 Aug 2026 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247477;
	bh=6Gx/gjMJ1Tj/9r7m4XFuAEgeApLgz/ceAgyTIJF8Q8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9DBp1PoU0oCsx5MJCwwc6gCMAYumYXhTdWFUsa898iER2fwC6+k5Z2NSZLHEdkKx
	 wAnG/yHnsn/uqtnlYJbH8EsmOKVlc71+ilvM5gyRnA3Y8hF1PanTwNaHrnLIdi7VfF
	 EqvlYMQQ3y7LnuZeQcMJ6azklIdRdlf7fSBa06ZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Rosca <david.rosca@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 060/166] drm/amdgpu: Fix UVD min buffer sizes
Date: Thu, 20 Aug 2026 16:55:19 +0200
Message-ID: <20260820145212.954733537@linuxfoundation.org>
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
@@ -967,15 +967,16 @@ static int amdgpu_uvd_cs_pass2(struct am
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
@@ -1105,11 +1106,12 @@ int amdgpu_uvd_ring_parse_cs(struct amdg
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
 


