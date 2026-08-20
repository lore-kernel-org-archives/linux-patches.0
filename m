Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B393C07A;
	Thu, 20 Aug 2026 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238689; cv=none; b=Z8FMcvA4N+hTSoihyvI3gmUJQ4TvH1cyu9cwUDZ4A+X5+S4btXBb/ameyLxrwauJMlNxQtdYNqcj+07dW958Qxk/HmokK0P7QnWNJZQqO7J33MPpxCqXDj3f9KM/JRJ55CLVqQjGyVhhxz1p3KvFqed5ZgY1ntipdepfU3+xTAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238689; c=relaxed/simple;
	bh=qHr7D5H4JvR2fBkUyf4nMZ5Xe07j9tC+dgerDzJ3Pd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYLY3wwhm2O89THvC8kH8EKSh8Cwwi0G3JFhv8m9By0mbKd12Pj3dCD/YXG9W944KvMCRa8Rxg31dyGhsgiIgFDlhlLX46T49YsW49k2RdTPRaL/33hSOwCmiTbgK21Hut+b6QOEvf3zdP3nDF2OhFj/+Y1cD7QI48fIBn3HRc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZGhg0wG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZGhg0wG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FF61F00A3F;
	Thu, 20 Aug 2026 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238688;
	bh=AmDP2by3JlsfAubkXc7J8AUHvgXXZJIUlU+mF0a7uuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZGhg0wGD3yon7+raOi3ycYRABjtKQFlfB3u2r6hMMoyI4G8sA4SguVkhhiM5v1KZ
	 Ju8cr6wdcNhHAWkBIpHOAoOkXiuMWgKiQ0KJXzeZG2HlnRrw4kJHXynBlkYoWMwOeZ
	 O4+9ZtQRjlKfzLek7VAlt3B1eGBjWMnvIifRyZAY=
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
Subject: [PATCH 7.1 228/228] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms
Date: Thu, 20 Aug 2026 16:56:10 +0200
Message-ID: <20260820145252.025688386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8ca1767dafb61..2dfc313588d28 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -134,7 +134,8 @@ config EROFS_FS_ZIP_LZMA
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



