Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA8B202C32;
	Wed, 12 Feb 2025 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393693; cv=none; b=V8ymlX8rn6uBK6ZlU2xBtwvc1697XGM6TJwkMlYja+rymlwcfFPPUeA4scdvi/tgw/NUAn2pR1YJmf0uEQdlkGa0wZEwFgwWGxhLhKwWiwscvIkEIujaiJtJKgmTHv3ZylDq7MkWSXwNTXKR+C3EY3uTqkSOH2GYTV2xBOb/YYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393693; c=relaxed/simple;
	bh=Di7ZCuht89rGJbgc5fTYIK6TnUgp4/cGLdBz5UkzNuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k/hDB5YK/sAyA3xp3wwOxxuftgDLcw85v637LvKrG/SnZcXbI71vVLsVI3pheNnNQ8ChWkxsF6Njc6E38d9apObBV4ZkPmiyLsjEb8ohRXWh3ztg9GGZOVQEyHyOFPa9pXQz2FA5M8P2Ln7jBB9cXuXn+bwcfpfuoS6+DVSE7kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IaqgLLKS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IaqgLLKS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=MDe5MlqzTjN3qy/1dUBy4rXWUWp+5LRgOl2dkUwNMOM=; b=IaqgLLKS5mXlGd9JsUbKocTCGb
	9zxvi+mD8eKBKoKEby0YDg7w9HJ0YpTdzT8XBUJIiTqF32bAlBZTgXVM5HpfzmWfV26fLbnKGoe5H
	hkVOADfUV+veYS63UIUQX1CZ2HWMPS94UeWcnxFZRa4wGfRhN+INN7UcH1GXwOhQRGwKMZgItyLFT
	NuLjcaHlc1P/oCdoRHzuPyRL8bZO3J9TtRJP4d4FHj8qxAZmWkyyPBw4qz/lUfJbPOI4R+KPyYXGZ
	UUaDzDVuQ+jy8s8QoMjW8TPRjXkUjQC398Krz4KprACISXsYYph/FQrXYWa61XLGtsxUcMjJCyGwq
	u9z1XvKA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiJkw-00000008q85-2wsf;
	Wed, 12 Feb 2025 20:54:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v3 0/6] enable bs > ps device testing
Date: Wed, 12 Feb 2025 12:54:42 -0800
Message-ID: <20250212205448.2107005-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

This v3 series addresses the feedback from the v2 series [0] and
makes some minor new changes, the change are:

  - Fixes all shellcheck complaints
  - Addresses spacing / tabs fixes
  - Adds _test_dev_suits_xfs() as suggested by Shinichiro and makes
    tests which require this depend on it
  - Clamps _min_io() to 4k as well for backward compatibility
  - Few minor enhancements to help capture up error messages from
    mkfs from block/032

This goes tested against a 64k sector size NVMe drive, and also
using ./check so regular loopback devices are used. This helps
test 64k sector devices, patches for which have been posted [1].
                                                                                                                                                                                              
[0] https://lkml.kernel.org/r/20250204225729.422949-1-mcgrof@kernel.org
[1] https://lkml.kernel.org/r/20250204231209.429356-1-mcgrof@kernel.org

Luis Chamberlain (6):
  common/xfs: ignore first umount error on _xfs_mkfs_and_mount()
  block/032: make error messages clearer if mkfs or mount fails
  common: add and use min io for fio
  common/xfs: use min io for fs blocksize
  tests: use test device min io to support bs > ps
  common/xfs: add _test_dev_suits_xfs() to verify logical block size
    will work

 common/fio      | 26 ++++++++++++++++++++++++--
 common/rc       | 24 ++++++++++++++++++++++++
 common/xfs      | 23 +++++++++++++++++++++--
 tests/block/003 |  6 +++++-
 tests/block/007 |  5 ++++-
 tests/block/032 |  7 ++++---
 tests/nvme/012  |  1 +
 tests/nvme/035  |  1 +
 tests/nvme/049  | 15 +++++++++++----
 9 files changed, 95 insertions(+), 13 deletions(-)

-- 
2.45.2

