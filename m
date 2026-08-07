Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9D0435EEC;
	Fri,  7 Aug 2026 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114188; cv=none; b=UT+l+fdzBA/lZtiyVJTITEclvej4SXQqCD7j44C66GTpAGXJvHB8KEMkxgh0GRU1+T8yqjzzQMj5S5bdvfgLPFvxCKriSHI9HHXf/FhnKz740IyeJDyQZzSyS/7cQtca4L8v/E9JdRUmziydtyllHJKPEXRxdfaOf8/bkAYubTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114188; c=relaxed/simple;
	bh=Vry3ypEbA0fJBGKrK7g3B4EjyLnt7eDxPaouj5l8rhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbUlOdExS5uYv9iYegXcnqtAq8kUzdiunad4tQe6kI1Jyr58JyYUBH8akvOvVzfoLG1nbRtfVuhc8/vdXz69QvUAz8g0hAtY02yh66rDcjGW691eDdlHRD8t/MVfYZ/WXlcPPNG3BGBZEVSJlVqtyP4WdJAMbf5dRIOHpIrgMfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjIwjTs7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjIwjTs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973A21F00A3A;
	Fri,  7 Aug 2026 14:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114187;
	bh=ye2Lp1dSHOVinOhXEYb/mxjzYzsAgED++5voB7j2V4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjIwjTs7NqOAFiJuy9c0E+KYl4eakbaWVHSOfRhOr8YcQFfoiKTqs+CueFQ2SplUg
	 JR8JPtp+UNgfkLQ0BpBMZCAK5iVBaINWig/5qJVenxcciQ4dNnRsXrpoYyVhjZgLf4
	 7hojcP+IiCm8NuIctR40foz0k/i6Z9kYPbVQeKYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.12 131/337] erofs: cap LZMA stream pool size
Date: Fri,  7 Aug 2026 16:35:34 +0200
Message-ID: <20260807143421.373614133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit c9b47e6b23114e939b17f818471c7a46e59006e7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/Kconfig             |   14 ++++++++++++++
 fs/erofs/decompressor_lzma.c |    3 ++-
 2 files changed, 16 insertions(+), 1 deletion(-)

--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -114,6 +114,20 @@ config EROFS_FS_ZIP_LZMA
 
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
 config EROFS_FS_ZIP_DEFLATE
 	bool "EROFS DEFLATE compressed data support"
 	depends on EROFS_FS_ZIP
--- a/fs/erofs/decompressor_lzma.c
+++ b/fs/erofs/decompressor_lzma.c
@@ -51,7 +51,8 @@ static int __init z_erofs_lzma_init(void
 
 	/* by default, use # of possible CPUs instead */
 	if (!z_erofs_lzma_nstrms)
-		z_erofs_lzma_nstrms = num_possible_cpus();
+		z_erofs_lzma_nstrms = min_t(unsigned int, num_possible_cpus(),
+				CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS);
 
 	for (i = 0; i < z_erofs_lzma_nstrms; ++i) {
 		struct z_erofs_lzma *strm = kzalloc(sizeof(*strm), GFP_KERNEL);


