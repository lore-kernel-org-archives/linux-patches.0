Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512652DFF1A;
	Tue, 17 Jun 2025 15:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175914; cv=none; b=tMiiyeyk8kdgNNm6Hku1GpGhD8VIDg1g0lPX+wh14mtLDYbhMljeb6PzOOB2OT+jwmH9U4vhS7IX80pbis9Bd49a3dYUXVkgrAtTvOU8QDRhBZ7GtaSGtlwHMWO7cNRudMzLNtNPQPPkf2mkvaxdmXGP3D4k+4wIH+9OS3JRYLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175914; c=relaxed/simple;
	bh=CXGnZt5gei2G0MT6epuGiA060mYUNZltc4/fEUvbPIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAr7/zmfEvx4+TimJFkl5fv7tLJpSpwBlv0EQ887raNb8rIyU6LZ8MNqtIguTZ+L4rUCfCviGLqKkuGfCTpOe4Ceq9OIJ4w/9+X1QXQYEWlXwwgl2eHke2+r50vsjt85rCzyWybxZA6uzaOK/h5U09LDJT6UBTEV1Gd31IjoLVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKl7YuQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKl7YuQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5E4C4CEE3;
	Tue, 17 Jun 2025 15:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175913;
	bh=CXGnZt5gei2G0MT6epuGiA060mYUNZltc4/fEUvbPIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKl7YuQaWqMUsJYCMc8POHTIz/f9VLovk2ZSEnCPCkJViljCd+M5TWD9vRrHJBlCd
	 78M2H4kihoR0acsAHP3WCj4puhYSbWjyto1SE3RCFYprIywKywuAQ27Ap1uh5URmMQ
	 FgKnEDtDGeL0DOt6n6HzeMq3jkIP3bgI4TNVfDQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Louis Chauvet <contact@louischauvet.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 134/780] drm/vkms: Adjust vkms_state->active_planes allocation type
Date: Tue, 17 Jun 2025 17:17:22 +0200
Message-ID: <20250617152456.961625897@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 258aebf100540d36aba910f545d4d5ddf4ecaf0b ]

In preparation for making the kmalloc family of allocators type aware,
we need to make sure that the returned type from the allocation matches
the type of the variable being assigned. (Before, the allocator would
always return "void *", which can be implicitly cast to any pointer type.)

The assigned type is "struct vkms_plane_state **", but the returned type
will be "struct drm_plane **". These are the same size (pointer size), but
the types don't match. Adjust the allocation type to match the assignment.

Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Louis Chauvet <louis.chauvet@bootlin.com>
Fixes: 8b1865873651 ("drm/vkms: totally reworked crc data tracking")
Link: https://lore.kernel.org/r/20250426061431.work.304-kees@kernel.org
Signed-off-by: Louis Chauvet <contact@louischauvet.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_crtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vkms/vkms_crtc.c b/drivers/gpu/drm/vkms/vkms_crtc.c
index 12034ec120299..8c9898b9055d4 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -194,7 +194,7 @@ static int vkms_crtc_atomic_check(struct drm_crtc *crtc,
 		i++;
 	}
 
-	vkms_state->active_planes = kcalloc(i, sizeof(plane), GFP_KERNEL);
+	vkms_state->active_planes = kcalloc(i, sizeof(*vkms_state->active_planes), GFP_KERNEL);
 	if (!vkms_state->active_planes)
 		return -ENOMEM;
 	vkms_state->num_active_planes = i;
-- 
2.39.5



