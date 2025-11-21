Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4AC36D4F0;
	Fri, 21 Nov 2025 13:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732800; cv=none; b=pfYpFg5BAMBiKsew9QODw2u5sXi2FBjgsNKRGONKCItDXQ+UkR03riK8NYJc8TjLDGs+A2ZbeYuh0LHYu5p2FWUbiMIL4zaTfcL0XveCdwdM8xNnSBKh9RiDI1g82aUq907buhwxKB5dastEjiSfcvw+3kMNvCqHwgtX/y+BKIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732800; c=relaxed/simple;
	bh=kIFIb/KoDKY02vAZxwN4EEkVuigQzn+wMl/Bv12AIpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m3FnI4hmSKE+dC5Mh0KgBYxEVO+i+C41mATBydLS0WJyGIE3cb4GoVZH372uxA4bwFteT0E2cNRtnQ8ZKY0MPvBkEnaJH6LvaD8e5ypUNbiOLOdbMOtt5t8l7r+CqF5yta9uqxCAfg5U5Di0hBfvoy1u47gVuR/Gb8qRTaDNz+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNcuZS5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNcuZS5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FC8C116D0;
	Fri, 21 Nov 2025 13:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732799;
	bh=kIFIb/KoDKY02vAZxwN4EEkVuigQzn+wMl/Bv12AIpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNcuZS5dUr54maA+o+vtRShABCOKAqMkvCLh7XzR35FOZDo6fMnvWp05A0RJmgLHB
	 90SsU3a9JBHLYpQw7NcYFU4srXKa0ynBikvlFPfF5XrRkslbTMI9OKrXHW1jW2fxox
	 mfevD1+Ij6rafyL7+iXyqxi2O/3G3tFDaikVzemc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/529] drm/amdgpu: reject gang submissions under SRIOV
Date: Fri, 21 Nov 2025 14:08:59 +0100
Message-ID: <20251121130239.557558411@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Christian König <christian.koenig@amd.com>

[ Upstream commit d7ddcf921e7d0d8ebe82e89635bc9dc26ba9540d ]

Gang submission means that the kernel driver guarantees that multiple
submissions are executed on the HW at the same time on different engines.

Background is that those submissions then depend on each other and each
can't finish stand alone.

SRIOV now uses world switch to preempt submissions on the engines to allow
sharing the HW resources between multiple VFs.

The problem is now that the SRIOV world switch can't know about such inter
dependencies and will cause a timeout if it waits for a partially running
gang submission.

To conclude SRIOV and gang submissions are fundamentally incompatible at
the moment. For now just disable them.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 958034bc3b6d5..5b4d7fe148586 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -286,7 +286,7 @@ static int amdgpu_cs_pass1(struct amdgpu_cs_parser *p,
 		}
 	}
 
-	if (!p->gang_size) {
+	if (!p->gang_size || (amdgpu_sriov_vf(p->adev) && p->gang_size > 1)) {
 		ret = -EINVAL;
 		goto free_all_kdata;
 	}
-- 
2.51.0



