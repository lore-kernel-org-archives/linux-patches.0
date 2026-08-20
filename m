Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9217125F7B9;
	Thu, 20 Aug 2026 15:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239286; cv=none; b=nIaIx6XD/md9STawpKtrCaz99n8oczAti6VwCdBPNF4Ss0zMuA51g4ZOZMTTyVIjGa9Bn0NSxsNm8RU9aINKPCZ/oMz3g5kfahKEewNS+6sUKEomHTpCDzlEGWw317cWyLp00iBnpVbUySWVUKH9uO6dCZnZCME4B6m5wmG2l+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239286; c=relaxed/simple;
	bh=bZagh7UjxuyTcmOoPJ8/tCRLDuhvwOVv4pSqtlUETGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAWykdWbA67gdlU99bqWctAeaS1owo4CrHVS0FSdZa2aeKX0qSWf7lGK4IwaaVCX0RnxhtxENuji0NmZQiO/nuEgq5QGZZJojkpU9hR0K9cEHA4vBXVoEJVS4yygmfjcfipLQeGeLLMaNaFmSvmqLFE5gURvIepN+zE+Z2lscBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0OF+xhb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0OF+xhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FC21F000E9;
	Thu, 20 Aug 2026 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239285;
	bh=mbTA3gTBlqIolOTENEUofDKWwnGEweMehm07H2IqGm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0OF+xhba8O6aKvDOhgOhnYs+dAS44vuDgBrQ1eNGO/Rzbe4BV0cPAvEvYN7zHYR8
	 lawO7t41ZwPHEEEGwWHn2Ikg8QGZDEEUvlzmITivYhFaENhaeeM6dfN3PbpoOOVkdE
	 CdYNFQapbBFVEe9sdUa+ubFY4nmzZML8U31wYMh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Guenter Roeck <groeck7@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/217] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms
Date: Thu, 20 Aug 2026 16:56:23 +0200
Message-ID: <20260820145244.154617371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <xiang@kernel.org>

[ Upstream commit a64d500b0078e16e9abb25baca4dee1dbc9054fc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
index 0d199f6698fff..0be8a38cfb119 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -123,7 +123,8 @@ config EROFS_FS_ZIP_LZMA
 config EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS
 	int "EROFS LZMA default maximum decompression streams"
 	depends on EROFS_FS_ZIP_LZMA
-	range 1 NR_CPUS
+	range 1 NR_CPUS if SMP
+	range 1 1 if !SMP
 	default 16
 	help
 	  By default EROFS allocates one LZMA decompression stream per CPU.
-- 
2.53.0



