Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58927DA9E;
	Thu, 15 Aug 2024 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729554; cv=none; b=ZjuLOwjA4u5xHCzAmYVx76ime0tkY8GUD9XukHNHSGxzSheCRUbhhqHoUpEyq2HTYMclu3VuvcKJkNDrOegGJesrHw66vxRbmMhqI+atYEVkFVouoD4SUh8Mds1GN7rn9gotGeXXTsWHMSnE2oQx1OpwisPIRVN+KqjMW2+DdPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729554; c=relaxed/simple;
	bh=kg/x57ZofqX2R6YJUgDjkYoCEIVo/94HVnUO6+mQjbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blElbKYnDorM4ap3g1yPEGL96V7b2ksDqBa3SBhOM8UUMBWIJoWj1Ji/bWNDsMlgwfqx0YsdoLoKLv/oJn2+V8XdBec3AsxJdQfv6W1IVJd9oryngkv1wLcTkGy/Ygt1DJM+WIbyJyozT5jD7ezNFqg6F/Q+RRKAV2xZd8L32Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skQGCyO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skQGCyO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCC9C4AF0A;
	Thu, 15 Aug 2024 13:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729553;
	bh=kg/x57ZofqX2R6YJUgDjkYoCEIVo/94HVnUO6+mQjbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skQGCyO7N1hkwNZDKct0VSmtIEDBNgnXT9rdPTmVI2gHc/GWVv6aaJDg2EHl9FJoq
	 UsRNHa0YZ/SitkJyPp9PsYGDEK4SoZ8j6mpr0IDLagptbbYx8XM9+v0/ns5jle68Yh
	 DoAg75y13S557d8DMcU2GSftAQH1vAIsmRCAKbX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/484] drm/etnaviv: fix DMA direction handling for cached RW buffers
Date: Thu, 15 Aug 2024 15:19:21 +0200
Message-ID: <20240815131945.275200340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 58979ad6330a70450ed78837be3095107d022ea9 ]

The dma sync operation needs to be done with DMA_BIDIRECTIONAL when
the BO is prepared for both read and write operations.

Fixes: a8c21a5451d8 ("drm/etnaviv: add initial etnaviv DRM driver")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
index f0b2540e60e46..87da2278398ae 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -353,9 +353,11 @@ static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
 
 static inline enum dma_data_direction etnaviv_op_to_dma_dir(u32 op)
 {
-	if (op & ETNA_PREP_READ)
+	op &= ETNA_PREP_READ | ETNA_PREP_WRITE;
+
+	if (op == ETNA_PREP_READ)
 		return DMA_FROM_DEVICE;
-	else if (op & ETNA_PREP_WRITE)
+	else if (op == ETNA_PREP_WRITE)
 		return DMA_TO_DEVICE;
 	else
 		return DMA_BIDIRECTIONAL;
-- 
2.43.0



