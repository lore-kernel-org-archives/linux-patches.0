Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF012AD35
	for <patches@lists.linux.dev>; Tue, 18 Nov 2025 00:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763425684; cv=none; b=KNW26u909QmDxnofHf2hSGfzOK5r/8tbKYDf+AiM8Vf1oDJIFFDazCZEQsklGpgAoWxflAnimedbbc4OGVozEDfeKZDATDBVrR3GafHTZlP7HsSU3Mio3Bv8pgtxyAArxujPfJ7JPHwnLuxorE0OC0rOLV0qBaT0TCeg7teinyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763425684; c=relaxed/simple;
	bh=+8oNPNB9Rc4fJQykTNInDqBGbchJPu9APD58id/v5/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gLsu/qvTM5LOsLJo2MAHKUqPYHdUWmbRAHnWQcFg4ofP5YOzTcttF1k7IeTYr0bga7Pg9FEtgqHzAwn7Mo22hJeVkPcugYzGzBycAzh6oJxuIHbNrhiQI2HX7NP3IoVDxDiV9Q0Wck0XAWyqIyvEOf3mresBZc/CgXldp9vQjEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UHjWshKK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UHjWshKK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763425682; x=1794961682;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+8oNPNB9Rc4fJQykTNInDqBGbchJPu9APD58id/v5/Q=;
  b=UHjWshKKBxHVmBfu2pWqKrMvzg05Rp/C8+byMSmoRNVbA9m2HOzMm6qb
   ChoK6iGHv8kvlV+U8wcZDE2GiLrcB4wsNTVnWN/zso88JYEnIzHiFHgdr
   teT5qmJ/cf/0m8QeP1wIsIHLl4suOzwvsBCdbLhxbTvDyoGUJIUcKx+6l
   DUaLad1gDK6i+Kp83lxePiFUuUCi/FSSrHsgfflQge6EdJp0OBlYk9AOA
   hoE37HbGpOFg1xIzjY51Z3zgE9rivuWQ+JK6PAfu/l0H0JR3OOW7K3Zvr
   ps72g3cR1PhtoB9X9JyY4SHBdqdJ3vS/FrDq7t24Px8jqVTxy57vkDE1F
   A==;
X-CSE-ConnectionGUID: iuVqRHEKQ2aZZuOwJCH/ew==
X-CSE-MsgGUID: Kc25z0r+QCKAlBLwZ/HOQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="82827584"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="82827584"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:28:02 -0800
X-CSE-ConnectionGUID: kOzx7zz4QCKzZpZED4uTcA==
X-CSE-MsgGUID: Xy7QuMeXSPaSpH6a1GyooA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="191039469"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 16:28:01 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com,
	christophe.jaillet@wanadoo.fr
Subject: [PATCH] fs/resctrl: Consider sparse masks when initializing new group's allocation
Date: Mon, 17 Nov 2025 16:42:45 -0800
Message-ID: <abbbb008bc09d982d715e79d3b885c10f92c64e0.1763426240.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A new resource group is intended to be created with sane defaults. For
a cache resource this means all cache portions the new group could possibly
allocate into. This includes unused cache portions and shareable cache
portions used by other groups and hardware.

New resource group creation does not take sparse masks into account. After
determining the bitmask reflecting the new group's possible allocations the
bitmask is forced to be contiguous even if the system supports sparse masks.
For example, a new group could by default allocate into a large portion of
cache represented by 0xff0f, but it is instead created with a mask of 0xf.

Do not force a contiguous allocation range if the system supports sparse
masks.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Not a stable candidate because nobody has complained about this and it is
not a serious issue but instead an optimization. Discovered during code
inspection as part of review of:
https://lore.kernel.org/lkml/c5807e73e0f4068392036a867d24a8e21c200421.1761464280.git.christophe.jaillet@wanadoo.fr/

Tested on system that supports sparse masks.
---
 fs/resctrl/rdtgroup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0320360cd7a6..41ce4b377af4 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3383,11 +3383,12 @@ static u32 cbm_ensure_valid(u32 _val, struct rdt_resource *r)
 {
 	unsigned int cbm_len = r->cache.cbm_len;
 	unsigned long first_bit, zero_bit;
-	unsigned long val = _val;
+	unsigned long val;
 
-	if (!val)
-		return 0;
+	if (!_val || r->cache.arch_has_sparse_bitmasks)
+		return _val;
 
+	val = _val;
 	first_bit = find_first_bit(&val, cbm_len);
 	zero_bit = find_next_zero_bit(&val, cbm_len, first_bit);
 
-- 
2.50.1

