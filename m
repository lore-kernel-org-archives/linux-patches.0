Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E653CEED8;
	Sat, 12 Sep 2026 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224669; cv=none; b=cQwkvPeRqI6MHr6hKOmX80dp3eHTI2RziQM68LmrD+GARy/f2bR2U+63+YsspxSxpZvXsUocmJPfSChh/DybISvtjHqat3Bwn7E6dh4Vw91mnlEVDPa+b7HqLqf7O2gYUwyQSgg8ACBS+VHR+eTA4KIAzLqoBega7rnPVvM0Lzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224669; c=relaxed/simple;
	bh=7C56rjbaxCAv0OGEj+UqEj1VTTMBliN2hqcMMmiSuJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFLzxVdtzOaj6f1feBm5hqss/UynFZXJkv2OzCY7QIOd7NIG6pkxsbtmU6CrsbGImO0eGguBz5qiez9R5X45ifzXSKtKPyLa1O1VsY/nXMRzkyk/hyuRhlImMYlyasSfJ+2hLnsCvAL+CL2sTPU0a9q4Eq4pFGcTj3rpgE77fWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psBs8qk5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psBs8qk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9321F000FF;
	Sat, 12 Sep 2026 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224667;
	bh=VnUxtq7eA08J2xH9unabdphj4Ve6TjEJS0k3ykb7twc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psBs8qk5RkZoWlfwo4Ptnwzpivo4b8ZUjYTLb2Cjt3u4jCsS/Mgm6md78fwItKwBv
	 OFvf5QhhDlKiCcVW4fto3gNGF1joXEiZieUoU03fRED2ojKxQJ4le8HIt/YJCApYeW
	 3ihZVhTryUdU+EFfynVWdj1FX0TABgzdVkfb61r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Akinbou Mita <akinobu.mita@gmail.com>,
	Andy Shevchenko <andy@kernel.org>,
	Christoph Lameer <cl@linux-foundation.org>,
	Joern Engel <joern@logfs.org>,
	Kees Cook <kees@kernel.org>,
	Pekka Enberg <penberg@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1038/1424] lib/string: fix memchr_inv() for large ranges
Date: Sat, 12 Sep 2026 08:57:50 +0200
Message-ID: <20260912065630.555181722@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Bradley Morgan <include@grrlz.net>

[ Upstream commit c04cffb8c51618538f0c05c478a931eb6e1a806b ]

memchr_inv() takes a size_t length but counts 8 byte words in an unsigned
int.  At 32GiB that count wraps, so the scan can quietly miss most of the
range.

Use size_t for the word count.

Link: https://lore.kernel.org/20260621121133.16460-1-include@grrlz.net
Fixes: 798248206b59 ("lib/string.c: introduce memchr_inv()")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Cc: Akinbou Mita <akinobu.mita@gmail.com>
Cc: Andy Shevchenko <andy@kernel.org>
Cc: Christoph Lameer <cl@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/string.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index d49243af5bf21..b05d9e5283d39 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -844,7 +844,8 @@ void *memchr_inv(const void *start, int c, size_t bytes)
 {
 	u8 value = c;
 	u64 value64;
-	unsigned int words, prefix;
+	size_t words;
+	unsigned int prefix;
 
 	if (bytes <= 16)
 		return check_bytes8(start, value, bytes);
-- 
2.53.0



