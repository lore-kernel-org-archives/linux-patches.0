Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F44A47CA9D;
	Thu, 20 Aug 2026 17:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247791; cv=none; b=g5oFd1I8Asht1FjU1j6r69AEGsWk2Gw/JjhaWdXxoU+YJXD3S92D+Zg+xnNitqFKiTsMaez7dTj2C6HPfJRxfFcznM+KjojWAHjwbjjQ9Pjz9c/9gqPI9Za58u2twpkBMndY0UoAhvCihPKK5DnpXtOteqg3kGc4B+RVrkinuyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247791; c=relaxed/simple;
	bh=JALqjgSp1bzJjGg3IKjal1dvLkrrKPSfMxqui5V4cN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3w2W28A70lS9bbmgxc4CzRTGNmUP8tRVaNhA0rFZFa5u1H7OYZxPBEWedzsY0CFM8KWqidZVzj89NIBQGoTvfh3jvr0/0ftFuOGjtX8tasyQWZ3SA3RlSlkjxH0hT+l43B8o4lbwMTzU+kv3V/ifExXp2U4oG/EXaTjPqL2dMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOGc6Dxh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOGc6Dxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C095E1F000E9;
	Thu, 20 Aug 2026 17:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247790;
	bh=Y8jRR3VJMGEGyGr7+qag/0mw5vAz/F7QHdT1B8lJacw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOGc6Dxh+qWVgnOk0SkzCC8V9GfL9H1BOrev/lCiXptRjMvbKm57pPy0pBupNko67
	 BaZVhax3lKvPcKEpUWRtpMI9spnPlFcN6UoAl3z8cjrJEMSDO1h5fMK65/dmCZ6EWd
	 b+EIHGSGLJbEw6F4HKLJOKsMXVwGaYkyLyjob2ok=
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
Subject: [PATCH 6.6 163/166] erofs: fix EROFS_FS_ZIP_LZMA_DEFAULT_MAX_STREAMS on some UP platforms
Date: Thu, 20 Aug 2026 16:57:02 +0200
Message-ID: <20260820145216.065867290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2f0ae58b31eb5..baabc37c71b31 100644
--- a/fs/erofs/Kconfig
+++ b/fs/erofs/Kconfig
@@ -103,7 +103,8 @@ config EROFS_FS_ZIP_LZMA
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



