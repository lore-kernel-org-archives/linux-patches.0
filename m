Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11D12F5C
	for <patches@lists.linux.dev>; Wed, 16 Mar 2022 23:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647471796; x=1679007796;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eqUjoxE2Nkz+Y3hHSOtqU495FHvWzX9BRIK78rtW204=;
  b=G9vfhXjN+PCTrm24UctmXy2X2skZXRnZktbj3N3XJ9ADa9A1j2SPcrRF
   t21D3gN7CfNz612F0BdNz4HAEAOY2FjW+x+E/4zS0W2qGCmC8Iov0lg3I
   CPatA5m5C5yBUjpDX0nn7NrZaKrseRg9B4cNY4qWb86ZOy8Gb7ht8LpUD
   jQA5fDK8JzpS0cxF5x4X/68foeA/aiNMld9hXFYqLOdPrBrwYAKBT3Ib8
   E0MgPQ5KYuBhiIPOrzVSMVWAWDChZLsH006vLvzFN3bycEfJniynttlht
   +YoBxcb0JWVUfxSGev4ypeJMxJMIxMFpaipgDn6P5JunXiD4XKMnJj4H7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="238895925"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="238895925"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="498621381"
Received: from msimpso1-cxt.amr.corp.intel.com (HELO localhost.localdomain) ([10.252.132.128])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 16:03:15 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: linux-cxl@vger.kernel.org
Cc: patches@lists.linux.dev,
	Ben Widawsky <ben@bwidawsk.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 0/7] Revamped region creation
Date: Wed, 16 Mar 2022 16:02:56 -0700
Message-Id: <20220316230303.1813397-1-ben.widawsky@intel.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Widawsky <ben@bwidawsk.net>

I will be on vacation all of next week so I'm trying to get this out now, even
though I still need to go over the locking and lifetimes. I'm certain there are
still issues there. I did want to start the discussion sooner rather than later
around the ABI changes.

The major changes from this series are:
- disambiguation of decoder types
- endpoint decoders size and volatility must be set
- regions are comprised of decoders instead of devices
- device physical address space is now managed
- split attrs for pmem and volatile region creation

In addition to these, I've tried to incorporate most of the fixes from Dan and
Jonathan up until this point in the original series, but I may have lost track
of some. I will circle back there too.

The last version of the patch series (with relevant cover letter) can be found
here: https://lore.kernel.org/linux-cxl/20220128002707.391076-1-ben.widawsky@intel.com/T/#t

Ben Widawsky (7):
  cxl/core: Use is_endpoint_decoder
  cxl/core: Distinguish cxl_decoder into types
  cxl/port: Surface ram and pmem resources
  cxl/core/hdm: Allocate resources from the media
  cxl/core/port: add decoder attrs for size and volatility
  cxl/region: Add region creation ABI
  cxl/region: Introduce concept of region configuration

 Documentation/ABI/testing/sysfs-bus-cxl       |  91 ++-
 .../driver-api/cxl/memory-devices.rst         |  11 +
 drivers/cxl/Kconfig                           |   8 +-
 drivers/cxl/acpi.c                            |   9 +-
 drivers/cxl/core/Makefile                     |   1 +
 drivers/cxl/core/core.h                       |   6 +
 drivers/cxl/core/hdm.c                        |  52 +-
 drivers/cxl/core/port.c                       | 452 ++++++++++++--
 drivers/cxl/core/region.c                     | 569 ++++++++++--------
 drivers/cxl/cxl.h                             | 161 ++++-
 drivers/cxl/mem.c                             |   7 +-
 drivers/cxl/region.h                          |  93 +++
 tools/testing/cxl/Kbuild                      |   1 +
 tools/testing/cxl/test/cxl.c                  |   7 +-
 14 files changed, 1134 insertions(+), 334 deletions(-)
 create mode 100644 drivers/cxl/region.h


base-commit: 74be98774dfbc5b8b795db726bd772e735d2edd4
prerequisite-patch-id: 034aeb7e124c5a34785c963bf014aa5380f00a2e
prerequisite-patch-id: 26f18c2ca586e6d734cd319e0e7f24398b17217f
prerequisite-patch-id: ef97136efb8c077232fe39a0465389565803a7b7
prerequisite-patch-id: 6a63e03117287b748cfec00e2c16a41ed38f4f9a
prerequisite-patch-id: dee89e9fa127e6442365177361a81c769173a9cb
prerequisite-patch-id: 1281430c1569659bb0f4a4b8fac8a108a02926ae
prerequisite-patch-id: 3e44f9db4e6ca77d9f2f80ed138234c82f521f2e
prerequisite-patch-id: 1d99dc5579333bbb009d58f6cc9ad01e3c936225
prerequisite-patch-id: 2014261afabca3797a34e5a2a01de678cb0ff545
prerequisite-patch-id: d3c61c56364ef5ed08b0a6f47c9a6b710ec5b6eb
prerequisite-patch-id: d28e6f8d2c0faf3392857370bc77bb51081604c6
prerequisite-patch-id: 5e8495c10b41d2e77a97c5c8c57b64813d80050b
prerequisite-patch-id: 3bc596df9dad86121dc24141d6293e3d1b7e6f99
prerequisite-patch-id: 7d8b673c521deeaa5ecbc78a0770974edd4a8287
prerequisite-patch-id: 224190b7e113853e710ba5fb06aa74faa8415b01
-- 
2.35.1

