Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950801E8320;
	Tue, 16 Jun 2026 15:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623497; cv=none; b=LKzkPS02g9EgIKLe3rhPfFRZqXWJQzCuU/WbwXipypIAplWYO5wbkMi3QNm117vlrn6W3zQ1laXeuKwUp3uth7qXw6GQj7DatPPgC4MFORH3/sho6ourT19vlu7OElR3pGXxUBrYD7bQhrpMm86GVs0f4qkQM9rqS1Huifw493Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623497; c=relaxed/simple;
	bh=W1QOoPr08Cn61auSfUGmmfSex6T26Eg1UUcnQ8gtdMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJgFaQ8SlmO9uCArNHvGpXs6YITXc8u9J67BC9t96fpoocO1XHuln98MUPnA4HTTCqAhHcAIBsrtV7l/l4KClIRkhzi6NOH32wu6JJbgZiBVD+rjcbD43ejHDkkn8SAuysfFhuRDLdPqi2RevvNhQgYEcmbzbGz0tW0/01HixiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyrHYG6c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyrHYG6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDD41F00A3A;
	Tue, 16 Jun 2026 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623496;
	bh=/7UmNPZA/3YxYFXGNYaFg++xIovQ4WHT/2CGccFAub0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OyrHYG6cBLxIv5L5CR9SGkvGhEVd6b0LjVNAPfcSjXpTJ9rv/G32qIDBLE2+q0XWs
	 /P+9gqowPh2AKVY+PIDixoHKQG0C+Oup4TxCJHkYCermSnqq7PzUVrEjmS9FMxtapF
	 zvKxjICTeYfdMvgQGKsPriGI+ABLAJorZXX/m5vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 160/378] drm/vc4: fix krealloc() memory leak
Date: Tue, 16 Jun 2026 20:26:31 +0530
Message-ID: <20260616145118.673009334@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index d48cf76983c09b..66502a6a4a8e7b 100644
--- a/drivers/gpu/drm/vc4/vc4_validate_shaders.c
+++ b/drivers/gpu/drm/vc4/vc4_validate_shaders.c
@@ -290,15 +290,16 @@ static bool require_uniform_address_uniform(struct vc4_validated_shader_info *va
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



