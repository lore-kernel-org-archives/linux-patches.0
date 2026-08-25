Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E71448B83;
	Tue, 25 Aug 2026 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665948; cv=none; b=mIu/kAw5LAgHpm+gnXcucFCqbQIjokaeIJyCI3pTyoThHl3rg1bA6XY7sCfjE/PdLaTDDRETtN8EyEm/+JMcofSbvmmSPaqrSx55cIV9M6NbDt1W8dIEgr2WQUlgt7NzhP1nyWuj0Ac8n1tcFZbxuskSg3t8514qMGU7UqeLPP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665948; c=relaxed/simple;
	bh=Uey8MWB3bGSa5Nq+ttOzN0/M7H3F4f/LzmZIjoQWXZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0gN9cGTVmSRncB21W2NLelO+MDOR4qqc+kySCbBJkhPJ6CFzC7QHk39CWh0VmaNHGSXy+T12/A8/JsMth55Yk5ZAkLhGQE+FM2CP0sV8omEdVb0xRgnyge/7mMLNCdbU9oshTyQOl8EXodqUtnKEGsngpH7Ox5TJ3r/0+TzJkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erzSYPcW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erzSYPcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784B51F00A3D;
	Tue, 25 Aug 2026 13:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665947;
	bh=Kca4oKW7MNXa47Cx4BKSKOwQ/MAqHsJl50ADsrJQTiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erzSYPcWx39zC1Fkz/PcUfeHV3jq4wgyfDIqgULDL8O+ImWm6aX46OvkPT7DdiBjB
	 Opl9WFchsMWwghO5LYEHcHl6uW0MCiD6fjFVu2tlmHQAMBExL7DVVla+eWbNM4E7mo
	 GDCml4EHKwzvFqbSa5mbAUXGbU+OwR/OMCNxNskg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/79] drm/amdgpu: disallow multiple FENCE chunks in one submit
Date: Tue, 25 Aug 2026 15:26:11 +0200
Message-ID: <20260825132542.917175453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 931cd1d1baeae68e8eb2c23bc1f3d8934dca6241 ]

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
[ adapted `p->uf_bo` to the pre-drm_exec field spelling `p->uf_entry.tv.bo` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -247,6 +247,10 @@ static int amdgpu_cs_pass1(struct amdgpu
 			if (size < sizeof(struct drm_amdgpu_cs_chunk_fence))
 				goto free_partial_kdata;
 
+			/* Only a single user fence is allowed to simplify handling. */
+			if (p->uf_entry.tv.bo)
+				goto free_partial_kdata;
+
 			ret = amdgpu_cs_p1_user_fence(p, p->chunks[i].kdata,
 						      &uf_offset);
 			if (ret)


