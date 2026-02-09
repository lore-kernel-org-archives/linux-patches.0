Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA35E37BE7F;
	Mon,  9 Feb 2026 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648048; cv=none; b=oc/gJAp8megBm9Sxh87S99eggOZHifSXCrGiSO6z55lAx/2T00qo8Kq77bd8ItVfNt0C5UVC3oSWQ/c5s753HoUYyYpEUi9OD2cJBSLmrM0G7k8QQ/2hlToD48gaeQg2M2V2ACqDpHVMRr0TtsVa1iK4ru+TnUKRTFWjWegAYNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648048; c=relaxed/simple;
	bh=w6bAnxJSUn4kQt6+d1ShUbMEleXk11Vb0r/jrTxZ4bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p1Yu8eidn1q8nM0jqCTu08ClHuKdU73CaB7ifx3qzgkrqq0wwPFA42d/PL3PQ+YssjCnpIKXV0JjOXIin1dW4dmjFsi1rbbD7d2n5lY3KFWLHNFLcLOJjunMRdzyMM7v21zSAcqw+k3eyzCfkO6rq55gIIzPi1sutCFUWPrUQ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eH0FwcU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eH0FwcU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEBFC116C6;
	Mon,  9 Feb 2026 14:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648048;
	bh=w6bAnxJSUn4kQt6+d1ShUbMEleXk11Vb0r/jrTxZ4bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eH0FwcU46KLTiLOGhrWQq5hY+pxfplOizeeALTEbVdu+3Ft4lk2AuY4PJJCwE5jY4
	 kfvaYckufKSQl8I5MkItNXIkgLyxn163ZsqY9x6GJTd5C4kGGXPDQ8u8OFE3vuVmz7
	 dJTk4k9tolm8XcSmxmNLzX0aRypvhx30pdR4IW60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/113] drm/xe/query: Fix topology query pointer advance
Date: Mon,  9 Feb 2026 15:24:07 +0100
Message-ID: <20260209142313.699305984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 7ee9b3e091c63da71e15c72003f1f07e467f5158 ]

The topology query helper advanced the user pointer by the size
of the pointer, not the size of the structure. This can misalign
the output blob and corrupt the following mask. Fix the increment
to use sizeof(*topo).
There is no issue currently, as sizeof(*topo) happens to be equal
to sizeof(topo) on 64-bit systems (both evaluate to 8 bytes).

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/20260130043907.465128-2-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit c2a6859138e7f73ad904be17dd7d1da6cc7f06b3)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_query.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_query.c b/drivers/gpu/drm/xe/xe_query.c
index 71a5e852fbac7..46e37957fb493 100644
--- a/drivers/gpu/drm/xe/xe_query.c
+++ b/drivers/gpu/drm/xe/xe_query.c
@@ -487,7 +487,7 @@ static int copy_mask(void __user **ptr,
 
 	if (copy_to_user(*ptr, topo, sizeof(*topo)))
 		return -EFAULT;
-	*ptr += sizeof(topo);
+	*ptr += sizeof(*topo);
 
 	if (copy_to_user(*ptr, mask, mask_size))
 		return -EFAULT;
-- 
2.51.0



