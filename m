Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D790A231842;
	Wed, 20 May 2026 17:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297002; cv=none; b=puA2+6hGOQ1vh52Ou5r9xof0EkwvgoA7DRTcPiMG4QXgjw5o/1dXNndRH/gPW+tAqJFJKEbGGezlvl3IRh13BAYfB8HYH8xA2Z32eH4LNu4yMtnDmSjAEKCWCnoGXyIl2XQwc+XkQadU1d40FUeUIhAiIrNx8CIsd/emx2R3B0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297002; c=relaxed/simple;
	bh=E79g493me+2DsPinkeGjmML2GJznvjKxcssCRzI4r/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFNNWgG4qJqXMRaC4eJglGfnAjWCnomOTCXvU/49omAVylCxaPycyY92SNi1w5BIhpWVNFi3GaFQxbv8MrvkcfAxyFAMAfDZF4UeB9soPUkfzWox3Xus4330tt5AKSwMAhVW8CPJELnFeeGQaQfenhzm0fax4C9szyOuJ14WdVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrHCm8nD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrHCm8nD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACDB1F000E9;
	Wed, 20 May 2026 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297001;
	bh=cI32++lcpF3HIPQDCGcQ11DODIKdz//XzQmgyICLHRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrHCm8nDw4Y3OA5fGvKuHHCraqsCX8BxWoNPxtAy4MGE4050UdoVrV/vLJOx2iwkr
	 DiuVBh0ge6leMqtQhC0CXzwtdownVPtujXpJSS+nNmbDti9O//0h9V49yTB4W0AumJ
	 fuMSxbLpIGVC3JoYp52B96J+YE28eHmQO397cjf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1014/1146] drm/xe/gsc: Fix BO leak on error in query_compatibility_version()
Date: Wed, 20 May 2026 18:21:04 +0200
Message-ID: <20260520162211.180517213@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 3762d6c36549accea7068c4a175483fafdd03657 ]

When xe_gsc_read_out_header() fails, query_compatibility_version()
returns directly instead of jumping to the out_bo label. This skips
the xe_bo_unpin_map_no_vm() call, leaving the BO pinned and mapped
with no remaining reference to free it.

Fix by using goto out_bo so the error path properly cleans up the BO,
consistent with the other error handling in the same function.

Fixes: 0881cbe04077 ("drm/xe/gsc: Query GSC compatibility version")
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://patch.msgid.link/20260417163308.3416147-1-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 8de86d0a843c32ca9d36864bdb92f0376a830bce)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gsc.c b/drivers/gpu/drm/xe/xe_gsc.c
index e5c234f3d795e..0d13e357fb43c 100644
--- a/drivers/gpu/drm/xe/xe_gsc.c
+++ b/drivers/gpu/drm/xe/xe_gsc.c
@@ -166,7 +166,7 @@ static int query_compatibility_version(struct xe_gsc *gsc)
 				     &rd_offset);
 	if (err) {
 		xe_gt_err(gt, "HuC: invalid GSC reply for version query (err=%d)\n", err);
-		return err;
+		goto out_bo;
 	}
 
 	compat->major = version_query_rd(xe, &bo->vmap, rd_offset, proj_major);
-- 
2.53.0



