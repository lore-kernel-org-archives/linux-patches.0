Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58025481C4;
	Mon,  1 Apr 2024 16:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989621; cv=none; b=ZM3lmXnMR4PXKtoAXIg2YqXs5b8qn9lScbqypH2jPddjDtDxpa8dAmUgAFmyi07bGAQlNYFDjCdP0W+nd//cYxxM2AU/TK/4wIR34aDPNbE6C1e19Mnw/PAkxcdp69zR0CwC9ZgACOwDc6n0zOm3HJQjNHxCsS07IieTAPhBJOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989621; c=relaxed/simple;
	bh=tWsEPmiR7KGjcn1uJl9p9eFK1Cc2jEK9kBc63rWahFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdxC19TTifxOKWXoR7tvelxQn5IcBWZoe6a4+tKAHbLvPYXfdX6080urI8K2okNWljR5uVqgaQRfeV7FzE4Fh7m9ycIwiNN5tEsfEqr4yRHZVKRGHwVpAga/65w9bsHvfjfJlv3yalcSna+bcx66JRYUkoWgfGeoePGHM0ZW6oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAqrD3t3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAqrD3t3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB579C43399;
	Mon,  1 Apr 2024 16:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989621;
	bh=tWsEPmiR7KGjcn1uJl9p9eFK1Cc2jEK9kBc63rWahFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAqrD3t32aLxTi209taxqA2iZhu9/mVoRY/hHoh/NZzupJzY4/OyEqH+81JguvLMm
	 rW1ngxM5dDSVparG2cMOprH2sw+/nN5BB9qFjURZP9jdjhOlwGQ99FAhPeI7cJtPPP
	 ICURyq5PISw4LhxJVQ3w1ptCuE/wLFUBHDkRPQs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/396] drm/etnaviv: Restore some id values
Date: Mon,  1 Apr 2024 17:42:33 +0200
Message-ID: <20240401152551.022129732@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Gmeiner <cgmeiner@igalia.com>

[ Upstream commit b735ee173f84d5d0d0733c53946a83c12d770d05 ]

The hwdb selection logic as a feature that allows it to mark some fields
as 'don't care'. If we match with such a field we memcpy(..)
the current etnaviv_chip_identity into ident.

This step can overwrite some id values read from the GPU with the
'don't care' value.

Fix this issue by restoring the affected values after the memcpy(..).

As this is crucial for user space to know when this feature works as
expected increment the minor version too.

Fixes: 4078a1186dd3 ("drm/etnaviv: update hwdb selection logic")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Gmeiner <cgmeiner@igalia.com>
Reviewed-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_drv.c  | 2 +-
 drivers/gpu/drm/etnaviv/etnaviv_hwdb.c | 9 +++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.c b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
index a8d3fa81e4ec5..f9bc837e22bdd 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
@@ -494,7 +494,7 @@ static const struct drm_driver etnaviv_drm_driver = {
 	.desc               = "etnaviv DRM",
 	.date               = "20151214",
 	.major              = 1,
-	.minor              = 3,
+	.minor              = 4,
 };
 
 /*
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c b/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c
index 67201242438be..8665f2658d51b 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_hwdb.c
@@ -265,6 +265,9 @@ static const struct etnaviv_chip_identity etnaviv_chip_identities[] = {
 bool etnaviv_fill_identity_from_hwdb(struct etnaviv_gpu *gpu)
 {
 	struct etnaviv_chip_identity *ident = &gpu->identity;
+	const u32 product_id = ident->product_id;
+	const u32 customer_id = ident->customer_id;
+	const u32 eco_id = ident->eco_id;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(etnaviv_chip_identities); i++) {
@@ -278,6 +281,12 @@ bool etnaviv_fill_identity_from_hwdb(struct etnaviv_gpu *gpu)
 			 etnaviv_chip_identities[i].eco_id == ~0U)) {
 			memcpy(ident, &etnaviv_chip_identities[i],
 			       sizeof(*ident));
+
+			/* Restore some id values as ~0U aka 'don't care' might been used. */
+			ident->product_id = product_id;
+			ident->customer_id = customer_id;
+			ident->eco_id = eco_id;
+
 			return true;
 		}
 	}
-- 
2.43.0



