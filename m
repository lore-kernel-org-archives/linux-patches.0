Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A5B21B181;
	Tue,  4 Feb 2025 22:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738709853; cv=none; b=YXOI7YtRBXXMUv5s4wanBa1xFDb79ZVXyhhKIEd2bfHcp6p/+cEcTOs9fZfOAtpbxzx1Kn23iDpINcjZ3YjSCPpX1XCtxptn/Wn34eYL56UsCBOSROhNvNZV4C1IflMinU8n33kzZJAgBGFyaoIoR2UEMNbEmGkmd1wJSIqNKcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738709853; c=relaxed/simple;
	bh=+sEXBuqmpbVuSN4Obp7rsVTc0g+gOMgqn8snZuHBnsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FepDWgSVR5eJAlG8FKk1JLCSYMXPikuPXZSWfL0jNVBGRwLuDJtQ7w+xTB4Zk1BQgmFvCgpemUZ2Ut9QUerthxP68zh+uqD/z5MIM36izTf7mgIo0DUTZAOwXIO181in+KXtNH0JSvxN7ggCLOQoP4WSR8/PwXMcgEdQTySDRwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OXBsfztz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OXBsfztz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QarJhWvhvzscEqk1hK64UZ1lx9htgiBiWPInl87qBdw=; b=OXBsfztzeCul4tIizLK9z2R8YD
	aD4IDFjh4gCmzOLNOXkZE05geFJ/HW3WyhDqpesS1tirqcj8ua1hcJ0dwH3ggBgB7jnMNKxXDCTpV
	4xTLMwYV15TBXfNPX89cjgzh6N2txoe/T7c4HOZAg7KD1ti74N94831cjvpQySd1h3WSw7rSl6wYN
	d8dn7uX74ETR350GwuT2LWwy6vZkQ1aBZHq5k/OMRv5yvUZmXmyvcLkwsG4SG8VTjdsuxKOpl/aqo
	YMS9tuZwQqNBs3hB13+oHbrH0zA7y7pKhYW8iuhuf53LdKKHZZ3ZUQBsGkKTqDfceMsb1f9g+Yafa
	Fd3SX/YA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfRrH-00000001m23-1YV9;
	Tue, 04 Feb 2025 22:57:31 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v2 3/4] tests: use test device min io to support bs > ps
Date: Tue,  4 Feb 2025 14:57:28 -0800
Message-ID: <20250204225729.422949-4-mcgrof@kernel.org>
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

When a block device supports a minimum block size > ps we must
ensure we don't issue IOs below what is supported. Just leverage
the min optimal IO to also ensure we use the optimal IO as well.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 tests/block/003 | 4 +++-
 tests/block/007 | 3 ++-
 tests/nvme/049  | 8 ++++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/tests/block/003 b/tests/block/003
index 2af9b89ec3e5..d59f2eadd465 100755
--- a/tests/block/003
+++ b/tests/block/003
@@ -18,10 +18,12 @@ device_requires() {
 }
 
 test_device() {
+	local test_dev_bs=$(_min_io $TEST_DEV)
+
 	echo "Running ${TEST_NAME}"
 
 	FIO_PERF_FIELDS=("trim iops")
-	_fio_perf --bsrange=4k-4g --rw=randtrim --norandommap --name=discards \
+	_fio_perf --bsrange=${test_dev_bs}-4g --rw=randtrim --norandommap --name=discards \
 		--filename="$TEST_DEV" --number_ios=200k
 
 	echo "Test complete"
diff --git a/tests/block/007 b/tests/block/007
index 3b68d0deec35..8d4ee0758b12 100755
--- a/tests/block/007
+++ b/tests/block/007
@@ -31,13 +31,14 @@ cleanup_fallback_device() {
 }
 
 run_fio_job() {
+	local test_dev_bs=$(_min_io $TEST_DEV)
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
index 88d4fb122988..77bb4daf5b08 100755
--- a/tests/nvme/049
+++ b/tests/nvme/049
@@ -19,10 +19,12 @@ test_device() {
 	echo "Running ${TEST_NAME}"
 
 	local ngdev=${TEST_DEV/nvme/ng}
+	local test_dev_bs=$(_min_io $ngdev)
+	local target_size=4096
 	local common_args=(
 		--size=1M
 		--filename="$ngdev"
-		--bs=4k
+		--bs=$test_dev_bs
 		--rw=randread
 		--numjobs=1
 		--iodepth=16
@@ -34,8 +36,10 @@ test_device() {
 	)
 	local fio_output
 
+	((test_dev_bs > target_size)) && target_size=$test_dev_bs
+
 	# check security permission
-	if ! fio_output=$(fio --name=check --size=4k --filename="$ngdev" \
+	if ! fio_output=$(fio --name=check --bs=$test_dev_bs --size=$target_size --filename="$ngdev" \
 			    --rw=read --ioengine=io_uring_cmd 2>&1) &&
 			grep -q -e "Operation not permitted" \
 				-e "Permission denied" <<< "$fio_output"; then
-- 
2.45.2

