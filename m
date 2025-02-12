Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB39202C33;
	Wed, 12 Feb 2025 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393693; cv=none; b=JSmDCsZgafFCNysFE+R2bXF+TXh1t0W4wh66qADEkB9uXJskP8dWxKtDzOer2ivRBZTv+aTf6o6xYlkiUPCVY59ZeR+MMJKv5jyiWQ/4Zv+2+aee6O4M6Y+HY/bY43F5BvYA2C0THUgXa+UJRULrhl1LRlIoDByngeuClqwNUoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393693; c=relaxed/simple;
	bh=adWzKjCFzxNuBVmy6SjaplBwVSgeL5T0CTiWNombh0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aK6mCtQNMFjKCOo3hRqI4DTRdKqsxSf+bWXNORgrUVq/3pBERZi3neroIFyNNCGZLZF586IDUHif+I/LTbd6JK3iGrnh9p0RzvRK/euKutJHFPjBm6D6luZf00gn4aZjtSzIvE9Ge7hViLlOcnDoIBEgx3QYGFAwJtTg8810pYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PXYKkZ4k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PXYKkZ4k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GTl9k7yAp3U+wqtvYfSngx+82iSSK1W56O6UQmOfBSE=; b=PXYKkZ4kXDkrRglQQ2HhUArvl7
	RJnZToAppKUKsYXqt4OwyD0iwfeyvrS6i7MhclTrXpcto2HwFP7dPPF4l88UFRWjm40Q/w6TK4R/9
	6U/qCFuZIDPDhXyOgjCa7CkUbNiiqtKrNzu1qawp9ma13Cs5FPI1UrDkuhF89Ov+cp3sgKeM1YkDz
	SSMwvmVZ3l/YE3VgyFoCftZRQ+orkrNCTE3QO/PRFw8xRSETiQjcoJWIdRCqUi6/cYSGb62wNTvkd
	F+2EOnyBs+L4JrF2beMlEpth/V4AXWlEQZjkV7bOh1y6UtD0yiFUBJEwaVl/LDIyZWG1fuhBtua/4
	/6j+ctdw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiJkw-00000008q8F-3XES;
	Wed, 12 Feb 2025 20:54:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v3 5/6] tests: use test device min io to support bs > ps
Date: Wed, 12 Feb 2025 12:54:47 -0800
Message-ID: <20250212205448.2107005-6-mcgrof@kernel.org>
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

When a block device supports a minimum block size > ps we must
ensure we don't issue IOs below what is supported. Just leverage
the min optimal IO to also ensure we use the optimal IO as well.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 tests/block/003 |  6 +++++-
 tests/block/007 |  5 ++++-
 tests/nvme/049  | 15 +++++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/tests/block/003 b/tests/block/003
index 2af9b89ec3e5..b0dd1d1fd62b 100755
--- a/tests/block/003
+++ b/tests/block/003
@@ -18,10 +18,14 @@ device_requires() {
 }
 
 test_device() {
+	local test_dev_bs
+
+	test_dev_bs=$(_min_io "$TEST_DEV")
+
 	echo "Running ${TEST_NAME}"
 
 	FIO_PERF_FIELDS=("trim iops")
-	_fio_perf --bsrange=4k-4g --rw=randtrim --norandommap --name=discards \
+	_fio_perf --bsrange="${test_dev_bs}"-4g --rw=randtrim --norandommap --name=discards \
 		--filename="$TEST_DEV" --number_ios=200k
 
 	echo "Test complete"
diff --git a/tests/block/007 b/tests/block/007
index 3b68d0deec35..8043a83a565b 100755
--- a/tests/block/007
+++ b/tests/block/007
@@ -31,13 +31,16 @@ cleanup_fallback_device() {
 }
 
 run_fio_job() {
+	local test_dev_bs
+
+	test_dev_bs=$(_min_io "$TEST_DEV")
 	if _test_dev_is_rotational; then
 		size="32m"
 	else
 		size="1g"
 	fi
 
-	_fio_perf --bs=4k --rw=randread --norandommap --name=reads \
+	_fio_perf --bs="$test_dev_bs" --rw=randread --norandommap --name=reads \
 		--filename="$TEST_DEV" --size="$size" --direct=1 \
 		--ioengine=pvsync2 --hipri="$1"
 }
diff --git a/tests/nvme/049 b/tests/nvme/049
index 88d4fb122988..7304d6604d8f 100755
--- a/tests/nvme/049
+++ b/tests/nvme/049
@@ -19,10 +19,16 @@ test_device() {
 	echo "Running ${TEST_NAME}"
 
 	local ngdev=${TEST_DEV/nvme/ng}
-	local common_args=(
+	local test_dev_bs
+	local target_size=4096
+	local common_args=()
+	local fio_output
+
+	test_dev_bs=$(_min_io "$ngdev")
+	common_args=(
 		--size=1M
 		--filename="$ngdev"
-		--bs=4k
+		--bs="$test_dev_bs"
 		--rw=randread
 		--numjobs=1
 		--iodepth=16
@@ -32,10 +38,11 @@ test_device() {
 		--time_based
 		--runtime=2
 	)
-	local fio_output
+
+	((test_dev_bs > target_size)) && target_size=$test_dev_bs
 
 	# check security permission
-	if ! fio_output=$(fio --name=check --size=4k --filename="$ngdev" \
+	if ! fio_output=$(fio --name=check --bs="$test_dev_bs" --size="$target_size" --filename="$ngdev" \
 			    --rw=read --ioengine=io_uring_cmd 2>&1) &&
 			grep -q -e "Operation not permitted" \
 				-e "Permission denied" <<< "$fio_output"; then
-- 
2.45.2

