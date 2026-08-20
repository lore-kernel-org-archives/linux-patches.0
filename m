Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF20634F27B;
	Thu, 20 Aug 2026 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238372; cv=none; b=Rdw4cHL6/9EepOqlyOltiS/J1UPXriBqHkW0LrMzephCVRxgYaKIdX0ofZNfXkbEa16etqk8J4dMC+PVZ0CQAQYdG01FYilxqXvTUfxpDvIU3YuAiMCw9b4NOGdDoFi9qXxgny0WaNH7tT73DCg30nGyyFFJi1dPNcBDFSl5EeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238372; c=relaxed/simple;
	bh=NsUhAnvz13d5I7d0hrbAQdrQQMO+uu34XZy/KrCfakU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oM8nLeRYRRQvNQ+SnfC6wKw+RGcnRfYe7R+2vXGfH3GBYCVsVZET6FXWvQGwJAlWDLg5tqusBWdnSw7Ws0ToG+hAXG+VHn+x33SlwYplR9YHGpmVT+VxiR1rmsx5GsBigybBl01alU6zNnFHGkxtGLjXkVSdfPmO9xIupg4Z1BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMlOqbmH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMlOqbmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066091F000E9;
	Thu, 20 Aug 2026 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238370;
	bh=87kcZCrvE0OVuts/J954oFQPZkOP70h8pjUZ0ix5smE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMlOqbmHTfQJ8I6ibAmG1ZIYXuZC3A8D2wq08EeXz2vpjXe+wxKKu7NzkQYbGKedF
	 S7e4C7OAyqV91LO72uhh5zogPaGZ0ccWDSm1zX7ujUh9dx2BYoPOvEuiD67zgC/x1o
	 zoSzOMZ0rDmDxftjOatSn+eFoD4L0jd/l+g6bxwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 124/228] drm/amdgpu: disallow multiple FENCE chunks in one submit
Date: Thu, 20 Aug 2026 16:54:26 +0200
Message-ID: <20260820145248.391480283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


