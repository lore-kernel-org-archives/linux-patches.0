Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567202C9A;
	Tue, 22 Jul 2025 14:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193126; cv=none; b=XL41kxWJn2kY3zEd7fUdbBucTLOA6Z8fYlmftrIAs5dqVtvCmLigl9ojLH1FF3qQ7GmqOuqoElI/We1wr0k0XbdrSKDC5sBVpi6JFqwL5QO1HA94EFtUUYp+IhdU4UFCPC4kF5XyEgwKMHhptAV+jaLaD8n9xSUjWQnNbfnhSkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193126; c=relaxed/simple;
	bh=2c96gDvAL88IuquG7YdsRed3xt14jz9xuqTKBDNCX1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLEXTIG7uUI8hUSmulpd+hBOOSw4GYDvGAqNt8AH0pyV+jGeXWpIYF9g2WwRgG6GwlXPR+i9XsKoRdPaoFYW+USQFS0Uw+ic0CD3u53e64SAXx5wTJWpNLlwXPpG8IjSdxJn79zu/MXNKyaGjG2I4cpEZw10eTMBTtUjrcppfd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7k/xNHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7k/xNHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E5AC4CEEB;
	Tue, 22 Jul 2025 14:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193125;
	bh=2c96gDvAL88IuquG7YdsRed3xt14jz9xuqTKBDNCX1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7k/xNHMvqiC8P5IxhM1dacP6Ysz0uv5lg7QkN4Mkk7S0PKF4BEV+VpbTVLlZQdLF
	 UAN/3ToGUSV8j5whbJp9f8l3r4RU3cIGAEopW+4U7Os1tNb0Y+e3j9u0WNdWz4UvgB
	 0lQCfGEcHE35II7zPlu7xdqOR6zOTVZHigo4CgDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 157/158] drm/xe: Move page fault init after topology init
Date: Tue, 22 Jul 2025 15:45:41 +0200
Message-ID: <20250722134346.569816128@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 3155ac89251dcb5e35a3ec2f60a74a6ed22c56fd upstream.

We need the topology to determine GT page fault queue size, move page
fault init after topology init.

Cc: stable@vger.kernel.org
Fixes: 3338e4f90c14 ("drm/xe: Use topology to determine page fault queue size")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250710191208.1040215-1-matthew.brost@intel.com
(cherry picked from commit beb72acb5b38dbe670d8eb752d1ad7a32f9c4119)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -594,15 +594,15 @@ int xe_gt_init(struct xe_gt *gt)
 		xe_hw_fence_irq_init(&gt->fence_irq[i]);
 	}
 
-	err = xe_gt_pagefault_init(gt);
+	err = xe_gt_sysfs_init(gt);
 	if (err)
 		return err;
 
-	err = xe_gt_sysfs_init(gt);
+	err = gt_fw_domain_init(gt);
 	if (err)
 		return err;
 
-	err = gt_fw_domain_init(gt);
+	err = xe_gt_pagefault_init(gt);
 	if (err)
 		return err;
 


