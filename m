Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD6B2E9759;
	Tue, 22 Jul 2025 14:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193748; cv=none; b=cU/R5O4N7exF8L/3YL02ugHL03xxcQ3HaJDA2aOkcOJp76qD7ZE43NejIl9kz8tt0Nh9iNofKDyxIUCSKiijT7me/Kv3Pv8doIY7jt5bTSVN0NZg2ifWZwBI34w9a0AkbjuoCoh/m6iDS01az5t3exF9UAOpS8UW9HBzagpPrBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193748; c=relaxed/simple;
	bh=d+vnLM57NyuXb1MXNprCDNo/rlxj7WIaH1/wgOUYQEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcgUcgNVVoB7g4cIkPkahBq90Sw9GiVknhOi3kV2uulJsUJPtLjFH2bzYRXzuj+ZUwPB63UrSZlmjqZSOVRZOhj6IxrIa+tAsQlwu3z8BtinZFigqAmjgb/f6Bp0ZDezLKhqVGhIIbgTNmLZRp+Em0PuIcBw0ONT8okeTXB3MMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INeWvwRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INeWvwRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305D3C4CEEB;
	Tue, 22 Jul 2025 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193747;
	bh=d+vnLM57NyuXb1MXNprCDNo/rlxj7WIaH1/wgOUYQEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INeWvwRT7DXOsOnOmn/ltztJ0rb0HCrgFionwWKQAXNBfUI2r0oS93rhcdgqHSHlx
	 2QReb60b/htyR4GE/ljYoQ1cobfCqeBc+hKo3q950/OV7hc92WGlnJsiK1BiClVqwI
	 MepdFaJl0X9iWIpl8NYuujdnCrXSIi0GZChqJ+yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 186/187] drm/xe: Move page fault init after topology init
Date: Tue, 22 Jul 2025 15:45:56 +0200
Message-ID: <20250722134352.694714358@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -590,15 +590,15 @@ int xe_gt_init(struct xe_gt *gt)
 	if (err)
 		return err;
 
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
 


