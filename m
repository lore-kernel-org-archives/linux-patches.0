Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC58747F774;
	Thu, 20 Aug 2026 17:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247290; cv=none; b=RBxtmDi0XKGTezuhqYFcfmfNVyVaFJGl7PRF2GSFyYDHgMCKEJDuIXRyLmGiPnfoy3Xqz9ofShDtlg6yPUBa7/CwDq6lbsOa4GDd6LIHYZ9leUA/WrfVFstN07Q/Apt+wpnD9HesTlZVteWTrAoOTKWDMqGp21kAIs7NaT6bsv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247290; c=relaxed/simple;
	bh=faoPOJKH8+6IoG0K/7K1xY7iMe03wmQ3uQ0mNxTzd5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDz9t1vqY9yE+EG8IxJf5sm/MDk1PrR1hSH56g4Jbh+CwzzqaK67MZAAWicrof6GYdITlJeBIrVkiwJrpBhfFx4ub4+X4RRR5iAQp3Y+639O6cNHmmlaRnjXMfue9gSLMKCIyzLOPz+V0Nom40FOFalt+scPrZ2dg+zJ5IVwwt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K4+K/1Xq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K4+K/1Xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8A61F00A3D;
	Thu, 20 Aug 2026 17:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247289;
	bh=zOpC7yAbQ5Vk15FvDsOtODpCHGIyuOyYvW95JmGTW4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4+K/1XqV2i/MmIgDLkCicBk0rcW7GbvA5WM7/XEUfhiWaQHR7TrqUSdFUsaJ8uw+
	 ISCeAUCdD7AZrYf4vX/CB/7ErRPKQIQngSWUyQQIrwxP+cAvOqa49sLBQw8twiSwyP
	 z88VLY4bI9O/z1ESkLWhHQj2OyBgieZHNx/gT6rs=
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
Subject: [PATCH 6.12 214/220] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms
Date: Thu, 20 Aug 2026 16:56:44 +0200
Message-ID: <20260820145229.965654753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
index d7e004f8cfedb..2d36d7b1b3449 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -117,7 +117,8 @@ config EROFS_FS_ZIP_LZMA
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



