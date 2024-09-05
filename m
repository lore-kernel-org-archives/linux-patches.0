Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D2519882B;
	Thu,  5 Sep 2024 09:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529511; cv=none; b=phYvTgwnR55uYvlMxd0s2BGrWytslmUBCdgMFNSMx5kVMU8etjzsZw3ZRQzlq7df/wrY9VWY0lUx9+NO6QFNotaPwEY/kRflFBXSa4aq1zBcldakd97rvoNC87Jsu6HQxMP3La01PiLFUiJrDggicUVrEFTpXcF9CgkmLkE1M6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529511; c=relaxed/simple;
	bh=s9A4NZhfgGGFMiy5Dvsa40stapE/qVX2ubzRbq22hqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+X0fwouB19ARdMB6CpkD8auS7rpHmgUQemlb9JE65BLm8dsU+eJe1HzVYa0moFYMkMSfSkLXp0piOVBjqIOrhztL9WoqrmspOmf3md3FKGjzcxT7/v86ENPdi2PzDsSyUm1ufoH72NcZWyaGaAeid4GM/tjO+buqRQlsMWDMnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6eYvWFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6eYvWFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDA9C4CEC4;
	Thu,  5 Sep 2024 09:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529511;
	bh=s9A4NZhfgGGFMiy5Dvsa40stapE/qVX2ubzRbq22hqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6eYvWFOYSRXlovatXTXU4dBh9a9I3tlPp9FJ3/XAN9WBw6ovQA0FXYYWcUSSoDd8
	 DaxywQmY2nLos0SMI6MsPlVwsuXvq32uKIyoci++afk7c+elk4G123UhBx71X4Bxov
	 ITjD6vD3uvY/+sTzAsl9KK0SqHX4lQg/BtkyAAIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 055/184] drm/xe/gt: Fix assert in L3 bank mask generation
Date: Thu,  5 Sep 2024 11:39:28 +0200
Message-ID: <20240905093734.390908740@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Dugast <francois.dugast@intel.com>

[ Upstream commit 8ad0e1810bf23f22cedb8a2664548b15646570c7 ]

What needs to be asserted is that the pattern fits in the number
of bits provided by the user in patternbits, otherwise it would
be truncated when replicated according to the mask, which is
likely not the intended use of this function.
The pattern argument is a bitmap so use find_last_bit() instead
of fls(). The bit position starts at index 0 so remove "or equal"
from the comparison. XE_MAX_L3_BANK_MASK_BITS would be the
returned value if the pattern is 0, which can be the case on some
platforms.

v2: Check the result does not overflow the array (Lucas De Marchi)

v3: Use __fls() for long and handle mask == 0  (Lucas De Marchi)

Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240502124311.159695-1-francois.dugast@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_topology.c b/drivers/gpu/drm/xe/xe_gt_topology.c
index 3733e7a6860d..d224ed1b5c0f 100644
--- a/drivers/gpu/drm/xe/xe_gt_topology.c
+++ b/drivers/gpu/drm/xe/xe_gt_topology.c
@@ -108,7 +108,9 @@ gen_l3_mask_from_pattern(struct xe_device *xe, xe_l3_bank_mask_t dst,
 {
 	unsigned long bit;
 
-	xe_assert(xe, fls(mask) <= patternbits);
+	xe_assert(xe, find_last_bit(pattern, XE_MAX_L3_BANK_MASK_BITS) < patternbits ||
+		  bitmap_empty(pattern, XE_MAX_L3_BANK_MASK_BITS));
+	xe_assert(xe, !mask || patternbits * (__fls(mask) + 1) <= XE_MAX_L3_BANK_MASK_BITS);
 	for_each_set_bit(bit, &mask, 32) {
 		xe_l3_bank_mask_t shifted_pattern = {};
 
-- 
2.43.0



