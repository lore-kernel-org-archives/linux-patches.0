Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF85833AD88;
	Sat, 12 Sep 2026 09:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204897; cv=none; b=OUYxWVFRh5pfKhoo8fZ8eBfQpldhKUpBFGcrUXp/FEs39wHuEfUeQajSbMGTDnGcMrkpDp8IES4ME8FFKLU6X4JsoLZZqx+BE4x0k+4QVx5OG+6hlpVdMqGJmDvZ/l9ImMeGr1ja/rp67bQo2KSo0VCe84MeC6+jWtDtALiO+UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204897; c=relaxed/simple;
	bh=VBds0XS6WSXNfdpX67iEID/6mZVipbYY2n2BaP5BL2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTD9Ih71iGV9TvISOqBiTyW1ATmJBA7gyhUGg3AxGV5SF3vyQROuDDKJONn81GuinIy+Rdm1vhza2kD1NIw+0gd2NZZ9S4SU7T8t5ytPREk8hfpver151Bzzjxy2Gc1qQHb+B5sTVofpTTRD9GwxRKzUEgdJkhvtoLeBQ2ur9Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9LJ3IjK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9LJ3IjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD651F00893;
	Sat, 12 Sep 2026 09:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204895;
	bh=qVHYs1P1mvg10N9H5k2h135RTZRl0K/B5D87w8gGjYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f9LJ3IjKSFSJAQ7B42dc6yba+9ueQduQ5DaqmW79ve0sFAKUDOujNgRz8eNtx4zDz
	 MfSu6rLaq/t2JllxDhL2NSkJcv2fXtJHZRRrB0lr3IHnNEi3KKQKGhCeKxqIPdPpqU
	 yYh6phV5HDXsL2+0Gh/E8v57oG4OuTqnMEitEhwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1708/1815] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic
Date: Sat, 12 Sep 2026 08:57:38 +0200
Message-ID: <20260912065729.074588173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2dfc313588d28..37495e95a78d9 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -132,11 +132,13 @@ config EROFS_FS_ZIP_LZMA
 	  Say N if you want to disable LZMA compression support.
 
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
@@ -144,7 +146,7 @@ config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
 	  of memory.  This caps the default; the lzma_streams module parameter
 	  still overrides it.
 
-	  If unsure, keep the default of 16.
+	  If unsure, keep the suggested default (16 or lower).
 
 config EROFS_FS_ZIP_DEFLATE
 	bool "EROFS DEFLATE compressed data support"
-- 
2.53.0



