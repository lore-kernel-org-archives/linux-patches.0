Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6C94BEE52;
	Sat, 12 Sep 2026 16:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231897; cv=none; b=rdSXYU5bw5f5WV72RA8+EkJxqH9bEdsrK4gxvqP6hPj1/G7uFIPJgJDo6ypAcvKIqCkNYBK0qt4+ckG/lknzw0euhPDU3Pw6qiJWJTLKHI8m0X2sKwoany9/eLmkCUe4xcMZ6OV3cjaAa4YKZ1ob5dKtwqA0a7LgQGEfaZGlxfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231897; c=relaxed/simple;
	bh=ih78/jzz68gcw/pzTvQJcAYcm879ohxM8F0nymb6w+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S9jvAfGfa6tlvVCAjyql9VEWhZWtldlW/81HnEaFcNpvG8RgCEeFwzFOZWr0qYQOuqeuthL7q5fr7ddGiWjLdYEM5w/hXiKzO9iBVS37csBfdYUyc0/BfVNegUZrRRWIel88I+wZxM7bM0ZInaQEmQvlu2o7dPVVmM9+YV63T+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bAqoSPX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bAqoSPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787481F000FF;
	Sat, 12 Sep 2026 16:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231895;
	bh=krw0KhmveC6UW1w0Flm9AUsHhXKYCg+iRClCe7gdjmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bAqoSPXRc3w9EzNj6BwxsfMVrxFGttNdw8bRLQBDhEJfHMAwXXySpMQK4Znf75cE
	 HAWtMtza/0/fuB3QVfMFUxDAtFQHIIOJqcixN0VIRbrUMH68+75kdZoMqnhltrEkNW
	 705elpK/L7KprCjRPxoo+sjmEfyMXwVX6tOePagI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1091/1191] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic
Date: Sat, 12 Sep 2026 09:03:39 +0200
Message-ID: <20260912065612.668316626@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ab74edaeb1ae7c7194e79007e6afdfe788111a3f ]

When NR_CPUS is less than 16, or when SMP is disabled, the default value
of 16 is invalid.

While actual configuration picks up a sensible and valid default
(NR_CPUS or 1), "make savedefconfig" will still write a line like

    CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS=1

to the defconfig file, even if that matches the sensible default.

Avoid needlessly enlarging the defconfig files, and reduce churn for
updating them, by specifying valid defaults depending on SMP and
NR_CPUS.

While at it, make the prompt depend on SMP, as there is no point in
asking the user about the maximum number of decompression streams if
there is only one valid answer.

Fixes: c9b47e6b23114e93 ("erofs: cap LZMA stream pool size")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/Kconfig | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 01fdc78f03463..807df9b5a4902 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -100,11 +100,13 @@ config EROFS_FS_ZIP_LZMA
 	  If unsure, say N.
 
 config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
-	int "EROFS LZMA default maximum decompression streams"
+	int "EROFS LZMA default maximum decompression streams" if SMP
 	depends on EROFS_FS_ZIP_LZMA
 	range 1 NR_CPUS if SMP
 	range 1 1 if !SMP
-	default 16
+	default 16 if SMP && NR_CPUS >= 16
+	default NR_CPUS if SMP
+	default 1
 	help
 	  By default EROFS allocates one LZMA decompression stream per CPU.
 	  Each stream can hold a dictionary of up to 8 MiB taken from the
@@ -112,7 +114,7 @@ config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
 	  of memory.  This caps the default; the lzma_streams module parameter
 	  still overrides it.
 
-	  If unsure, keep the default of 16.
+	  If unsure, keep the suggested default (16 or lower).
 
 config EROFS_FS_ONDEMAND
 	bool "EROFS fscache-based on-demand read support"
-- 
2.53.0



