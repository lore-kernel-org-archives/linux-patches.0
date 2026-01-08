Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA0833D4E5
	for <patches@lists.linux.dev>; Thu,  8 Jan 2026 23:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767914845; cv=none; b=ZisjXSTQWDoeUpATn+kM2S3Nsfx93pWM7cA8JOBzJy7HtfIcL27HhmRRsapt17mztnm6id6IfFhrsKw+G21rzKwl8UED/a0V7wiUrFhVOVPSQwmGaRH70ptWIMiCfXTkssijg6H7lLzCVgrJDRhHf3cRkRqq1k/k4ouXxaEWKSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767914845; c=relaxed/simple;
	bh=P/yCHL3Fv6ZXx7m92+dvvQYt7T7zcsNmvQ5m2B3LHGU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H4CqEMdALWXzXjyU+cEEZsli+aBQonNgJQ6Kuk2SZeBaJMzENzGo5j3fUwOaJD6K5dCNr1nopJObjA/kTR2/xphz/4RwnBzUrE+XVWE5m2ChSeqHXQSGm2AcSaPS8I+gSvOS5ThJSmChGjOPrdr7nwrT+RpDQIFr0SlZlePFHME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PFoathz5; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PFoathz5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767914844; x=1799450844;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=P/yCHL3Fv6ZXx7m92+dvvQYt7T7zcsNmvQ5m2B3LHGU=;
  b=PFoathz5TTfUuPQ/D+d99uE1vhvgfPgl6AXTAm8Tnyr/EtGmsi3l5bIO
   ZMHkLskjcmsUi2+VwHSo1j7y0cVHntkzFMuTb6CHoLXzw+T5G27x0Mi1Z
   1PtYcgFYm2N3DcrkDAD56KmTKB2qJnWN1Fxh9vbI9hoANDEFuX5CIZbjW
   0KWS+s/pSdt7akFjyXvjZVuQYQupKi0Rl++mAzryGEothhhqXhXlNOsEu
   yX/BTNE95Ahhd0i7nL2Sd4aaGoUuoNf0alyjfRra40/ssufQbVqwsCsXO
   NHY1JLIIHKQURrdH0IHrzjWLwQGFAYfe+ExCjTwCSEn727zFXXndkEfO+
   g==;
X-CSE-ConnectionGUID: 8xGwCWlTQPKKi6ZORnclwg==
X-CSE-MsgGUID: 00qsRESoSjWyKoeQkpKlXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="80410271"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="80410271"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 15:27:23 -0800
X-CSE-ConnectionGUID: a8RshIc2T4WVTrjELyHDag==
X-CSE-MsgGUID: RKfnuE4yQeCTYON2tVS1jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="202536350"
Received: from khuang2-desk.gar.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.16])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 15:27:24 -0800
From: Tony Luck <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <edumazet@google.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] once: Don't use a work queue to reset sleepable static key
Date: Thu,  8 Jan 2026 15:27:17 -0800
Message-ID: <20260108232717.14411-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pointless overhead to use a work queue to reset the static key
for a DO_ONCE_SLEEPABLE() invocation.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 lib/once.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/once.c b/lib/once.c
index 2c306f0e891e..d83bdde78ced 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -93,6 +93,7 @@ void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
 {
 	*done = true;
 	mutex_unlock(&once_mutex);
-	once_disable_jump(once_key, mod);
+	BUG_ON(!static_key_enabled(once_key));
+	static_branch_disable(once_key);
 }
 EXPORT_SYMBOL(__do_once_sleepable_done);
-- 
2.52.0

