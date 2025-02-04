Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537E721C16F;
	Tue,  4 Feb 2025 22:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738709854; cv=none; b=gMDLzgkHPf0PhAgRJe2igXXBLGzPgyH7Zd/PlWBDYpI/55SVkhb009YLg7/evb8U1Yo+qT90h9badaITxkGcmS3iRauTrQE9z3ajqdln0ZxIhzwp2gg1pIFjhZZFLX1POTDH8uU2QmnaBtYKOAFjVxyXFqPTN3Di0s51WN1TFEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738709854; c=relaxed/simple;
	bh=kO6f1O3HDdOalRErMblvO0RYv+5OS8N10AM+0kpGYos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tatqNzfVZ0qGts4Wr1x4iHXPBsAdZUb3NDIRD1QPlG+eCJTjxUCEv55QbXY64UIsOmug+/YambuxYD/U0FucYmG295qtp8pkRI74x3/J6k6iqKLz+p77nP73PXu/7aSf4IC0uu1azj/sBGcPUzzlggJhAE6UElL4sxP1pri4PDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iPPVhclQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iPPVhclQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YPetv4ik80Bce3zURVkwPK6SPctmLOIvLZPcpZz2oRw=; b=iPPVhclQkmipZWC0RD0kSGepZH
	7NOOSozhmMzl7hdZJWy5npD354FpvcHGLt+D1yyCrAs0UqPxJOmKohMsfuiJigjzwVq3WPVzQV6qG
	Z51v3By8HvYHfbOlqX3wBOoLFNo9p4+Bnj4k26GIkvjI74Vwb8jxI0GTd6oxuplBMzWD/mRuSHhPW
	JpjLdS9VUzaQBiWKt3g+1TuK7dFMlkviYawRJRAvNOapIP8uu/X73AT9u6hW+GK63GHBadVAjgFlq
	lJhs270WqLFDwFCk+30zuR1iImyHgKdUP8c0rZxWYnK7W6yPW5RJbWoaV3kM1dyt+X+yLBuc7B1Xq
	e141YRoA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tfRrH-00000001m1z-1J9y;
	Tue, 04 Feb 2025 22:57:31 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v2 1/4] common: add and use min io for fio
Date: Tue,  4 Feb 2025 14:57:26 -0800
Message-ID: <20250204225729.422949-2-mcgrof@kernel.org>
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

When using fio we should not issue IOs smaller than the device supports.
Today a lot of places have in place 4k, but soon we will have devices
which support bs > ps. For those devices we should check the minimum
supported IO.

However, since we also have a min optimal IO, we might as well use that
as well. By using this we can also leverage the same lookup with stat
whether or not the target file is a block device or a file.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 common/fio | 23 +++++++++++++++++++++--
 common/rc  | 21 +++++++++++++++++++++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/common/fio b/common/fio
index b9ea087fc6c5..557150656b29 100644
--- a/common/fio
+++ b/common/fio
@@ -189,15 +189,34 @@ _run_fio() {
 	return $rc
 }
 
+_fio_opts_to_min_io() {
+        local arg path
+        local -i min_io=4096
+
+        for arg in "$@"; do
+                [[ "$arg" =~ ^--filename= || "$arg" =~ --directory= ]] || continue
+                path="${arg##*=}"
+		min_io=$(_min_io "$path")
+                # Keep 4K minimum IO size for historical consistency
+                ((min_io < 4096)) && min_io=4096
+                break
+        done
+
+        echo "$min_io"
+}
+
+
 # Wrapper around _run_fio used if you need some I/O but don't really care much
 # about the details
 _run_fio_rand_io() {
-	_run_fio --bs=4k --rw=randread --norandommap --numjobs="$(nproc)" \
+	local bs=$(_fio_opts_to_min_io "$@") || return 1
+	_run_fio --bs=$bs --rw=randread --norandommap --numjobs="$(nproc)" \
 		--name=reads --direct=1 "$@"
 }
 
 _run_fio_verify_io() {
-	_run_fio --name=verify --rw=randwrite --direct=1 --ioengine=libaio --bs=4k \
+	local bs=$(_fio_opts_to_min_io "$@") || return 1
+	_run_fio --name=verify --rw=randwrite --direct=1 --ioengine=libaio --bs=$bs \
 		--iodepth=16 --verify=crc32c --verify_state_save=0 "$@"
 }
 
diff --git a/common/rc b/common/rc
index bcb215d35114..e12ecd025868 100644
--- a/common/rc
+++ b/common/rc
@@ -387,6 +387,27 @@ _test_dev_is_partition() {
 	[[ -n ${TEST_DEV_PART_SYSFS} ]]
 }
 
+_min_io() {
+	local path_or_dev=$1
+        if [ -z "$path_or_dev" ]; then
+		echo "path for min_io does not exist"
+		return 1
+	fi
+
+	if [ -c "$path_or_dev" ]; then
+		if [[ "$path_or_dev" == /dev/ng* ]]; then
+			path_or_dev="${path_or_dev/ng/nvme}"
+		fi
+	fi
+
+        if [ -e "$path_or_dev" ]; then
+                stat --printf=%o "$path_or_dev"
+        else
+                echo "Error: '$path_or_dev' does not exist or is not accessible"
+                return 1
+        fi
+}
+
 # Return max open zones or max active zones of the test target device.
 # If the device has both, return smaller value.
 _test_dev_max_open_active_zones() {
-- 
2.45.2

