Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DAB2E339B;
	Tue, 15 Jul 2025 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586994; cv=none; b=h3pHPOsUs9zADV5MPKXuUceXNCry4YaOuh1OXvo2OGwrtK8TzibAsKzkTXrPvLUuhTHI/b/vz9hbzqIKaX0CKlhj7z5Tz+LX1R2WhTESgWQ+zPTxbocPxel3+LWvJeI21iA1K2Z4/QxdxHIqjL076adJ125dAdhRawvnJMomeYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586994; c=relaxed/simple;
	bh=x17jeFV2wN16FpE2rOKGe9zLL6Uwr3oxHnFJ4AzytpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9jDS2/TsLEyOc7Oo947vu3sNT6h1X5AxBu9H0j6XpUG2wz8CD3tqCI+6+oRuUJvK2/Ya+e9aLEGbEM1NT95WceDzmWNwSZDSxYtPTj7Kawy4Qmey2gBRKBpUYxJZQFTU18sYnv0ssfqgj4rtAPFHyjap+CDJU+ZgSGIblfYDBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uT7mKhAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uT7mKhAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3520CC4CEE3;
	Tue, 15 Jul 2025 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586994;
	bh=x17jeFV2wN16FpE2rOKGe9zLL6Uwr3oxHnFJ4AzytpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uT7mKhAmlwDMmgIO00T7j3Ur17hiPk1VoMTy+h4j0fWYt5dHPrdzuCCiuWtggrkb1
	 3kBlXcRwUMGv6h400GSb2u4rJAoJ/0qImvx2vaNzMqg3VBbHYjFX6ET5z4/bJDNfUZ
	 Q0mamb0MXJADUDFmrMk6TpAoo1Bs4uup5rfMm1To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.15 095/192] drm/xe: Allocate PF queue size on pow2 boundary
Date: Tue, 15 Jul 2025 15:13:10 +0200
Message-ID: <20250715130818.714574050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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
@@ -444,6 +444,7 @@ static int xe_alloc_pf_queue(struct xe_g
 #define PF_MULTIPLIER	8
 	pf_queue->num_dw =
 		(num_eus + XE_NUM_HW_ENGINES) * PF_MSG_LEN_DW * PF_MULTIPLIER;
+	pf_queue->num_dw = roundup_pow_of_two(pf_queue->num_dw);
 #undef PF_MULTIPLIER
 
 	pf_queue->gt = gt;


