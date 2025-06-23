Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A4413B58B;
	Mon, 23 Jun 2025 13:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684537; cv=none; b=lCBYdwkE+dlmgYc6EcSE8cL/qQpnEU6E0+s9yVIIGIETrL8MsbXUptUS4TPdD5zY55QPIrnRAbt6XVS2nkWQi5TLORVDH5LAFq89CJC0i1am2952s7g3daWMz7Ylq+TdG8FjQKmSSq5VXsCJ591S55m99Llr1/SKt9gvjqNxlks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684537; c=relaxed/simple;
	bh=7TrB+bBJzQvIfraFthDc595Z66NLLDDksHe5nxW6Kbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q62iBMwJ8luKgdXyFfMXM6hmMAPLBZJKYgL/9T7L16QtNTI4HHQLIQlVDRu4KzhsnsCviynw2x1tzMrh+RpHA8vcIbGnDAzmuf+bLF/4MwkyQFJqN4kcCV5vO3hnv1hXaZmNFjrJll6+pP7ZkXTZ4WDSDnaJ+EAepWW5BsOvlE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPUnMP2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPUnMP2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268A0C4CEEA;
	Mon, 23 Jun 2025 13:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684537;
	bh=7TrB+bBJzQvIfraFthDc595Z66NLLDDksHe5nxW6Kbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPUnMP2AsrLOP1JSpXRIxn4pIU2mQr1Kx2UsGzZo3Ad8PKXk4JqPx0EbVzwkt7sV9
	 wd/IC0rlnFrQi+jhW84DNorA2RSHnVuVbvjgvfFE052CE0TMOZo3Q31Cb1Pzi4ARdj
	 WzPWb8gcK+ivv4ETF5UT0wmIbD/KVYo8c4KFhOuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Marttinen <twelho@welho.tech>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.15 104/592] ceph: set superblock s_magic for IMA fsmagic matching
Date: Mon, 23 Jun 2025 15:01:02 +0200
Message-ID: <20250623130702.750180145@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dennis Marttinen <twelho@welho.tech>

commit 72386d5245b249f5a0a8fabb881df7ad947b8ea4 upstream.

The CephFS kernel driver forgets to set the filesystem magic signature in
its superblock. As a result, IMA policy rules based on fsmagic matching do
not apply as intended. This causes a major performance regression in Talos
Linux [1] when mounting CephFS volumes, such as when deploying Rook Ceph
[2]. Talos Linux ships a hardened kernel with the following IMA policy
(irrelevant lines omitted):

[...]
dont_measure fsmagic=0xc36400 # CEPH_SUPER_MAGIC
[...]
measure func=FILE_CHECK mask=^MAY_READ euid=0
measure func=FILE_CHECK mask=^MAY_READ uid=0
[...]

Currently, IMA compares 0xc36400 == 0x0 for CephFS files, resulting in all
files opened with O_RDONLY or O_RDWR getting measured with SHA512 on every
open(2):

10 69990c87e8af323d47e2d6ae4... ima-ng sha512:<hash> /data/cephfs/test-file

Since O_WRONLY is rare, this results in an order of magnitude lower
performance than expected for practically all file operations. Properly
setting CEPH_SUPER_MAGIC in the CephFS superblock resolves the regression.

Tests performed on a 3x replicated Ceph v19.3.0 cluster across three
i5-7200U nodes each equipped with one Micron 7400 MAX M.2 disk (BlueStore)
and Gigabit ethernet, on Talos Linux v1.10.2:

FS-Mark 3.3
Test: 500 Files, Empty
Files/s > Higher Is Better
6.12.27-talos . 16.6  |====
+twelho patch . 208.4 |====================================================

FS-Mark 3.3
Test: 500 Files, 1KB Size
Files/s > Higher Is Better
6.12.27-talos . 15.6  |=======
+twelho patch . 118.6 |====================================================

FS-Mark 3.3
Test: 500 Files, 32 Sub Dirs, 1MB Size
Files/s > Higher Is Better
6.12.27-talos . 12.7 |===============
+twelho patch . 44.7 |=====================================================

IO500 [3] 2fcd6d6 results (benchmarks within variance omitted):

| IO500 benchmark   | 6.12.27-talos  | +twelho patch  | Speedup   |
|-------------------|----------------|----------------|-----------|
| mdtest-easy-write | 0.018524 kIOPS | 1.135027 kIOPS | 6027.33 % |
| mdtest-hard-write | 0.018498 kIOPS | 0.973312 kIOPS | 5161.71 % |
| ior-easy-read     | 0.064727 GiB/s | 0.155324 GiB/s | 139.97 %  |
| mdtest-hard-read  | 0.018246 kIOPS | 0.780800 kIOPS | 4179.29 % |

This applies outside of synthetic benchmarks as well, for example, the time
to rsync a 55 MiB directory with ~12k of mostly small files drops from an
unusable 10m5s to a reasonable 26s (23x the throughput).

[1]: https://www.talos.dev/
[2]: https://www.talos.dev/v1.10/kubernetes-guides/configuration/ceph-with-rook/
[3]: https://github.com/IO500/io500

Cc: stable@vger.kernel.org
Signed-off-by: Dennis Marttinen <twelho@welho.tech>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -1227,6 +1227,7 @@ static int ceph_set_super(struct super_b
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 	s->s_flags |= SB_NODIRATIME | SB_NOATIME;
+	s->s_magic = CEPH_SUPER_MAGIC;
 
 	ceph_fscrypt_set_ops(s);
 


