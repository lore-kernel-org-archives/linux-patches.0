Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988211C5799;
	Sat, 12 Sep 2026 18:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239555; cv=none; b=LUoqNbhqF1M/uOvRnyIiIyXnjfjLdY0MKx3zvpny3e5E3yP08TT2SQ60VjN2gRnjFLh7z5gQiYRd2z3G938H05+ScmpGtw1Dep/DOWkvaQ9lLqbzmagAU+YFy04tpQmMMN++bFH9BTtvw8Hs/QSyWb3XqEYmPvqtOm1Zhh7cFCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239555; c=relaxed/simple;
	bh=uXeCbMVqizBeEOcWDxZZS1EyXGTpS4Z/75K90vZxPrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QewHTIuAWxbk0EE394CWFM/5GsDFesQpUf3fkYx1WAYn50COyedVNU9nFOZJEMDysB1pe/B7qd5I+DdN1aGAzKty1uWDaBFccM66mimYLC5A/AYPpmGB6WgpPTmKOjW1hslHybd+DRg9jKvT8Zrx/1gcj/WZsxyHJXQRYro2iaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/G/daN5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/G/daN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2811F000FF;
	Sat, 12 Sep 2026 18:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239554;
	bh=dksqI+UhU9h70u63Xnd0nQDeh90BfsESbj0DlKyp9fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/G/daN5eTG77eHpnsE6utl3qSKrPFz0UL12mIvDysqTr26E+fMfEiQeq7yW48/Vg
	 FQjzvXuFX4K0bAidVICRW5qN7ulGWctSc/17IiGOPKfy38j8cFIzO/zRsDSYa81yQW
	 DdKHqlOQmEQTrKOqBxK8NQhUTWFhgA4nScum5Kn4=
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
Subject: [PATCH 5.15 689/935] lib/string: fix memchr_inv() for large ranges
Date: Sat, 12 Sep 2026 09:01:59 +0200
Message-ID: <20260912065542.644862694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7c0c69bb5b689..087962972f950 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -1115,7 +1115,8 @@ void *memchr_inv(const void *start, int c, size_t bytes)
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



