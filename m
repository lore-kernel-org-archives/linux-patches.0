Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B948C1F3FF8;
	Mon, 23 Jun 2025 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713233; cv=none; b=cuI24BpWXpRL8fn1lfTjPe2gis3xg9KBVsSoXLGJWaDbPKBjKtblFhvef5QxSVlDZ+Wg+BRSnf30BZ8/lc7wR32OvUHddyYGYGgXpTFmf3N8qp5DE5Js0AP4qoDuWsS2C4ruzVVF+T0Zej8sj9UcbQAAp1liYqwgbuPe+txZNKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713233; c=relaxed/simple;
	bh=jD/BZnshbKKW59HAFsm5CFKSrJ+0MBUy6LCVyjPuyAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDksjM7sCioFjwhhwRmHFhZmdaWbmcaWdjc/7BHa+u6TM/8tKlxcEzuL6LVPXK5FPPgPWuJi9OdQZvuaj3wDTtNSPmlFgOaZRNzjWfbWRW9HrZDOmwZijbRxg6TGtBmNNGTLvcjFO/Uj6RzwPwNGaZqvZvbrGQ87BXQCmd+7j/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xyp9OsuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xyp9OsuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539FDC4CEEA;
	Mon, 23 Jun 2025 21:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713233;
	bh=jD/BZnshbKKW59HAFsm5CFKSrJ+0MBUy6LCVyjPuyAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xyp9OsuQZntHdChXEDZuKK1YXmloTuXcz3qgg0kQhzGuvH9ZKGIILB1uDu8aprdUD
	 ZZQgUkO0E50zPzc1Rd8PONEannaOaoI1bOAojHih3ylOnVwcD3LqT0WU60ui2Nocj+
	 OJ6STiPS5xawDeo7vOHUwIZ72fs20ThHYTF9UhbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dennis Marttinen <twelho@welho.tech>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 055/290] ceph: set superblock s_magic for IMA fsmagic matching
Date: Mon, 23 Jun 2025 15:05:16 +0200
Message-ID: <20250623130628.662426789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1220,6 +1220,7 @@ static int ceph_set_super(struct super_b
 	s->s_time_min = 0;
 	s->s_time_max = U32_MAX;
 	s->s_flags |= SB_NODIRATIME | SB_NOATIME;
+	s->s_magic = CEPH_SUPER_MAGIC;
 
 	ceph_fscrypt_set_ops(s);
 


