Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CD119E97C;
	Wed, 18 Dec 2024 11:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734520919; cv=none; b=EBIqjjHQMUYwVypl8jp18i8YcLjgbQZawOEJzj4WMy6i7gvawVy8PTeRzlmHOk/g/EpoqyFZAJ5ctqfPRsAIl4wOyUNLtLK1RRHfGYgbMW/HeKGz7wA5Z7JKB9HVBCJMIcyu/Uhv4pbIYhMqoCovmDrn2LQYoBJDADFRuetaHN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734520919; c=relaxed/simple;
	bh=1xD77kve++4w7+ixwrVcbw1MRbG3nG3vmLdmb6krfuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iF3AIxvBVUKECPlyBhDVYjyA4+xEEj5kOncWpNOn4tQ+yY7pvWn13xm5lbGyoNyAR9ptbWRryQPXeUVtBx8JM+dDdPIbJ11kII1dYAq6p2vqvCemEOvRSekmDHMcPnKQjVZ0QWIyFRBsVXp8Lzk4IfKOvHfVFGB3Fhll438dduU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YoXbY49L; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YoXbY49L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PBOI/RSiWVX6KS2NYMUn31dr6SwjWOaTlfliT91lavE=; b=YoXbY49LUaokQ4CeQw9YCQ//tx
	sEdae+u8Id5zeIQL9BLZBdZDa3w65myp0GsEIqBDHPqpFHMw8Hk1VI1LjbmVJg+vheUD2OhSodfI2
	S/W+Lh7C0CYUXSRcWp8LF3bKEyZEczGdy3hb9ZLsHKLk+ANWI4TbRtQfm505O1IpgFvkuZEIZmeNm
	qSsIrkQvUa4Pv4ExsOc4DQomdYhgbJ/3RixSeykyeVVAom6BQKvTU9Ww7ioCVq6/68w6Rna2auIbr
	LH/B+xmc7lYw5QXGKtSxFhbP9uopatuv/sy6fb/EBbeVJ6k8Lw+RR0CcOIhwstaE6d9p+AfJwU0uT
	y11yP5sA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tNs7o-0000000GR84-45s5;
	Wed, 18 Dec 2024 11:21:56 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests 3/4] tests: use test device min io to support bs > ps
Date: Wed, 18 Dec 2024 03:21:52 -0800
Message-ID: <20241218112153.3917518-4-mcgrof@kernel.org>
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

When a block device supports a minimum block size > ps we must
ensure we don't issue IOs below what is supported. Just leverage
the min optimal IO to also ensure we use the optimal IO as well.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 tests/block/003 | 4 +++-
 tests/block/007 | 3 ++-
 tests/nvme/049  | 5 +++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tests/block/003 b/tests/block/003
index 2af9b89ec3e5..e57d76271b8b 100755
--- a/tests/block/003
+++ b/tests/block/003
@@ -18,10 +18,12 @@ device_requires() {
 }
 
 test_device() {
+	local test_dev_bs=$(_test_dev_min_io $TEST_DEV)
+
 	echo "Running ${TEST_NAME}"
 
 	FIO_PERF_FIELDS=("trim iops")
-	_fio_perf --bsrange=4k-4g --rw=randtrim --norandommap --name=discards \
+	_fio_perf --bsrange=${test_dev_bs}-4g --rw=randtrim --norandommap --name=discards \
 		--filename="$TEST_DEV" --number_ios=200k
 
 	echo "Test complete"
diff --git a/tests/block/007 b/tests/block/007
index 3b68d0deec35..793bb4c45c05 100755
--- a/tests/block/007
+++ b/tests/block/007
@@ -31,13 +31,14 @@ cleanup_fallback_device() {
 }
 
 run_fio_job() {
+	local test_dev_bs=$(_test_dev_min_io $TEST_DEV)
 	if _test_dev_is_rotational; then
 		size="32m"
 	else
 		size="1g"
 	fi
 
-	_fio_perf --bs=4k --rw=randread --norandommap --name=reads \
+	_fio_perf --bs=$test_dev_bs --rw=randread --norandommap --name=reads \
 		--filename="$TEST_DEV" --size="$size" --direct=1 \
 		--ioengine=pvsync2 --hipri="$1"
 }
diff --git a/tests/nvme/049 b/tests/nvme/049
index 88d4fb122988..6bb731f84fbf 100755
--- a/tests/nvme/049
+++ b/tests/nvme/049
@@ -19,10 +19,11 @@ test_device() {
 	echo "Running ${TEST_NAME}"
 
 	local ngdev=${TEST_DEV/nvme/ng}
+	local test_dev_bs=$(_test_dev_min_io $ngdev)
 	local common_args=(
 		--size=1M
 		--filename="$ngdev"
-		--bs=4k
+		--bs=$test_dev_bs
 		--rw=randread
 		--numjobs=1
 		--iodepth=16
@@ -35,7 +36,7 @@ test_device() {
 	local fio_output
 
 	# check security permission
-	if ! fio_output=$(fio --name=check --size=4k --filename="$ngdev" \
+	if ! fio_output=$(fio --name=check --bs=$test_dev_bs --size=32k --filename="$ngdev" \
 			    --rw=read --ioengine=io_uring_cmd 2>&1) &&
 			grep -q -e "Operation not permitted" \
 				-e "Permission denied" <<< "$fio_output"; then
-- 
2.43.0

