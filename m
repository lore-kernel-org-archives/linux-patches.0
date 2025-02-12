Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89CA201018;
	Wed, 12 Feb 2025 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393694; cv=none; b=ZCgvaD0PjP/dNxwu5MLRNhRKuuwdkdBVvPF6a467qobSoQu29szreH+SmrOdDMl2roFkFRZ2uFxPdlln1Lm3jkuWmAx55aOCtBQeXfVGzcf06XKAE5090mMV4s99FimAZBR5X7h5Ef2Xmu1PlJtxdpcDYQAboB6Sy8SoDZT1Btw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393694; c=relaxed/simple;
	bh=uhsNxdAPKxHM3UCSDS1WcNl9HCUCQ2aGsyZBD15fNpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZPfXRV0Gcja7XEzP9MhYDHBBn3BDZCznYrC6/neIuV2g8uOpBtfFRItixPd596UOwvC7a+TeVLy5JzQDLnaERR2vHlFEQh+qxaett0eMT+tpNQV66gZ3ENelSRWe9KnHoZbptZ5X/5fxeqH8uyz9Z5kfFoqzRNgOVfO2I+5EGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PSpeok/e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PSpeok/e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1QlAPrdBxVcOCau1Ut5LJRxiWh5btrekG1D4njDcpeM=; b=PSpeok/eqVgLq8bV+wYRftOlSA
	TKHQsfbF6CtrLy79EAMsLXlHFFJQ+Agv7+poLGsrhdfsOiFAdWfGU+o9/sKBD/V1M4PznBD5EKwJ/
	n9S6L8OK9VdydlyQMZaJ6BqbpqrAEWM2akccXOTumcYu/nIgMdtjxqf+yPI5DaHdOWgoDucWBhmCr
	kvSREIXY1OO57itxklB58IBbAr+7NXHS6Gy7ajwr9bEOygeP2gYjXFA3yXEWd47lVx7VfqyOmYZ/g
	nzFuM7IaLNYGVPv5GW3v5+n32p8SFhi00n8+DVIDULcXMaX405L3PgLbm2CxiYgtp8IpNMu6C0F4z
	MEiylaUg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiJkw-00000008q8D-3PvR;
	Wed, 12 Feb 2025 20:54:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v3 4/6] common/xfs: use min io for fs blocksize
Date: Wed, 12 Feb 2025 12:54:46 -0800
Message-ID: <20250212205448.2107005-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250212205448.2107005-1-mcgrof@kernel.org>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Use the min io for the target block size. Likewise we need to increase
the log size if using a bs > 4096.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 common/xfs | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index 67a3b8a97391..226fdbd1c83f 100644
--- a/common/xfs
+++ b/common/xfs
@@ -13,10 +13,18 @@ _have_xfs() {
 _xfs_mkfs_and_mount() {
 	local bdev=$1
 	local mount_dir=$2
+	local bs
+	local xfs_logsize="64m"
+
+	bs=$(_min_io "$bdev")
+
+	if [[ $bs -gt 4096 ]]; then
+		xfs_logsize="128m"
+	fi
 
 	mkdir -p "${mount_dir}"
 	umount "${mount_dir}" >/dev/null 2>&1
-	mkfs.xfs -l size=64m -f "${bdev}" || return $?
+	mkfs.xfs -l size=$xfs_logsize -f "${bdev}" -b size="$bs" || return $?
 	mount "${bdev}" "${mount_dir}"
 }
 
-- 
2.45.2

