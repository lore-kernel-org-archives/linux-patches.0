Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBF9202F6D;
	Wed, 12 Feb 2025 20:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739393693; cv=none; b=aomBrtIlBgdNci0bM9+IWJBmzUSLD+876fx4qaRketFajBCFeSWItu6PJwK2f5mlgRlCciAiepJ9cRCK7XELo1mB8EgRuHn33SjQADfnR9fGJAnA0Dpms+siqP1LxEisyc9plEJ3anGKUtuvWVE/T1B4APbHoKvpUbki/HW2608=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739393693; c=relaxed/simple;
	bh=vNyrBlhAY7aE+as81EuSZYJfxhbt6hTp51+TfZTxrv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT8BS7jbYpzKw+vvhokPZpE5pay+dyyb/7CY+WQOSZg3XUlDp4v13yy7DdFZv6msoaB8SmDSELuXk/GV8yxWlRhGh9QrwOP4+GF3IYCAfGFE7Z9Ij9LaSJoOKxs6TZMqU9RAMuIjI9P+E9vih/pnng0p8J0nu+mRIL26wqtxKTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zXz1uP8V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zXz1uP8V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1U2lkyKW2xX7lkjqEgPkciQxlo7QalJXRLwfyNhCxXU=; b=zXz1uP8V7BieUD45lRe/NdsVmg
	CFW4Wq5Ph8DIrV565NHIlX7dILXk/lCDjY4/QOhglxBb7RvxsqRWuHkHyjgA/jwtbGN9h/zZS1miV
	dYl4/5z57pjod5pxzwUqSr4Gr0TP/yD9EQD2bnip0Cej6oeCcjQ8uUQSBq9uF1+Tkiol2YFVAh3Ew
	6cDrEDYYT5BTPoWTsN8PAc5C6B2Lu5rKEMA1AVyfFcK9R8K/QUspw/4zWYeVH56dkHDKVf8OWWxMO
	QCXdVW6fzUzlPrcT8RaeMtejdjBq5a+K71FGINyufpIwgmBl9FEqolNUHNwnCLUvv/D2HwWGDyHl6
	O6cmefNg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiJkw-00000008q8B-3IZz;
	Wed, 12 Feb 2025 20:54:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	hare@suse.de,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	mcgrof@kernel.org
Subject: [PATCH blktests v3 3/6] common: add and use min io for fio
Date: Wed, 12 Feb 2025 12:54:45 -0800
Message-ID: <20250212205448.2107005-4-mcgrof@kernel.org>
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

When using fio we should not issue IOs smaller than the device supports.
Today a lot of places have in place 4k, but soon we will have devices
which support bs > ps. For those devices we should check the minimum
supported IO.

However, since we also have a min optimal IO, we might as well use that
as well. By using this we can also leverage the same lookup with stat
whether or not the target file is a block device or a file.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 common/fio | 26 ++++++++++++++++++++++++--
 common/rc  | 24 ++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/common/fio b/common/fio
index b9ea087fc6c5..d147214f3d16 100644
--- a/common/fio
+++ b/common/fio
@@ -189,15 +189,37 @@ _run_fio() {
 	return $rc
 }
 
+_fio_opts_to_min_io() {
+	local arg path
+	local -i min_io=4096
+
+        for arg in "$@"; do
+		[[ "$arg" =~ ^--filename= || "$arg" =~ --directory= ]] || continue
+		path="${arg##*=}"
+		min_io=$(_min_io "$path")
+		# Keep 4K minimum IO size for historical consistency
+		((min_io < 4096)) && min_io=4096
+		break
+	done
+
+	echo "$min_io"
+}
+
 # Wrapper around _run_fio used if you need some I/O but don't really care much
 # about the details
 _run_fio_rand_io() {
-	_run_fio --bs=4k --rw=randread --norandommap --numjobs="$(nproc)" \
+	local bs
+
+	bs=$(_fio_opts_to_min_io "$@") || return 1
+	_run_fio --bs="$bs" --rw=randread --norandommap --numjobs="$(nproc)" \
 		--name=reads --direct=1 "$@"
 }
 
 _run_fio_verify_io() {
-	_run_fio --name=verify --rw=randwrite --direct=1 --ioengine=libaio --bs=4k \
+	local bs
+
+	bs=$(_fio_opts_to_min_io "$@") || return 1
+	_run_fio --name=verify --rw=randwrite --direct=1 --ioengine=libaio --bs="$bs" \
 		--iodepth=16 --verify=crc32c --verify_state_save=0 "$@"
 }
 
diff --git a/common/rc b/common/rc
index a7e899cfb419..6e7bddc844bf 100644
--- a/common/rc
+++ b/common/rc
@@ -400,6 +400,30 @@ _test_dev_is_partition() {
 	[[ -n ${TEST_DEV_PART_SYSFS} ]]
 }
 
+_min_io() {
+	local path_or_dev=$1
+	local min_io=4096
+	if [ -z "$path_or_dev" ]; then
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
+	if [ -e "$path_or_dev" ]; then
+		min_io=$(stat --printf=%o "$path_or_dev")
+		((min_io < 4096)) && min_io=4096
+		echo "$min_io"
+	else
+		echo "Error: '$path_or_dev' does not exist or is not accessible"
+		return 1
+	fi
+}
+
 # Return max open zones or max active zones of the test target device.
 # If the device has both, return smaller value.
 _test_dev_max_open_active_zones() {
-- 
2.45.2

