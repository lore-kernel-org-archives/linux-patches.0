Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C241332917;
	Wed, 26 Nov 2025 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764177068; cv=none; b=T/3AJAV+nf6DCDF5tKqwyQXPoXq8T4cspimdHxhQWIHbrvJH1jfonesYkLc7jCIxUnQgB9OwZba55ssgmifMGinQxfhjt1jgAP4rMl1bQy7Ex3dM7K5IO6gnt3YRO3CRMzfPcv647qvjsYAv1dmZCrsBSfgIbV14QMjtrniS2Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764177068; c=relaxed/simple;
	bh=4TmsGdNGUB2poVa22ol/bo3S+gZECsbxUIr9iCcpvpo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VdItIutbHq85367H8EIbSoah7XepwOO7jHe7XLANkoKRiwP4E+hsuuZRKV1tg9YTGkLSFnLnXfR2IO5slPRUTlhbBPR+rbpgj2ZG9FY3orWTYs/ddWUYFhp94lcw7svsJLEhHMV7I/E+fTYw1/H+zRyCOpeuLEbui7pzDGd6nxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mEnpOAzT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mEnpOAzT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=zgpKMhzO/1Cnz9B4m7VuYORK3sPePzi/DAhB9qeSzg4=; b=mEnpOAzTh/Bcl1TmygxJ3RFflK
	4m81iAR03wlhDzcmbRzSiZvLSdhzb0V6nbeQ/luylvb4X73OVE/kx/Pzl81gyFmcoIE8nHhU8syF3
	U/9RLULNvUPY17GjU4XeumJ2IDBwAXZdJjmcyzsgmDxc75Ps/lQ5pWt+c+G7kW7l+CgiLkB5Ujk+q
	WWvhfBgfxfM0kwKGzRhd/uAwhm8D8oJt7ATWtCWN2874zQ9wPuU/PUSoMHeCRFhCkPY8gNdgEekNG
	MeBgJtKjCzEGUvu8jo9y0MUM5mPTtwMEOMCG8xyH6vouRvLXHcMNyytc7kPag5Tr2EtNYG4xTcEsI
	iIZkMtzw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOJ2m-0000000FNAI-1Hgc;
	Wed, 26 Nov 2025 17:11:04 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	sw.prabhu6@gmail.com,
	kernel@pankajraghav.com,
	bvanassche@acm.org,
	mcgrof@kernel.org
Subject: [PATCH v4 0/2] blktests: use patient module remover
Date: Wed, 26 Nov 2025 09:11:00 -0800
Message-ID: <20251126171102.3663957-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

This rebases the patient module remover series onto the current blktests
tree and addresses all the feedback from v3 from a long time ago [0]. This
came up recently as Swarna noticed the same flaky bug and I got reminded
to re-send a new iteraiton.

We now have the modprobe --wait upstream so use that if avaiable.

The patient module remover addresses race conditions where module removal
can fail due to userspace temporarily bumping the refcount (e.g., via
blkdev_open() calls). If your version of kmod supports modprobe --wait,
we use that. Otherwise we implement our own patient module remover.

[0] https://lore.kernel.org/all/20221220235324.1445248-2-mcgrof@kernel.org/T/#u

Changes in v4:
  - Rebased onto current blktests master
  - Fixed built-in module handling: _patient_rmmod() now checks for
    the existence of /sys/module/$module_sys/refcnt to detect built-in
    modules and returns success early (Shinichiro Kawasaki)
  - Fixed timeout parameter timing issue: MODPROBE_PATIENT_RM_TIMEOUT_SECONDS
    is now evaluated dynamically inside _patient_rmmod() rather than at
    source time, allowing tests to override the timeout value
    (Shinichiro Kawasaki)
  - Preserved SKIP_REASONS logic in _init_null_blk() when modprobe fails,
    so tests requiring loadable modules are properly skipped rather than
    failing (Shinichiro Kawasaki)
  - Fixed typo in comment: "modprobe -p" -> "modprobe --wait"
    (Luis Chamberlain)
  - Fixed path reference bug: used $module_sys instead of $module for
    /sys/module path checks (Luis Chamberlain)
  - Combined nested while conditions for cleaner code style
    (Shinichiro Kawasaki)
  - Removed redundant $module printing in error messages
    (Shinichiro Kawasaki)
  - Updated to use --wait=TIMEOUT_MSEC syntax (with =) to match the
    upstream kmod implementation


Luis Chamberlain (2):
  blktests: replace module removal with patient module removal
  tests/srp/rc: replace module removal with patient module removal

 common/multipath-over-rdma |  11 +---
 common/null_blk            |   6 +-
 common/nvme                |   9 +--
 common/rc                  | 126 +++++++++++++++++++++++++++++++++++++
 common/scsi_debug          |  14 ++---
 tests/srp/rc               |  19 ++----
 6 files changed, 148 insertions(+), 37 deletions(-)

-- 
2.51.0

