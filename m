Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F49F37E5CD;
	Thu, 20 Aug 2026 17:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247490; cv=none; b=N5xj2LgiFcoN5//pKFHh934OoPfalOKKroKhqSD8aQD1+Z+8E0FoMnGpquFR1oInjNsJri+dPbFdbQBC8m9Cs7WtHPEc4mKjhGLNkoHZV6MAGO5MANdDMqwBhxmH9W1Wqsw0y9/LXsOio1GDPG/22zc8j0Srmk4phxsUyaLFkIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247490; c=relaxed/simple;
	bh=3MXEeAKNxbDurBZ/Bbv7R81V3AIyq8gvImAEFc0snQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=StX5qAml5G2fE9h8Zdd9yEnGehvzpJQZ1b/KaFu03+m9RjRXwp+dnHnSVZt18RVeAman3BORJQWGELhRr5wclDrQhyyf25ilnuQYmzQW+dzkWHRj98s1hT1BqXwqHIcSLbDrjrjVfrwMk5WDn0a9ImoMvpnwAEFeiWj5Qu3ne2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NoDkaE/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoDkaE/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2931F000E9;
	Thu, 20 Aug 2026 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247488;
	bh=uhULgLep7qKCGKc9lWQuGcnI7EyXGslffXl+YcVMqXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NoDkaE/IH4oFJBa6+NYOUcgzeM185Ms/2ZgOHKZoSEEyKjPMuJ9KWIouJS0ApFlR5
	 73dxdCNstz4f7zcfyUMuopDhDKh/lS2X25g3cyNZ+TqIvvEdLIHV7zSG3SRCoN6LO8
	 N49oPrOmwsVI2D6sRxXBk2slJf/1t2T69klqoTLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 063/166] drm/amdgpu: disallow multiple FENCE chunks in one submit
Date: Thu, 20 Aug 2026 16:55:22 +0200
Message-ID: <20260820145213.043285776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

commit 931cd1d1baeae68e8eb2c23bc1f3d8934dca6241 upstream.

amdgpu_cs_pass1() dispatches on chunk_id once per chunk without
rejecting repeated ids. p->uf_bo is a single-slot field, so a
submission carrying two AMDGPU_CHUNK_ID_FENCE chunks runs
amdgpu_cs_p1_user_fence() twice, and the second run overwrites
p->uf_bo with a freshly referenced BO without dropping the reference
taken by the first.

amdgpu_cs_parser_fini() only unrefs the final p->uf_bo, so every FENCE
chunk but the last leaks a BO reference. The leaked BO outlives handle
close and process exit.

Reject duplicate FENCE chunks the same way commit fec5f8e8c6bc
("drm/amdgpu: disallow multiple BO_HANDLES chunks in one submit") did
for p->bo_list.

Fixes: d38ceaf99ed0 ("drm/amdgpu: add core driver (v4)")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 665b1fc2a1845206408f9a2c6da67101789edb82)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -253,6 +253,10 @@ static int amdgpu_cs_pass1(struct amdgpu
 			if (size < sizeof(struct drm_amdgpu_cs_chunk_fence))
 				goto free_partial_kdata;
 
+			/* Only a single user fence is allowed to simplify handling. */
+			if (p->uf_bo)
+				goto free_partial_kdata;
+
 			ret = amdgpu_cs_p1_user_fence(p, p->chunks[i].kdata,
 						      &uf_offset);
 			if (ret)


