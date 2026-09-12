Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926A0456296;
	Sat, 12 Sep 2026 13:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219016; cv=none; b=RWi8soVGAGQJpyQ6XQ3ECVz4WXjkpdo+fEsOfi20zNVYN2fkGrU+KGkJ0BG0d2TXEAKAADv5cXwlZhssYsLKF+3GUwkrz5/T2osbo48NpA9oE2y3grl24EoQm9CfWW4sE5vAv6XRdW5HpPGIxovwV2kxuU4v29gU+luY/U38oig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219016; c=relaxed/simple;
	bh=r+781YK4nTioGZ7ObDZG9eA2hU/KeCe2+rqnD8DLqnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWkAg131lbsNEBtpWOXuoXaSC2kVpdyBlHCmadcGsxFzmFNyJWykETgnrpdyOvIwS9DBj2dJ+g57S+8DPdobY9qsaVth1CIsiD9w9iH4ModrED59KSKUpNDPgW8knUF6KiGXIRypWbRerMzo6vqBup5vI+G1fd/O9Ri3kct2lfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MN37d2Gg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MN37d2Gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DABF1F000FF;
	Sat, 12 Sep 2026 13:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219015;
	bh=F0MYlBWmdmnxRaaUcfQXzXm2avjuMnjWA9EJPwK075Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MN37d2GgaggtiHwJvpcRZ+YADToHzy3YIu/9weZCTwNzYAB7vLQh2dPRDmBO2Z1+q
	 FIC6nxL5Atsh68iW3STw0pDceDBHTV5Yen/6aHNYZTZfwuJopoNr26nPOuMh/MTcst
	 s8fE4d9svxf6dDzX9zzGxul142u4O/hZxvErDCQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1265/1376] erofs: Fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS default logic
Date: Sat, 12 Sep 2026 09:01:31 +0200
Message-ID: <20260912065635.735994765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 2d36d7b1b3449..6acdb0e02256a 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -115,11 +115,13 @@ config EROFS_FS_ZIP_LZMA
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
@@ -127,7 +129,7 @@ config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
 	  of memory.  This caps the default; the lzma_streams module parameter
 	  still overrides it.
 
-	  If unsure, keep the default of 16.
+	  If unsure, keep the suggested default (16 or lower).
 
 config EROFS_FS_ZIP_DEFLATE
 	bool "EROFS DEFLATE compressed data support"
-- 
2.53.0



