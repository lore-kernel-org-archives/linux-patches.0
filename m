Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4654C38398F;
	Sat, 12 Sep 2026 16:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231385; cv=none; b=DBek+pMOIHA9uh98fRXAYoauQEkq1yBrqAUG7ECciX/ZQFKPyRINjNxJGskBHLzOJdnIHvKd+4ricwpH+rG6dc/MqU/cyvpVcO5lDvGzvkTjJ72/bbOStLULyRqm+oUhwYthkuTv6CVmnOwomr6nlrjO9ASy0CoJRYYK/QVb1vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231385; c=relaxed/simple;
	bh=7fICfpkp/nXpJxSIAIb4/FEAqZ4rOzsdaYbTXcnSVIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bf+qXQVjXlXGnIs76Ct02q3Fvkpd4Swib/ypqoq/xjpps8V7gA/cgHr1yl6WQtN8ylV+Ey9G8veeLY6r9Q2TwWRRcY0msrR02CKMG5th0xLF5m1NAZTns5waYI8JFu+eyyf5MqPAxSYHaFwRfbzOnmyIdJy8h81EqJ3XFi15IrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXqjJK8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXqjJK8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0AC1F000FF;
	Sat, 12 Sep 2026 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231384;
	bh=CorG4GgUzLxVqaYNdPZ5GRbWhExquL2mlmvjUY1T7dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PXqjJK8Ig6t1rq3q/hi89N0PA/Mw480toR29VZ+4ulIbeISMOA6hPgsSnlg9bfYpB
	 cEPDQvF+3f8+nJs5RV8grcY+9hUvEGohoUzSe9Hn2VgJS0sowg1LtVr5cWhrXtvh7M
	 +cs74OirDtbhsl6cYAZBLpM+9uhByt3NWVq6d3GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0988/1191] selftests/bpf: Limit URLS parsing logic to actual scope in vmtest
Date: Sat, 12 Sep 2026 09:01:56 +0200
Message-ID: <20260912065610.395720474@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 0c3fc330be6d85febd0f68b66c657c752e9cd63c ]

The URLS array is only valid in the download_rootfs function and does
not need to be parsed globally in advance. At the same time, the logic
of loading rootfs is refactored to prepare vmtest for supporting local
rootfs.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20240905081401.1894789-5-pulehui@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 3a59f11e0f98 ("selftests/bpf: vmtest.sh: Preserve command quoting when running in the VM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/vmtest.sh | 39 +++++++++++++--------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
index a29aa05ebb3e9..05b0026a2e42a 100755
--- a/tools/testing/selftests/bpf/vmtest.sh
+++ b/tools/testing/selftests/bpf/vmtest.sh
@@ -84,19 +84,6 @@ populate_url_map()
 	fi
 }
 
-download()
-{
-	local file="$1"
-
-	if [[ ! -v URLS[$file] ]]; then
-		echo "$file not found" >&2
-		return 1
-	fi
-
-	echo "Downloading $file..." >&2
-	curl -Lsf "${URLS[$file]}" "${@:2}"
-}
-
 newest_rootfs_version()
 {
 	{
@@ -110,16 +97,30 @@ newest_rootfs_version()
 
 download_rootfs()
 {
-	local rootfsversion="$1"
-	local dir="$2"
+	populate_url_map
+
+	local rootfsversion="$(newest_rootfs_version)"
+	local file="${ARCH}/libbpf-vmtest-rootfs-$rootfsversion.tar.zst"
+
+	if [[ ! -v URLS[$file] ]]; then
+		echo "$file not found" >&2
+		return 1
+	fi
+
+	echo "Downloading $file..." >&2
+	curl -Lsf "${URLS[$file]}" "${@:2}"
+}
+
+load_rootfs()
+{
+	local dir="$1"
 
 	if ! which zstd &> /dev/null; then
 		echo 'Could not find "zstd" on the system, please install zstd'
 		exit 1
 	fi
 
-	download "${ARCH}/libbpf-vmtest-rootfs-$rootfsversion.tar.zst" |
-		zstd -d | sudo tar -C "$dir" -x
+	download_rootfs | zstd -d | sudo tar -C "$dir" -x
 }
 
 recompile_kernel()
@@ -219,7 +220,7 @@ create_vm_image()
 	mkfs.ext4 -q "${rootfs_img}"
 
 	mount_image
-	download_rootfs "$(newest_rootfs_version)" "${mount_dir}"
+	load_rootfs "${mount_dir}"
 	unmount_image
 }
 
@@ -394,8 +395,6 @@ main()
 		make_command="${make_command} KBUILD_OUTPUT=${KBUILD_OUTPUT}"
 	fi
 
-	populate_url_map
-
 	local rootfs_img="${OUTPUT_DIR}/${ROOTFS_IMAGE}"
 	local mount_dir="${OUTPUT_DIR}/${MOUNT_DIR}"
 
-- 
2.53.0



