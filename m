Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601E93043C8;
	Tue, 16 Jun 2026 17:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631682; cv=none; b=jXple4Olj1Ws0+ZeBYSxFFyKM+f4ouK58483IXwB9iyZoXT7l64RYW9NmY55Ft2q8o1BnsxMgJnTkuXIPvUZRiOfEOA4aPYvskZw0Och1x0XGxLQ/f41NdYLIVuFz+tCs2bnKnjBxaTpbL+OH8/1Oo3zmbyDCbOry8nmtkUeAwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631682; c=relaxed/simple;
	bh=dZHmdMmsombALwLfMQd1B+Y3y9d45e4gUUSin+D6eFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T0S9nNBMOwpe4PpaMnD/pwrsdC5NYdLHm4QsZs6Km69TGLOJlLVcanBMrkOwQdTK0fhH0HUEZk4LIzn/IWQeIu6878dHWwvViL1s0/dIfnpDviRYJCLDTtKE9F1lx3S/1XvCPpNJO9XTrP7eYCNNGEakM0xqfbUAtc1O7lMvwbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoYGbNCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoYGbNCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14831F000E9;
	Tue, 16 Jun 2026 17:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631679;
	bh=mzcWaF1abKRo8o9Rk6LjxX+w8NxojnXiUiFDzdp5vJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoYGbNCGu6bKfNrBJRdhXd/efKU+6aybW+0BhQge2IcGbVczT2LLKI8ECfSbIaeK4
	 vnyY0LQNwPQ6vTaaNYTBCHydO3ts7efWHtw+CoZZAQT4VBxlLQKKXj1jI/CBBPGM12
	 pIi4LOEKFtPglgYPVsDkW9JCUv3/RoY0THFssfx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 266/522] drm/vc4: fix krealloc() memory leak
Date: Tue, 16 Jun 2026 20:26:53 +0530
Message-ID: <20260616145138.386018737@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9745f8810eca6d..c2c6767ae55862 100644
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



