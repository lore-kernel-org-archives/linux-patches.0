Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C1B19E7ED;
	Wed, 18 Dec 2024 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734520919; cv=none; b=SmACTn0Pv8Yqz14hcc7jXNGnDit2Bl4q6nHHyBeDh3ksYmfYZ2rOlEZJsVpZhMIR+IHUf0+NpygFzzGHeP1Fo/T4GFJRLjun/xgCsCEYuS8d9eKTq53WZs/NjUonNMy2oCmL+Oklz8SOvVUvsdSJClLN/93fMFmyxCoZeFW7Pxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734520919; c=relaxed/simple;
	bh=8r4gGTWPzlILiLbetBZnbcnrC8JAxuNPm9Ga0RRHTS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBYjX7BF2/JQC1jmsuLi71ZKF1olltuRnadLQFyhVUlw9DdcfxDZY43l4rvKyI9DDwtsL7BY9wzQYPGnyoT6WosannNJY6l09gFyb66ksJK4lIIiSngPVkp/I5lwKygPqPpUpEZKG4bWnbZEO4Dd8duO+dSftWg0uRiGZlvUzTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=er9sJQWU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="er9sJQWU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AtOhcyeyDLfXWPm1hwV+4pH60DjH2HtjIYCmg3gb12M=; b=er9sJQWUEupriCV1uJLNVvXRK5
	EXRthyitipvWpqJ93IGFDSa6CgfLtBgmMFxUC1+lsqmv9G96/infKHywiG7RO1afIivcwUuGSO1c6
	jRKwmPJ17w52MGJt6YmEBWLj2cuhTRqWmq5UZ6wlk6q6lW4DiSyh2IYBTaf4kTl18e9cGzEYclYna
	to9jHPewdvYhAxJSBKrBKdKTH4hW/HA1YxZfuu3SB1xwqGHQN1GZIMHRYVvY2+LIJ/CZleP0w6+qP
	RlYfTWypK2Sr8KEZJnAMh0Bhk+JjvL1CJ4gh75Pi9o5awMUwdGA4xkyuLh48AzXma4sN1+v4ntNKK
	lgqte9fA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNs7o-0000000GR80-3r2G;
	Wed, 18 Dec 2024 11:21:56 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests 1/4] common: add and use min io for fio
Date: Wed, 18 Dec 2024 03:21:50 -0800
Message-ID: <20241218112153.3917518-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241218112153.3917518-1-mcgrof@kernel.org>
References: <20241218112153.3917518-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

When using fio we should not issue IOs smaller than the device supports.
Today a lot of places have in place 4k, but soon we will have devices
which support bs > ps. For those devices we should check the minimum
supported IO.

However, since we also have a min optimal IO, we might as well use that
as well. By using this we can also leverage the same lookup with stat
whether or not the target file is a block device or a file.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 common/fio |  6 ++++--
 common/rc  | 10 ++++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/common/fio b/common/fio
index b9ea087fc6c5..5676338d3c97 100644
--- a/common/fio
+++ b/common/fio
@@ -192,12 +192,14 @@ _run_fio() {
 # Wrapper around _run_fio used if you need some I/O but don't really care much
 # about the details
 _run_fio_rand_io() {
-	_run_fio --bs=4k --rw=randread --norandommap --numjobs="$(nproc)" \
+	local test_dev_bs=$(_test_dev_min_io $TEST_DEV)
+	_run_fio --bs=$test_dev_bs --rw=randread --norandommap --numjobs="$(nproc)" \
 		--name=reads --direct=1 "$@"
 }
 
 _run_fio_verify_io() {
-	_run_fio --name=verify --rw=randwrite --direct=1 --ioengine=libaio --bs=4k \
+	local test_dev_bs=$(_test_dev_min_io $TEST_DEV)
+	_run_fio --name=verify --rw=randwrite --direct=1 --ioengine=libaio --bs=$test_dev_bs \
 		--iodepth=16 --verify=crc32c --verify_state_save=0 "$@"
 }
 
diff --git a/common/rc b/common/rc
index 0c8b51f64291..884677149c9e 100644
--- a/common/rc
+++ b/common/rc
@@ -387,6 +387,16 @@ _test_dev_is_partition() {
 	[[ -n ${TEST_DEV_PART_SYSFS} ]]
 }
 
+_test_dev_min_io() {
+	local any_dev=$1
+	if [ -c  $any_dev ]; then
+		if [[ "$any_dev" == /dev/ng* ]]; then
+			any_dev="${any_dev/ng/nvme}"
+		fi
+	fi
+	stat --printf=%o $any_dev
+}
+
 # Return max open zones or max active zones of the test target device.
 # If the device has both, return smaller value.
 _test_dev_max_open_active_zones() {
-- 
2.43.0

