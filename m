Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CDD293443;
	Tue, 17 Jun 2025 15:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174447; cv=none; b=QzDNMEw/dqPND3oYOnj6f1wHEGU2CjVEVwpl+bV1zNdnYUyr3xiWJF8Lhaj6NnFXLI3zaSPe2hx5mK4af0HerSo5Mk6tv5TV1AS3i4+uwZJ+RRnKAYW/y8hgJtn77zlhyC52a1IRkvNEi8EQNQjiWOZ3iHKhv5ShNcNnRla+a5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174447; c=relaxed/simple;
	bh=6l+60ocqVvQwhna7d0KvAtzOxUWHdN8zvRY5srvUq0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gp1x369dBHNKhz2teYNAa7ePKxaO9JVow31Mc5yKtfFQF0Pxrl+NzVYkSWEcpkguAzx1oYlcXfIUtIXsyzDZHDEQv6b40rkt2vxtWDDdydna2ZeO1/D0B9mWTHd2PD2JgiCKH5TAEuJQzJuuVbLDh9ri4NYpXhvgrBuAwNCNi9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFt7lhX+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFt7lhX+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C452CC4CEE3;
	Tue, 17 Jun 2025 15:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174446;
	bh=6l+60ocqVvQwhna7d0KvAtzOxUWHdN8zvRY5srvUq0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFt7lhX+vPhaMVDl0+Uw7XEXUFNZUxGsEUaA+C67L0ilEn0kalZKKFf7foiIwiVeb
	 SiluC4X8q/uQApNdr1Uk4iosWf1V82UFUyKxf+0pWugN0hBvs2k4hgdIxB4uIjItxp
	 2g2Vs8WqIT7+kEp/THw01eKlGRudng0s7QKrxpHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Louis Chauvet <contact@louischauvet.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/356] drm/vkms: Adjust vkms_state->active_planes allocation type
Date: Tue, 17 Jun 2025 17:23:05 +0200
Message-ID: <20250617152341.043777465@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 61e500b8c9da2..894c484f99e95 100644
--- a/drivers/gpu/drm/vkms/vkms_crtc.c
+++ b/drivers/gpu/drm/vkms/vkms_crtc.c
@@ -201,7 +201,7 @@ static int vkms_crtc_atomic_check(struct drm_crtc *crtc,
 		i++;
 	}
 
-	vkms_state->active_planes = kcalloc(i, sizeof(plane), GFP_KERNEL);
+	vkms_state->active_planes = kcalloc(i, sizeof(*vkms_state->active_planes), GFP_KERNEL);
 	if (!vkms_state->active_planes)
 		return -ENOMEM;
 	vkms_state->num_active_planes = i;
-- 
2.39.5



