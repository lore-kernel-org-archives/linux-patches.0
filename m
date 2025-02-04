Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5384F21C172;
	Tue,  4 Feb 2025 22:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738709854; cv=none; b=UVuX2/tntA6MNAjsFTfZ8LIQyJqfpjn8k2oI5zf2Y64oMFISG/GMJsd03hFHA5U1WojmXJfSGcjvcvOpgqGkllwD5GJsi3iLwEDsNJ3TAXKdBpG4ltTHKh+HeThjl+ZMTWPJ2bcOjz2LAKKgStqcIx1ZbvDQWySTGwtLRSV7OUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738709854; c=relaxed/simple;
	bh=BODiohmKm8cTDp97zKOTvksVUaNhvdRHT/PhjLPoDGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9bbI6e6Mm1qOLpmuQeO9ewClgISLzc6kXvTmWkFTsJDWj4pHY+QoCxT+pZeR533my2pz/NjpGzfW4/jPWgX2B7e+bt1MCcmW/CV5/Ccs7zOagHibieeo9a9EEVUA8RNjaaFOJ1SerFMa3hegdSsIHo+ZFeW8aPG4NeZmC3qdss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JsrDsvXT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JsrDsvXT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=n5ePGnOybzLL4xMQV7kTXCqghOG4qwHDurKWjefDKY0=; b=JsrDsvXT4k/Tipfxf3PmLxNYl+
	lBR7kvFpTAbr7OHpJOvZx2nPZ1d/rv+hqNLHbxMBrnT+F+ODkkH774uhs6RJ9j57opTT+9o911wXW
	T+uavWZrqohwJh3yuJ4d+aMGTxZTMZcDEyFOQ31LnikbBNKPnvQC9PLof/8h49xUfTsfhJjDALagm
	aHZ8gK6LNMEwoxeR6sFx4fiyMxyME9ipmpdDUx3vPLsqbhXf4yMZwJ1azIvZNExOUJ2qDGGO4P7eY
	JuQd+wAqfFnNCevTeKExGd13MA6QZHDMvkK79GFJ8wgr8Qt60M6ujz/zRPHN7m9D/P/7m6Yt9xdBN
	6E5+zTrA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfRrH-00000001m25-1fSz;
	Tue, 04 Feb 2025 22:57:31 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v2 4/4] common/xfs: check for max supported sector size
Date: Tue,  4 Feb 2025 14:57:29 -0800
Message-ID: <20250204225729.422949-5-mcgrof@kernel.org>
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

mkfs.xfs will use the sector size exposed by the device, if this
is larger than 32k this will fail as the largest sector size on XFS
is 32k. Provide a sanity check to ensure we skip creating a filesystem
if the sector size is larger than what XFS supports.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 common/xfs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/common/xfs b/common/xfs
index 8b068837fa37..dbae572e4390 100644
--- a/common/xfs
+++ b/common/xfs
@@ -15,11 +15,18 @@ _xfs_mkfs_and_mount() {
 	local mount_dir=$2
 	local bs=$(_min_io $bdev)
 	local xfs_logsize="64m"
+	local sysfs="/sys/block/${bdev#/dev/}"
+	local logical_block_size=$(cat $sysfs/queue/logical_block_size)
 
 	if [[ $bs -gt 4096 ]]; then
 		xfs_logsize="128m"
 	fi
 
+	if [[ $logical_block_size -gt 32768 ]]; then
+		SKIP_REASONS+=("max sector size for XFS is 32768 but device $bdev has a larger sector size $logical_block_size")
+		return 1
+	fi
+
 	mkdir -p "${mount_dir}"
 	umount "${mount_dir}"
 	mkfs.xfs -l size=$xfs_logsize -f "${bdev}" -b size=$bs || return $?
-- 
2.45.2

