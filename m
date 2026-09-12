Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38F81F1534;
	Sat, 12 Sep 2026 08:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201650; cv=none; b=WKBhbNFkHgnLNeF3EnRaezoEdTSV+O38SqnraP7NjDiL3/nPIymjATqZY6/NgwKA8cIEcLZqCz1sX4uyvptlLl4FTT3tzs3BjxEKEYcAJg5q0kKU8N6VG9m43qtEKN+QPuySg4ap3WrN3Rmyy4YXGh6ejF2Px26ulLxkhSpwoA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201650; c=relaxed/simple;
	bh=VmXB4r1NftrCIFxpUM47oJPfMYijmCvejoAR4jNxQxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvfFGAyR8B4HlXi2uV0MgsrW/AEuEschi8i4ulfHXwwvDMtp9kio0qtu5hDu/cYpjGEe5ecBBpdUeGnuTnedeXnbA9uwKF7SpYsXzuUSZOBbP8+Q3itLpq9swh5y0s8LvCEnEa+86MgdLTtZ4IbK44wJbppM5Dh1q3KcjXBnZ6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IE/YKgs1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IE/YKgs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2DE1F000FF;
	Sat, 12 Sep 2026 08:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201648;
	bh=AWWKyt4wNhDyPe4xFLL14YaGn4hyROi2bKBiLwiQHqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IE/YKgs1ffGNzx9rVTsTt31F7C5Dv5ZnYvybBjQ5jWXKqYnjpIpw+/Wb7/bD9/YMz
	 s03DlxIkQknKIeOCzoW3pPmFzmf502XUUm5uJpDFeSDjNbemyYkqMfNIgvTU6VkU9p
	 ZUZZiVKxJeLuQN4BevGqagDTG5+54IcMgg5dYj9o=
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
Subject: [PATCH 7.2 1038/1815] lib/string: fix memchr_inv() for large ranges
Date: Sat, 12 Sep 2026 08:46:28 +0200
Message-ID: <20260912065713.387831699@linuxfoundation.org>
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
index a4e8ad23577d8..a3778d5aab4af 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -821,7 +821,8 @@ void *memchr_inv(const void *start, int c, size_t bytes)
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



