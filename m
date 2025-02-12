Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A25201258;
	Wed, 12 Feb 2025 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393693; cv=none; b=pVr5FWT+nUO/FTQVPWIujUPyEO+eOMntzFODlrkIoWRIaXzM8Er2LaCnkWYy58Y+HtdykEX9gu5ZNKg7crInK+Bk0rfKX1wtPgtHX4DCddFkoY5j1O9PySNkJEUjoL/hmlmzc430yPTy87xsIkSTTIGueEiWQUWMBZ/jkU2V4Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393693; c=relaxed/simple;
	bh=07qFMcDQ8An9Ib21CmoWdYlNhpc43kYAeKCaGsKQusE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1+pvxP27AtG6H6AsHsgSrP1Bb4lViJ7zP21mSmCCozbhUJU8dFoRYzeAQh/a1U+pIuEMW2l1WJ/gWxgA65yooIq/vQXSIzkT5Se1LdvlclQsJZWV8kQaEAnSwuU5Ep02GGza8NVaE1V5UAYECgebzCBJms6UvSGuG1TXBYeJ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B84msV45; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B84msV45"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UFWuuTJsuoXbom2W75IczMP+fGuQKORSKlCtAWBXU9w=; b=B84msV45oi2B2MRi8XHgaV3Ddb
	R9uvQWF6uEsUZKgUdD7hvs/Yqst4pEIurHxeenw94/7VJnokBDWg8Ne55LZ+h1idkDoHjtKzEgf6o
	MQcsPEIniEkiHWhAuTmJdUKHMLUrga592YqAcBTilaJGxJgsT9QwviQRTVLmXD204K8DJpNw34FaR
	iZWPtg59yHMbl70SlJWxR/Tny22qNLB6PpUY7j7qxadFYgrLzyZouh+Bl/2/ehkGNgaE+uNA7V+z6
	1MVoFc8SyEzPiseDY/+uuzB8ewrYB5GdOknGIMGUsivzTCHYv0xY7Q50U3vBBvQripVxs6965538E
	XtA4R6XA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiJkw-00000008q8H-3ebB;
	Wed, 12 Feb 2025 20:54:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v3 6/6] common/xfs: add _test_dev_suits_xfs() to verify logical block size will work
Date: Wed, 12 Feb 2025 12:54:48 -0800
Message-ID: <20250212205448.2107005-7-mcgrof@kernel.org>
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

mkfs.xfs will use the sector size exposed by the device, if this
is larger than 32k this will fail as the largest sector size on XFS
is 32k. Provide a sanity check to ensure we skip creating a filesystem
if the sector size is larger than what XFS supports.

Suggested-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 common/xfs      | 11 +++++++++++
 tests/block/032 |  3 ++-
 tests/nvme/012  |  1 +
 tests/nvme/035  |  1 +
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/common/xfs b/common/xfs
index 226fdbd1c83f..1342a8e61f0b 100644
--- a/common/xfs
+++ b/common/xfs
@@ -10,6 +10,17 @@ _have_xfs() {
 	_have_fs xfs && _have_program mkfs.xfs
 }
 
+_test_dev_suits_xfs() {
+	local logical_block_size
+
+	logical_block_size=$(_test_dev_queue_get logical_block_size)
+	if ((logical_block_size > 32768 )); then
+		SKIP_REASONS+=("sector size ${logical_block_size} is larger than max XFS sector size 32768")
+		return 1
+	fi
+	return 0
+}
+
 _xfs_mkfs_and_mount() {
 	local bdev=$1
 	local mount_dir=$2
diff --git a/tests/block/032 b/tests/block/032
index fc6d1a51dcad..74688f7fca6e 100755
--- a/tests/block/032
+++ b/tests/block/032
@@ -15,6 +15,7 @@ QUICK=1
 requires() {
 	_have_xfs
 	_have_module scsi_debug
+	_test_dev_suits_xfs
 }
 
 test() {
@@ -25,7 +26,7 @@ test() {
 	fi
 
 	mkdir -p "${TMPDIR}/mnt"
-	_xfs_mkfs_and_mount "/dev/${SCSI_DEBUG_DEVICES[0]}" "${TMPDIR}/mnt" >> $FULL || return $?
+	_xfs_mkfs_and_mount "/dev/${SCSI_DEBUG_DEVICES[0]}" "${TMPDIR}/mnt" >> "$FULL" || return $?
 	echo 1 > "/sys/block/${SCSI_DEBUG_DEVICES[0]}/device/delete"
 	udevadm settle
 	umount "${TMPDIR}/mnt" || return $?
diff --git a/tests/nvme/012 b/tests/nvme/012
index f9bbdca911c0..f2727c06c893 100755
--- a/tests/nvme/012
+++ b/tests/nvme/012
@@ -17,6 +17,7 @@ requires() {
 	_have_loop
 	_require_nvme_trtype_is_fabrics
 	_require_nvme_test_img_size 350m
+	_test_dev_suits_xfs
 }
 
 set_conditions() {
diff --git a/tests/nvme/035 b/tests/nvme/035
index 9f84ced53ce6..14aa8c22956b 100755
--- a/tests/nvme/035
+++ b/tests/nvme/035
@@ -14,6 +14,7 @@ requires() {
 	_have_kernel_option NVME_TARGET_PASSTHRU
 	_have_xfs
 	_have_fio
+	_test_dev_suits_xfs
 }
 
 device_requires() {
-- 
2.45.2

