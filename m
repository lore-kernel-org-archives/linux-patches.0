Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60ABF19FA91;
	Thu, 15 Aug 2024 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731350; cv=none; b=XCqtqHhqab3bOT1o/b/suaursvAZnTDN/jZzICSfZ58OMhxm9IBQasvRTxcxSvkZfMD+KWMzidMy3cw1B7IOzo4YZ5NiUxCSkMjf8AHD0qfnGGg/m1I2RAP8RCSGdul0HqcV6cVoaYmQHGuaYZIWIcH8x1p0yIJ3uj3JDvctqUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731350; c=relaxed/simple;
	bh=c2WbSisLtwYX3ZgMq+VBnx5BC7Jmyz8NxVxAkpyYNhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1KQwx23HYxH59k413O7kUcYGMXlgwqbT2oO71oJQO6QYEC5Cy6BEpv6WLdZsqWipu+wui6wGH1wyOh8nAp969hFm5B/uXMxt9kl2roAjKbkEUY2zzO63r3TJWtdgW4zBCOHWL24qzqCw4aQEH5UsVkeR3xCka/a6q/tjbf6ENI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBDyR1Mu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBDyR1Mu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC74CC4AF0C;
	Thu, 15 Aug 2024 14:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731350;
	bh=c2WbSisLtwYX3ZgMq+VBnx5BC7Jmyz8NxVxAkpyYNhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBDyR1MuhnhMk17bOEmttDXbtSQ9RqydJkp0YJhWoKAZo1QgV0Q8bGFz+BFMwlYoO
	 8lA8J5QhxSgvriYbV48viluJl8bGKgnkGyo8gEdVNySQrgz7dOPNMzyNlW3aAxzBxI
	 tV3QSrYOtB6eB94BHMLQaUzkrkBdTB3zfi98KFaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/259] drm/etnaviv: fix DMA direction handling for cached RW buffers
Date: Thu, 15 Aug 2024 15:23:13 +0200
Message-ID: <20240815131905.127481291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5107a0f5bc7fe..2aabe8433cee2 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -363,9 +363,11 @@ static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
 
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



