Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82E4481245;
	Thu, 20 Aug 2026 17:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248641; cv=none; b=amNJTgl4Z+/xcnS6OeYMUEmw4aBanhmHXYPuA4xevGOkVQJOHQM40xdrmNAk0Sj6lXAQKb7fITDVGu/UkUTAI4nYI01+rVykcZMnUGBvbYQVQzbNl4S2AJmlaxK5D6Xn2YHMYsrZkPZs0i2o2ZBYOF+gjcNbETKDFQlJA7Tz01k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248641; c=relaxed/simple;
	bh=nwdxPU7ex45OAawCO7pw0F2UHjxcsJP7IrJIG/sSzpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJYFlP1wQQmjwxM0+iVM3A72rPBJaYFeCuguA7UUzaJftSQoygm0VX2u7hMMGFhAj/hd8aOiDViyrwJCeLuxwwLbftq9QaYskopIPHbTqCMEffqB0ORF/33L8nxu97Q6bn1c4vMOYuUOfL02BaztcgeHdovlKtrBPWvRPeUWSIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Di+oR+nI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Di+oR+nI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5931F000E9;
	Thu, 20 Aug 2026 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248639;
	bh=QHtl8DmN8qUOzGnQrpR66uAoAHgTBEr5PoGEA/bOLkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Di+oR+nID4LH1uWaGuYGVscJRyl/Tfod2pl4y36nC+bEkkG4hcGSWcnSnW0b+nJMb
	 1RneZKJzUx7oayVSXiO+BvflMkNPrc0r7l31pFh1Nsj7+7qRmyG3uGIH6UcGVJUx5g
	 L8p0JP69roQC+Spa0IhQkND+Q6aAKniD60vs2zzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Guenter Roeck <groeck7@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.1 298/303] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms
Date: Thu, 20 Aug 2026 16:57:14 +0200
Message-ID: <20260820145302.427993220@linuxfoundation.org>
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

From: Gao Xiang <xiang@kernel.org>

commit a64d500b0078e16e9abb25baca4dee1dbc9054fc upstream.

CONFIG_NR_CPUS doesn't define on some UP platforms (e.g.  arm), so this
can cause make oldconfig to loop indefinitely when CONFIG_SMP=n:

  $ make ARCH=arm allmodconfig
  $ sed -i "/CONFIG_SMP=y/d" .config
  $ sed -i "/CONFIG_EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS.*/d" .config

  EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
  EROFS LZMA default maximum decompression streams (EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS) [0] (NEW)
  ...

Let's guard NR_CPUS with SMP instead of using a hardcoded arbitrary CPU
uplimit here, similar to commit a3344078101c ("mm: make SPLIT_PTE_PTLOCKS
depend on SMP").

The initial report from SJ Park was for m68k [1] (m68k is the only arch
without NR_CPUS in Kconfig), and that got fixed in commit 1fd495ef09ee
("m68k: Define NR_CPUS to 1")

Reported-by: SJ Park <sj@kernel.org>
Link: https://lore.kernel.org/all/anuyFHLUGDjZWY4K@XiangdeMacBook-Pro.local/T/#u [1]
Closes: https://lore.kernel.org/r/20260728065447.91511-1-sj@kernel.org
Reported-by: Guenter Roeck <groeck7@gmail.com>
Closes: https://lore.kernel.org/r/87853c96-cc8f-49e6-81b1-02bfe409e372@roeck-us.net
Fixes: c9b47e6b2311 ("erofs: cap LZMA stream pool size")
Signed-off-by: Gao Xiang <xiang@kernel.org>
Tested-by: SJ Park <sj@kernel.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -102,7 +102,8 @@ config EROFS_FS_ZIP_LZMA
 config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
 	int "EROFS LZMA default maximum decompression streams"
 	depends on EROFS_FS_ZIP_LZMA
-	range 1 NR_CPUS
+	range 1 NR_CPUS if SMP
+	range 1 1 if !SMP
 	default 16
 	help
 	  By default EROFS allocates one LZMA decompression stream per CPU.


