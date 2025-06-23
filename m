Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F7E13A265;
	Mon, 23 Jun 2025 13:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685402; cv=none; b=GS49dZoMFJKzCy4KrLfoHmjeg06NNSVWdsWUTeNZEXisZR75cy2vQuH7RZ8unXWLpsiwwutDXILS8MdJPMUAWO9bvPMio/a1BvkLQ99Nun7nzLR6NRGslsWV25E3Ru2bZJTYM02nEqGd7KemxOPnwTQcy5XrBG2JPp9oQRR3Coc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685402; c=relaxed/simple;
	bh=1LJRWjSO/RE+T6r3ZCgg+SrAnlV/W9zO/i8Z54LpkTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVQ5YCb3/WTZHEsCt1Dlic2Y5CdpLbg7iGLyLNcQ1qGgK4WlgLwF7qe01GWlbbwytKO/ywbFdPOLS/1UUv0h5YXRc5E6SPOgaUwQm0RPI0De1HizEqRYIndyoVDyYFEj6NsvPmEgTjn19WNvjr0Pg+Sqjvw2JLIMEjo+zor21e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNg2guWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNg2guWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2F9C4CEEA;
	Mon, 23 Jun 2025 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685402;
	bh=1LJRWjSO/RE+T6r3ZCgg+SrAnlV/W9zO/i8Z54LpkTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNg2guWd2pFY8j09Zza9P71r8NIRtpsEWYkrk++IYYTYAYqu+X7ZKLyXSK7VFkV4Y
	 WeQBaY23pjjwOJY/+jQawonwtWozELb0E90a8ShaRiWS/3jPZOe/OGYPn7Dkh1AuBc
	 1TF9FqTWsrYfFLy9FC2bGgCyD6yrwkAQM8FW6/RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@nvidia.com>,
	Dave Airlie <airlied@redhat.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 258/592] drm/nouveau/gsp: fix rm shutdown wait condition
Date: Mon, 23 Jun 2025 15:03:36 +0200
Message-ID: <20250623130706.437047947@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Ben Skeggs <bskeggs@nvidia.com>

[ Upstream commit 7904bcdcf6b56602a049ed2b47282db63671fa99 ]

Though the initial upstreamed GSP-RM version in nouveau was 535.113.01,
the code was developed against earlier versions.

535.42.02 modified the mailbox value used by GSP-RM to signal shutdown
has completed, which was missed at the time.

I'm not aware of any issues caused by this, but noticed the bug while
working on GB20x support.

Signed-off-by: Ben Skeggs <bskeggs@nvidia.com>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Timur Tabi <ttabi@nvidia.com>
Tested-by: Timur Tabi <ttabi@nvidia.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index db2602e880062..6a964b54f69c2 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -2838,7 +2838,7 @@ r535_gsp_fini(struct nvkm_gsp *gsp, bool suspend)
 		return ret;
 
 	nvkm_msec(gsp->subdev.device, 2000,
-		if (nvkm_falcon_rd32(&gsp->falcon, 0x040) & 0x80000000)
+		if (nvkm_falcon_rd32(&gsp->falcon, 0x040) == 0x80000000)
 			break;
 	);
 
-- 
2.39.5



