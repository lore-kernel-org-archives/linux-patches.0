Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5569B43801B;
	Thu, 30 Jul 2026 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424277; cv=none; b=fxU/uj8Djp6b/yGlWNYCW/vedJqpAhreCayaGl6ZKIRzr/b4wmTa4ut4nlHUS9hro5PEjaYQz71d4MZdlfcglqiIxEVfzCFBGiDbL7p40y1INCkK4vl8CcEkn67ipP3xPKcLlr9blPur8phvrgzfNQhDNIGrcrF1tHiwqNH7lBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424277; c=relaxed/simple;
	bh=jQisM9izqnVYh0llov7lPo5BQquaTjw3m7livGHz/d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRCuDvphgPaLd/OnvIte0Z4smuv/e1SHNYZXpEBbduXmiPUOKeLUzDarsKsOIcg1hrKj8lFQGujJCWqnQyEoFnjXhA1Md8GucQ/qdSyGsIHfjxyalao423Q3wLlsx41qKYOskUCd2Tat8Ppnbuxo7SWAZdNC+r7k0AORLOO9qmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBLrmNo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBLrmNo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71821F00A3A;
	Thu, 30 Jul 2026 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424276;
	bh=RiWGWYv5uDaF3cytJujBj+u8G2lLHpYuGK2iCce861o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NBLrmNo2Bal8oH81xp9dFP6Z0hrayZCYPheCloLeASem6hpnd8Owif9wqN6oVcjJ4
	 xveW/8WYI2nJ3wIYjAY2OJxE1PDX7LINoTKw/SpSXvjCdoGinXDhcMMx0JfiKxMBhc
	 QG+uzhuqtPDvhQoXr8xMuDhNTfr2TN7ldCGBRYs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.18 337/675] drm/amdgpu: validate CP_GFX_SHADOW chunk size in CS pass1
Date: Thu, 30 Jul 2026 16:11:07 +0200
Message-ID: <20260730141452.291130049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 84c4c36acd5c4b2558b5069f869a165b2c655c84 upstream.

Add a minimum-length check for the AMDGPU_CHUNK_ID_CP_GFX_SHADOW chunk in
amdgpu_cs_pass1(), matching the gate already present for the IB, FENCE and
BO_HANDLES chunk types.

The CP_GFX_SHADOW case previously shared a bare break with the dependency
and syncobj chunk types, which do not dereference a fixed-size struct. When
userspace submits this chunk with length_dw == 0, vmemdup_array_user() is
called with size 0 and returns ZERO_SIZE_PTR, which passes the IS_ERR()
check. amdgpu_cs_p2_shadow() then dereferences chunk->kdata as a struct
drm_amdgpu_cs_chunk_cp_gfx_shadow (reading shadow->flags), faulting on the
ZERO_SIZE_PTR and causing a NULL-pointer dereference.

This is reachable by an unprivileged process in the render group. Reject
undersized chunks with -EINVAL during pass1 so the bad submission is
rejected before pass2 ever dereferences the data.

Fixes: ac9287055ff1 ("drm/amdgpu: add gfx shadow CS IOCTL support")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 7f61b2eef7415eccdb40850aca0de94211948657)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -260,13 +260,17 @@ static int amdgpu_cs_pass1(struct amdgpu
 				goto free_partial_kdata;
 			break;
 
+		case AMDGPU_CHUNK_ID_CP_GFX_SHADOW:
+			if (size < sizeof(struct drm_amdgpu_cs_chunk_cp_gfx_shadow))
+				goto free_partial_kdata;
+			break;
+
 		case AMDGPU_CHUNK_ID_DEPENDENCIES:
 		case AMDGPU_CHUNK_ID_SYNCOBJ_IN:
 		case AMDGPU_CHUNK_ID_SYNCOBJ_OUT:
 		case AMDGPU_CHUNK_ID_SCHEDULED_DEPENDENCIES:
 		case AMDGPU_CHUNK_ID_SYNCOBJ_TIMELINE_WAIT:
 		case AMDGPU_CHUNK_ID_SYNCOBJ_TIMELINE_SIGNAL:
-		case AMDGPU_CHUNK_ID_CP_GFX_SHADOW:
 			break;
 
 		default:


