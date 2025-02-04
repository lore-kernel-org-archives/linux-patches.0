Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AC421B8F7;
	Tue,  4 Feb 2025 22:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738709853; cv=none; b=BK08vYjxvvaWGYHzyMCFXNiTLxZwGUlwRuxVczCAas9TT1hE6vpcmEvwJZHzOLxfAok09W8xqwCjcoQMjtmuc+E9ezGlVOxwc7ewNNbfEBRmdJP5d8GP+ymfWaokJePoOZqfktcPfMrXNH2ozLfu/ld/ELK1Jag0+ZfPh+tpU78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738709853; c=relaxed/simple;
	bh=rGGmHFEY6+I2QsPlKgaRgK9IKJ9e/bHNPu0Y/4PxGFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRn02EoVe7Xnfo6aL308mtUnx6y5luP4giDhUeRNmcAXzaz1VjpRPydIoH34mRHedWhO70r0C3EuR7/esEB5YZ3FJdrVgGlOtgBmm0UQluvTOFNFUOhmPjRnaFrOsPhDOO5OWUO+sapF2lvlSYX9mLxRZ+gqT98IP7sRIOZUxPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A8eVT3Yz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A8eVT3Yz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/WSr4eK+w8nCw+zDhetQoEDG+PACdKmOWZPtoiEN+Zw=; b=A8eVT3YzKL3M3vkDHj6/+swUXh
	pKUwDHBnQD+sLQ8RDRChyea59dqB6Svafu8nvOftsfAERbDG9BOHKa7cym8MbxMqasKarANe5s7QM
	yJgGmSXexhW5uiXjuUvb3HCayTen19ZQJsICAx4BMvheg4Y5+udF1g//fFECx64wIQATOUecsimq5
	HePyBeR6VK1s1yyVSBk9BmLocgmJLbowsrzDP073sV5LgCvWuwvJYF68KzRmjYSX17eoAXee1m9vZ
	wpBkJd+EvpE57koBjM+2EmLVXNWKi4PQTOB0oe08J/lLS4o9X9ikE5hd8DOegibrE0jSwhkhLVSMK
	8SlQy1nQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfRrH-00000001m21-1QEZ;
	Tue, 04 Feb 2025 22:57:31 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v2 2/4] common/xfs: use min io for fs blocksize
Date: Tue,  4 Feb 2025 14:57:27 -0800
Message-ID: <20250204225729.422949-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250204225729.422949-1-mcgrof@kernel.org>
References: <20250204225729.422949-1-mcgrof@kernel.org>
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
 common/xfs | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index 569770fecd53..8b068837fa37 100644
--- a/common/xfs
+++ b/common/xfs
@@ -13,10 +13,16 @@ _have_xfs() {
 _xfs_mkfs_and_mount() {
 	local bdev=$1
 	local mount_dir=$2
+	local bs=$(_min_io $bdev)
+	local xfs_logsize="64m"
+
+	if [[ $bs -gt 4096 ]]; then
+		xfs_logsize="128m"
+	fi
 
 	mkdir -p "${mount_dir}"
 	umount "${mount_dir}"
-	mkfs.xfs -l size=64m -f "${bdev}" || return $?
+	mkfs.xfs -l size=$xfs_logsize -f "${bdev}" -b size=$bs || return $?
 	mount "${bdev}" "${mount_dir}"
 }
 
-- 
2.45.2

