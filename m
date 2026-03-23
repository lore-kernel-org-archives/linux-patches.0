Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52443B27EB;
	Mon, 23 Mar 2026 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274580; cv=none; b=dkb3QUOURiBACuFQtf2OnZXx3TJ3wMxJ9c1kTdth4cnfu4ZkG62eVcJQw4oSRYhH+SlqNASrcQJVRNmtp2GrCSPAXD7IeD52D10U1TpePbw1cxV4/7OMzTyC2y+QBri/GDnvT6AxiU9mMc+Lf7IzF6SOUsbH22GXoQN2dVCJp20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274580; c=relaxed/simple;
	bh=iW97RUDSYKs8j0+hIbtFzkZmmlKTI+YHWBVhblsJ+iM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bn5a8qd2O9t3aNnHiNMj4QE2F/D3Jt8l85ojNiw0XuVGKLmWWrCaBOvI1D3S879jM1sL48nkEMRz3Y1UO+ZsZdVU0jB7gTN8A3l7KSCwR8ulA3l8F5+CVdZsrf3tClSiignTS3jQsuoabuwLHxPRtyStxwrJeYN4b1j4oXowjCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtAwhXc5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtAwhXc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF45C4CEF7;
	Mon, 23 Mar 2026 14:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274580;
	bh=iW97RUDSYKs8j0+hIbtFzkZmmlKTI+YHWBVhblsJ+iM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtAwhXc5btB9pUyWu5+jV0ezy5zqOnnALqms3VGmIvCzt5s1V2CnyG24tmNupZFm9
	 FPqxffZ3hqAPhARe7TRByriCT2hMN567JpQcg90uFm7fNPp3wAk9+tVAZVLSIclSBx
	 X5B2yrcdo8x+Nsfh/WWfp41srm/4ggeC11qHi7MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/212] drm/xe/sync: Fix user fence leak on alloc failure
Date: Mon, 23 Mar 2026 14:44:24 +0100
Message-ID: <20260323134505.127936350@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 0879c3f04f67e2a1677c25dcc24669ce21eb6a6c ]

When dma_fence_chain_alloc() fails, properly release the user fence
reference to prevent a memory leak.

Fixes: 0995c2fc39b0 ("drm/xe: Enforce correct user fence signaling order using")
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260219233516.2938172-6-shuicheng.lin@intel.com
(cherry picked from commit a5d5634cde48a9fcd68c8504aa07f89f175074a0)
Cc: stable@vger.kernel.org
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_sync.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_sync.c
+++ b/drivers/gpu/drm/xe/xe_sync.c
@@ -206,8 +206,10 @@ int xe_sync_entry_parse(struct xe_device
 			if (XE_IOCTL_DBG(xe, IS_ERR(sync->ufence)))
 				return PTR_ERR(sync->ufence);
 			sync->ufence_chain_fence = dma_fence_chain_alloc();
-			if (!sync->ufence_chain_fence)
-				return -ENOMEM;
+			if (!sync->ufence_chain_fence) {
+				err = -ENOMEM;
+				goto free_sync;
+			}
 			sync->ufence_syncobj = ufence_syncobj;
 		}
 


