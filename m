Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF81473C9F;
	Fri,  7 Aug 2026 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117764; cv=none; b=fdlGu9kMzaSt8hSYifX9z8sTu1HWtBf+XEi+nikN1RQTnpE4jZLuKtCjsW0z7N3s67kXBziU/Z74Mm00X7SO2HszSdX5k+uI+gvYXh5bXYDtd2QYV9TqE3UwC/A93A2xc1VKziYm0rtZyOWhqj7ek+JrPDgxoaUdAzaKEjKhjH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117764; c=relaxed/simple;
	bh=pXYXDsqjbeP5C2F2vSN+OtkV3rhX2lk9iyGCOHZUK8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oaTtOXdrg9Qux+4VMVePUyvi7o5YrBBNJKuAv3k4XnsBzm3S1+rEOccdO8UeWiCMKIYxEVZXmlig3E6Pyy1akmg9GHIcS888xLlBzK2b5ltpROW+GN85myhY+Yijqp1wwAd35kTD03W0teOTA9snfBrw6QQzQngGN0ArW0/iGy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FpDfqqx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FpDfqqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA5E1F000E9;
	Fri,  7 Aug 2026 15:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117763;
	bh=xnW9aP3hBdy6Tw0ZLkPFO9pvxVJiJEyOPyX2ua+YZvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2FpDfqqxZZMEwzPjAU2ZNkFie3XD217F+jvwKzDrjoJlRktmih2v50caHT0MIPwrg
	 dG2BAuyUzVM0SjmTrBBl/FIsOyKEjtu0WjgNAS+5yndFhNcG0sv8jOh0TkqnHqCy9E
	 x/4e/xwN21jSakkQz91oh24KUiIgz2H8sNHrDbcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 432/438] drm/xe: Set TTM device beneficial_order to 9 (2M)
Date: Fri,  7 Aug 2026 16:40:28 +0200
Message-ID: <20260807143437.179892688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit ba7fd163422877ad5a5cf31306a38c07d3932b0c ]

Set the TTM device beneficial_order to 9 (2M), which is the sweet
spot for Xe when attempting reclaim on system memory BOs, as it matches
the large GPU page size. This ensures reclaim is attempted at the most
effective order for the driver.

This fixes an issue where an order-10 (4M) allocation cannot be found
despite an abundance of memory. The 4M allocation triggers reclaim,
unnecessarily evicting the working set and hurting performance. Since
the TTM infrastructure was introduced recently, we are tagging the TTM
patch as the Fixes target, even though this resolves an Xe-side problem.

Fixes: 7e9c548d3709 ("drm/ttm: Allow drivers to specify maximum beneficial TTM pool size")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20260611235844.3725147-1-matthew.brost@intel.com
(cherry picked from commit 0d81db90d364cb3d733410829118759f28957c5a)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -478,7 +478,8 @@ int xe_device_init_early(struct xe_devic
 
 	err = ttm_device_init(&xe->ttm, &xe_ttm_funcs, xe->drm.dev,
 			      xe->drm.anon_inode->i_mapping,
-			      xe->drm.vma_offset_manager, 0);
+			      xe->drm.vma_offset_manager,
+			      TTM_ALLOCATION_POOL_BENEFICIAL_ORDER(get_order(SZ_2M)));
 	if (err)
 		return err;
 


