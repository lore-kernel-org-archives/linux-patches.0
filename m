Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA80017736
	for <patches@lists.linux.dev>; Thu, 25 Jan 2024 08:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706171005; cv=none; b=IuCHqN2oynV7nTYwgIwN4yZU+fJaucSrIwBEppfohK6LRf5IREt/3QvYjEDn+/NZB7A+bFzW2FQ6/i1ctRMuntFIc2Zwt8b9l5Z7GfaGkM2vlucfQB1InrXFUTrqwUxAe/hIxSN5b8ub04NKsuZtBlY+2oDw/HxBhZfjkjts0qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706171005; c=relaxed/simple;
	bh=if8v2kup1nIzoficv1uxi7vRkXghvMvZw9xTx9Js46E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C/HEvRB+RPSi/G+dq6409O6MQ/LBjcQXIV3LuGagv4mLfvQN5Cg1hPIVZj+13XTfX+Cb5f8iXGcOQIXjLSafKj5Dhqvxuh0ix19whiRRkyk/MrY5i0aiyHjpntA3sSl6uFOjwaALlvY7Mdr+da7jdG+AMQijcVwmbVFw8TqIMCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gV/1sJ9D; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gV/1sJ9D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706171005; x=1737707005;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=if8v2kup1nIzoficv1uxi7vRkXghvMvZw9xTx9Js46E=;
  b=gV/1sJ9Dc8ZKNJEko/Vz2q+3vaOnmbE036MJS20VQW33i2XnwrB7pNzI
   QhCgPsm4x1sgv/bNNga61p7ofkDJY1xWs66mAebj+QNVaD90/pmVTEBba
   0yxP9+VmD4x92ZEP3e/WoQBDOajWwkIQ1sx/JoSur7iJQ0n/o+kfqJH+1
   AXN/anS4+Es0u4Y2FALmkYLD2t9I/G0Tcp3tSBC5iMzWzDYCKH+nCw/WO
   jqNLEtlo1X3iAZs+B/ybQj38odvC401xiZCsTN8kQ65oE2di2aFhwZMyF
   0q2J6R7mcUVFKWyuwX7ow8QPYEqmiQi2kNY7N0bGWRz0UapHimY6PzzfC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="1987167"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="1987167"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 00:23:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="876975923"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="876975923"
Received: from araj-ucode.jf.intel.com ([10.23.0.11])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 00:23:22 -0800
From: Ashok Raj <ashok.raj@intel.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	markgross@kernel.org
Cc: Jithu Joseph <jithu.joseph@intel.com>,
	rostedt@goodmis.org,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	LKML <linux-kernel@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	pengfei.xu@intel.com
Subject: [PATCH 1/5] platform/x86/intel/ifs: Call release_firmware() when handling errors.
Date: Thu, 25 Jan 2024 00:22:50 -0800
Message-Id: <20240125082254.424859-2-ashok.raj@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240125082254.424859-1-ashok.raj@intel.com>
References: <20240125082254.424859-1-ashok.raj@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jithu Joseph <jithu.joseph@intel.com>

Missing release_firmware() due to error handling blocked any future image
loading.

Fix the return code and release_fiwmare() to release the bad image.

Fixes: 25a76dbb36dd ("platform/x86/intel/ifs: Validate image size")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index a1ee1a74fc3c..2cf3b4a8813f 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -399,7 +399,8 @@ int ifs_load_firmware(struct device *dev)
 	if (fw->size != expected_size) {
 		dev_err(dev, "File size mismatch (expected %u, actual %zu). Corrupted IFS image.\n",
 			expected_size, fw->size);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto release;
 	}
 
 	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
-- 
2.39.2

