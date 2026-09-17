Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3824DEC39;
	Thu, 17 Sep 2026 16:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661305; cv=none; b=c1rfwFCEjDiWD91In3L0sVzWRPBRFVYiY0d083Ciu9PloTkvvNE8F61nePJT0RFhbsO886Sji/g8KNDaDOsUagILr8vdjOnHh2AYv8fd1+snd5yOF1Jl2fWkCsAB/7YwgXv1WxBxU4DOgSOYlwIS+QeDujDkE6IDE3ADLnpIYeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661305; c=relaxed/simple;
	bh=OxY+1t/Nb5HkTDiTwrHfMx8ZqRnEnD0J8Z0OrM52L7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khI7seZLcJ7DyvxbZSay7uAfhQOHkFvzTLdta3Mfu0/FN/HRWMaa2ymNQRWiW1us5RRtNkDV/jkM8wElRTGK8WTbVgLtBYhALg9Iz+Uv7AIsN6J3fBeiA/FAvdp0zsg9In4G32u2mAOoZPf5aNn33NEmIpawcmKkZy+laPvL2Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tjk7obka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tjk7obka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AF51F000FF;
	Thu, 17 Sep 2026 16:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661303;
	bh=X5de4mjkFYEELvsLR/d0TzB18RJN7O5sgXOhBZ55iG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tjk7obkaqbVM5NMObHrHOhbG+O/femYeHoNCaqaZNctIdY5sRZ9mFQd4bbGQM/Qje
	 wZAp3aliSEIxv4vnEHWtvtN6FrRg/6pJAqg+KWkscM0m83f+vIB+uiU51QwkpCBOtg
	 UCIHdZ7czZ506+D+xAzWiLI+mG4Ai0sSuQIEYy+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0150/1250] drm/amdgpu: cap ATOM command table nesting depth
Date: Thu, 17 Sep 2026 15:59:05 +0100
Message-ID: <20260917151556.134073139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

[ Upstream commit 27ef1795bc4e47cae838e0a3ced531c549f9b23d ]

Cap nesting at 32 levels with execute_depth and
return -ELOOP when exceeded.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c | 11 +++++++++++
 drivers/gpu/drm/amd/amdgpu/atom.h |  3 +++
 2 files changed, 14 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index 7a063e44d4298..639649ef6dd03 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -59,6 +59,9 @@
 
 #define ATOM_CMD_TIMEOUT_SEC	20
 
+/* Limit ATOM command table recursion (calltable) to avoid kernel stack overflow. */
+#define ATOM_EXECUTE_MAX_DEPTH	32
+
 typedef struct {
 	struct atom_context *ctx;
 	uint32_t *ps, *ws;
@@ -1229,6 +1232,13 @@ static int amdgpu_atom_execute_table_locked(struct atom_context *ctx, int index,
 	if (!base)
 		return -EINVAL;
 
+	if (ctx->execute_depth >= ATOM_EXECUTE_MAX_DEPTH) {
+		DRM_ERROR("atombios command table nesting exceeded limit (%u)\n",
+			  ATOM_EXECUTE_MAX_DEPTH);
+		return -ELOOP;
+	}
+	ctx->execute_depth++;
+
 	len = CU16(base + ATOM_CT_SIZE_PTR);
 	ws = CU8(base + ATOM_CT_WS_PTR);
 	ps = CU8(base + ATOM_CT_PS_PTR) & ATOM_CT_PS_MASK;
@@ -1285,6 +1295,7 @@ static int amdgpu_atom_execute_table_locked(struct atom_context *ctx, int index,
 free:
 	if (ws)
 		kfree(ectx.ws);
+	ctx->execute_depth--;
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.h b/drivers/gpu/drm/amd/amdgpu/atom.h
index 825ff28731f52..bb3d9eb7eb6b5 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.h
+++ b/drivers/gpu/drm/amd/amdgpu/atom.h
@@ -153,6 +153,9 @@ struct atom_context {
 	uint8_t vbios_ver_str[STRLEN_NORMAL];
 	uint8_t date[STRLEN_NORMAL];
 	uint8_t build_num[STRLEN_NORMAL];
+
+	/* Nesting depth for ATOM_OP_CALLTABLE */
+	unsigned int execute_depth;
 };
 
 extern int amdgpu_atom_debug;
-- 
2.53.0



