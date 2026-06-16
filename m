Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892F63D8105;
	Tue, 16 Jun 2026 18:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634148; cv=none; b=CXFXnfGBEbVE8yV/6w1dRq0xgxv1m5HuprwkEbqNvlwVsPWbQ7n86O4+CKIA8xQv6nyxxcr9fLTNyBTYuLsnas1Uvdv8X6z37LrwnNp8VqDDpUAXcQJuStVv3G+TkBGWRafTBdaAhe2svwzLViAPCXnAb83Fodg2FLx11Dlhwjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634148; c=relaxed/simple;
	bh=8xwW6XRRIJVQrocD7fGfVvhpTNYVJP0BxHuGCaPbdK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZRTm26eRHuOw1qYKh9X1m59ixsOtmFHbVsjQmhzPZb1gT+MKT1q5dQPJjk3sNzUZ0+wP5ka0hgbqbDkcI/plS1JAuGYCauBamuNp3O3Q/mpRx5z1QWiUuwTqA4mcLS0bjLgR5jPgiznUnpgn7CI4oRXx57p8IDXP+D9hbwMrIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gMrb4JVp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gMrb4JVp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7123C1F000E9;
	Tue, 16 Jun 2026 18:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634147;
	bh=lJe5kHEghRH2OS1z21fYzozDYGcSvDBTyk1uz0BjzfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMrb4JVpcCfq2P0vRDfFOpetcvU/JCBRJm3MwS2aDA84PFU7zU01bBdS0npCkGyp4
	 IF3SbuANAx7Ke6qEphxsdNgqotefO889gF2h18RdEX4R0hDmb//VbrEKOD0twzyLrb
	 ENl1+HdJz0NMaJ8inxWBTd7nZ8Djh59/1Q+y702Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 200/411] drm/vc4: fix krealloc() memory leak
Date: Tue, 16 Jun 2026 20:27:18 +0530
Message-ID: <20260616145111.354025498@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit 5d563a5da8717629ae72f9eadf1e0e340bd1658b ]

Don't just overwrite the original pointer passed to krealloc()
with its return value without checking latter:

    MEM = krealloc(MEM, SZ, GFP);

If krealloc() returns NULL, that erases the pointer
to the still allocated memory, hence leaks this memory.
Instead, use a temporary variable, check it's not NULL
and only then assign it to the original pointer:

    TMP = krealloc(MEM, SZ, GFP);
    if (!TMP) return;
    MEM = TMP;

While on it, use krealloc_array().

Fixes: 6d45c81d229d ("drm/vc4: Add support for branching in shader validation.")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patch.msgid.link/20260606123817.37222-1-grandmaster@al2klimov.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_validate_shaders.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_validate_shaders.c b/drivers/gpu/drm/vc4/vc4_validate_shaders.c
index 7cf82b071de290..82543a23ec0638 100644
--- a/drivers/gpu/drm/vc4/vc4_validate_shaders.c
+++ b/drivers/gpu/drm/vc4/vc4_validate_shaders.c
@@ -288,15 +288,16 @@ static bool require_uniform_address_uniform(struct vc4_validated_shader_info *va
 {
 	uint32_t o = validated_shader->num_uniform_addr_offsets;
 	uint32_t num_uniforms = validated_shader->uniforms_size / 4;
+	u32 *offsets;
 
-	validated_shader->uniform_addr_offsets =
-		krealloc(validated_shader->uniform_addr_offsets,
-			 (o + 1) *
-			 sizeof(*validated_shader->uniform_addr_offsets),
-			 GFP_KERNEL);
-	if (!validated_shader->uniform_addr_offsets)
+	offsets = krealloc_array(validated_shader->uniform_addr_offsets,
+				 o + 1,
+				 sizeof(*validated_shader->uniform_addr_offsets),
+				 GFP_KERNEL);
+	if (!offsets)
 		return false;
 
+	validated_shader->uniform_addr_offsets = offsets;
 	validated_shader->uniform_addr_offsets[o] = num_uniforms;
 	validated_shader->num_uniform_addr_offsets++;
 
-- 
2.53.0



