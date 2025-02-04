Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5377A21C168;
	Tue,  4 Feb 2025 22:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738709853; cv=none; b=WcSUw80NKwRnwwFxRZ5upNeO400Tdg/UqoLwgV3gdo7wxV5maDCtbQf97QPY5oqjpn9fIzsMTaVInccJgPJ6mGxiirgA4ztZyOpPRlEPKP3w3kET5fIinLje1VcFrAISC2UtHiYQviq/WMB3PBQlzfUyFx9OHbOQEwb4HFMz0fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738709853; c=relaxed/simple;
	bh=mTY+DrKg05PZUhHlWuukW5rELcmGnBoUUOaEVnlcjr8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E9F++ZGAavoHnv3KpJiQSQ83sxxziB85I4+fqLFyfAVAfh+B+qPWZtmA4vKL4WODELn2TNhYT0eIo4iOYAXJHmw5PXitcbXeJDdiPbhMVYu5zBWzSsrxDmqbjc0lhQ/EhFCYKu6AUtTV8PIJlL+RsglIG8FIbgPJ4R/d0ii1lCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ogIH2AeD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ogIH2AeD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ORxEaFpzeoq4+yV0cPvXeAvVVVHMpbAET1BB2wadKeI=; b=ogIH2AeDYoCIw6OTZLcwNDZ7Xb
	7dDdeqDlvRiHayjDWA1o6/pFKKhvl8k4Fp1+V6CVzqM0IejHvEGkgMFDvX//tHWNi7qiAlhAMCki7
	aQHgBe+pLZ6H+IR3rJjz3Zr/S39OhNrmU+cYHTVknwHzJOdsxpXNJkLlG8n5oqdkekPjDP0Slzj7Y
	U5JMK236kZuWPHvigcx6lRvzK+c3C2/b0D/kqr4ZgNKsx/TnpOd5g27r5w75/8CVW3VIifCShmzRf
	RFJe/FdS1fR0xV23aiRLQui4BXzSu/P/Tih1I87JfwiChYXggtLlrMEhqA+zPbShJTw9OB5rd+Jvu
	l7q6coSQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfRrH-00000001m1x-1AaE;
	Tue, 04 Feb 2025 22:57:31 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v2 0/4] enable bs > ps device testing 
Date: Tue,  4 Feb 2025 14:57:25 -0800
Message-ID: <20250204225729.422949-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

This v2 series addresses the feedback from the first series [0], namely:

  - uses less device specific names
  - checks for fio arguments --filename or --directory to extract the
    min io target or path
  - adds a new patch to verify the sector size will work before creating
    a filesystem
  - a diagram is provided to help easily disect why we use statx
    blocksize, although not included in the docs we could later if
    it helps

This goes tested against a 64k sector size NVMe drive, the patches for
which will be posted soon rebased on v6.14-rc1.

[0] https://lkml.kernel.org/r/20241218112153.3917518-1-mcgrof@kernel.org
[1] https://docs.google.com/drawings/d/e/2PACX-1vQeZaBq2a0dgg9RDyd_XAJBSH-wbuGCtm95sLp2oFj66oghHWmXunib7tYOTPr84AlQ791VGiaKWvKF/pub?w=1006&h=929                                                  
Luis Chamberlain (4):
  common: add and use min io for fio
  common/xfs: use min io for fs blocksize
  tests: use test device min io to support bs > ps
  common/xfs: check for max supported sector size

 common/fio      | 23 +++++++++++++++++++++--
 common/rc       | 21 +++++++++++++++++++++
 common/xfs      | 15 ++++++++++++++-
 tests/block/003 |  4 +++-
 tests/block/007 |  3 ++-
 tests/nvme/049  |  8 ++++++--
 6 files changed, 67 insertions(+), 7 deletions(-)

-- 
2.45.2

