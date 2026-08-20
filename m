Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DB046C82A;
	Thu, 20 Aug 2026 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248572; cv=none; b=L7d5/trlBTRdMeMoS/CMheUVzB0RTz+mapE4LpVPM+W6+w5sFLMP4x/s3ZOjSBWIjfmEq0AMgxysiQQpxnEjd5JG/m+2GenCfU+uwWHqIJgmdnqNoo5gzt04+la/p5xmjurq/SA3F5O4+Wve/vOH/TWGeQMfxRQCSoaxm0uAYmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248572; c=relaxed/simple;
	bh=7K2+ymvw/skkJWgeI10J3hXItICZsjlQxG/5RUuXJbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcTQleoY7NfyRdl6ObEXXXQ3BYAbkwWw541JT5IkQefC5VBSggNgUMyrPxjBXSn62YqfgNpDu0WhFr7TEACfiBf0Qt+QyLUD1G3IqygmS5fxsfKKyG2+JgA4QApzYQQ6uIAZybr3OKtwigtpC/KFO5a1PzUcLwG+HpGLHqfLz+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJwXHleg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJwXHleg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5CF1F000E9;
	Thu, 20 Aug 2026 17:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248571;
	bh=H62Yop/p9eJX1rQN7uydPO2O+2NfSDGaIngG79GdnHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJwXHlegs1+kESwYpiiQgx1HBQdzJrYhaXX1v+dK1okwq06xoPWgZgp3Rp+4TSKg/
	 qPkFq/jgpPeFbOkikAfqR6EP8Si0OksOqQZkuZkyXQ0diidtYwGRM2Wdi5tIsA2phm
	 susNI/gAbkjaYJPhu+m/TUgzD4Vo2lqA2PDdFV1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/303] erofs: cap LZMA stream pool size
Date: Thu, 20 Aug 2026 16:56:11 +0200
Message-ID: <20260820145300.514205015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit c9b47e6b23114e939b17f818471c7a46e59006e7 ]

fs/erofs/decompressor_lzma.c sizes the module-global MicroLZMA stream
pool from num_possible_cpus() when the lzma_streams module parameter is
unset, then z_erofs_load_lzma_config() preallocates one image-supplied
dictionary per stream, accepting dictionaries up to 8 MiB.  On high-CPU
systems, a small EROFS image can pin hundreds of MiB of vmalloc-backed
decoder state until the erofs module is unloaded.

Impact: An EROFS image mounted by the system can pin up to 8 MiB of
vmalloc memory per LZMA stream, either as intended or unexpectedly.

Bound the default stream count by a new
CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS option, default 16, so the
worst-case default preallocation is 128 MiB if the number of CPUs is no
less than 16 while preserving the existing per-image dictionary limit.
An explicit lzma_streams module parameter is still honoured as-is, so
administrators who deliberately size the pool are not affected.

Fixes: 622ceaddb764 ("erofs: lzma compression support")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/Kconfig             |   14 ++++++++++++++
 fs/erofs/decompressor_lzma.c |    3 ++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -99,6 +99,20 @@ config EROFS_FS_ZIP_LZMA
 
 	  If unsure, say N.
 
+config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
+	int "EROFS LZMA default maximum decompression streams"
+	depends on EROFS_FS_ZIP_LZMA
+	range 1 NR_CPUS
+	default 16
+	help
+	  By default EROFS allocates one LZMA decompression stream per CPU.
+	  Each stream can hold a dictionary of up to 8 MiB taken from the
+	  mounted image, so on systems with many CPUs this can reserve a lot
+	  of memory.  This caps the default; the lzma_streams module parameter
+	  still overrides it.
+
+	  If unsure, keep the default of 16.
+
 config EROFS_FS_ONDEMAND
 	bool "EROFS fscache-based on-demand read support"
 	depends on CACHEFILES_ONDEMAND && (EROFS_FS=m && FSCACHE || EROFS_FS=y && FSCACHE=y)
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -53,7 +53,8 @@ int z_erofs_lzma_init(void)
 
 	/* by default, use # of possible CPUs instead */
 	if (!z_erofs_lzma_nstrms)
-		z_erofs_lzma_nstrms = num_possible_cpus();
+		z_erofs_lzma_nstrms = min_t(unsigned int, num_possible_cpus(),
+				CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS);
 
 	for (i = 0; i < z_erofs_lzma_nstrms; ++i) {
 		struct z_erofs_lzma *strm = kzalloc(sizeof(*strm), GFP_KERNEL);


