Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B592E3391;
	Tue, 15 Jul 2025 13:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585659; cv=none; b=QRdpw/vRJ9po/GTXuI2h+m4wD+N01Mv5CwQ/mRsna4/VzMLFYJ4rD9mda1NmoZuvGCNyfRGcCv+i7N/A//388jrgeU/kBKPSERZ/5+SOkHYQknATBjD7HPjocibVWBOiaXWE91J77rNV+l0uOHJh2DPvSrRSV1L1C2YhO6HvBSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585659; c=relaxed/simple;
	bh=L7KJLFVeKZh+xzpzJWvE74ZsDqH6ol7sETCW72UQjt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/RmWf7zvF8dxYiDQR+M18xXsU0IVz/MdjQuqA12Q86tumgeGaY5eE3RvXNMMU0gOwWrJgGRvavMWoK4QQG50itAGVtLB3i+FcZy2z6xHZgk3V0d5cUkfJJ014yPP2JV/InnQIZ07iUKAX2Ehn3GdU3ubvMfmfb1C+OTG7F8SIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wazk2xU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wazk2xU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E876C4CEE3;
	Tue, 15 Jul 2025 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585659;
	bh=L7KJLFVeKZh+xzpzJWvE74ZsDqH6ol7sETCW72UQjt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wazk2xU5sGWmuPKZhfeWP6ogLJp0liSHPRo4fayXWi+cCGUInz97yPLi+EhMUyO0W
	 jJemQNtDQYKCcb5VaexOqru8fnUnBzg6IGt+hAIJrcH8wfPMhIgeUdfQI7y/ouVJae
	 ws54rU42ZTaDUrMYaLqlRHmPkr2F2rJwSoUwpslY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 083/163] drm/xe: Allocate PF queue size on pow2 boundary
Date: Tue, 15 Jul 2025 15:12:31 +0200
Message-ID: <20250715130812.059870943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

commit c9a95dbe06102cf01afee4cd83ecb29f8d587a72 upstream.

CIRC_SPACE does not work unless the size argument is a power of 2,
allocate PF queue size on power of 2 boundary.

Cc: stable@vger.kernel.org
Fixes: 3338e4f90c14 ("drm/xe: Use topology to determine page fault queue size")
Fixes: 29582e0ea75c ("drm/xe: Add page queue multiplier")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Link: https://lore.kernel.org/r/20250702213511.3226167-1-matthew.brost@intel.com
(cherry picked from commit 491b9783126303755717c0cbde0b08ee59b6abab)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gt_pagefault.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/xe/xe_gt_pagefault.c
+++ b/drivers/gpu/drm/xe/xe_gt_pagefault.c
@@ -432,6 +432,7 @@ static int xe_alloc_pf_queue(struct xe_g
 #define PF_MULTIPLIER	8
 	pf_queue->num_dw =
 		(num_eus + XE_NUM_HW_ENGINES) * PF_MSG_LEN_DW * PF_MULTIPLIER;
+	pf_queue->num_dw = roundup_pow_of_two(pf_queue->num_dw);
 #undef PF_MULTIPLIER
 
 	pf_queue->gt = gt;


