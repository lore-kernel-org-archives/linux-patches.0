Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E341B56E070;
	Wed,  9 Sep 2026 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962967; cv=none; b=awaeUDm8FV/nWWPgV5ZNzWLNW9AYfilpRwv0zF7wmDRM30V1bwBnATXIFsNPKKfJwG9JClSJzvuMvll5Clw7CE5Um/SzUSOXPnCN1bWYPMnSCPuixFodog7ZnsJAJ7gllIUGTkRgikYOE2C4MD31FpAme5cQCCvQJRLso6sZdFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962967; c=relaxed/simple;
	bh=OPjLeecXYJoeqERrbc/GMgKDRjkecUqq0ET7xvCLAnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q26S2gJJdPJQhfWobIKfm6tMJv9kO03amLDQ6GjvQz6QRN0g1Ga9yQH0Tva9H0ISfZg/lrZvRAk/gCh0Epg8DPSn4QzCFbJ4zRMYQ7+2bXUAxgIF832NWv96DJhYqAaJzZ93Tl5oSEco37f/3XLCRUWwnpZ9cY6tgT/uXYSOYX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvN4V6Rk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvN4V6Rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FF31F00A3A;
	Wed,  9 Sep 2026 14:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962965;
	bh=BbYqoB5olXEfa5Z3h2KWA4U/fLlNA1WuFCCJ6WNoSYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvN4V6RkPCr/X8p8LJmFXV/nBqZXpJ6nP372YYcQbHW5i8cNC+gPlsxirFducQnqd
	 zx3wHzbhtjG13jYpwfaFwPQr4PIGG3YelTHLOMLvCHV2u+7CTPIvL5ltx8U80vCsHv
	 7aivyKZEio0mdYMHTsCbSugoRFlWIUb1aoFc6iZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Zhou <bobzhou2@amd.com>,
	Leo Liu <leo.liu@amd.com>,
	Frank Min <Frank.Min@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 473/556] drm/amdgpu: avoid force-completing uninitialized UVD rings
Date: Wed,  9 Sep 2026 15:42:33 +0200
Message-ID: <20260909134247.189011282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Zhou <bobzhou2@amd.com>

commit 6760f5cb12d2366ddd58a2d8637f7583d73f596b upstream.

uvd_v7_0_sw_init() does not initialize the UVD decode ring for an
SR-IOV VF. However, amdgpu_uvd_resume() unconditionally force-completes
the decode ring when restoring its fence sequence.

Skip fence completion when the fence driver is not initialized.

Fixes: 0a33b11d26c6 ("drm/amdgpu: mark force completed fences with -ECANCELED")
Cc: stable@vger.kernel.org
Signed-off-by: Bob Zhou <bobzhou2@amd.com>
Acked-by: Leo Liu <leo.liu@amd.com>
Acked-by: Frank Min <Frank.Min@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_uvd.c
@@ -517,7 +517,8 @@ int amdgpu_uvd_resume(struct amdgpu_devi
 			}
 			memset_io(ptr, 0, size);
 			/* to restore uvd fence seq */
-			amdgpu_fence_driver_force_completion(&adev->uvd.inst[i].ring, NULL);
+			if (adev->uvd.inst[i].ring.fence_drv.initialized)
+				amdgpu_fence_driver_force_completion(&adev->uvd.inst[i].ring, NULL);
 		}
 	}
 	return 0;


