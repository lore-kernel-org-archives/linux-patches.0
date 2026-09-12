Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392AB38F92F;
	Sat, 12 Sep 2026 19:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242994; cv=none; b=EI6PfgLejU9BgKyWaF9NUGCJ/aMzWqpweeXgl8D6NLfMDZb+0SYuwI6aHshiy4us26sCliu9ht+PliBpFpftpMnLzhIwcSgqFrCPKmS7hWa75w7bebeSwuKuHvAi/sb6ygfti6jp6kSzmbnMGbcWNuFFYulcZjYQeiYMvTJ+gKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242994; c=relaxed/simple;
	bh=BHF8C6WLXLXvGA+i/0QnI6utHwd8QdACxkjRv1TRDVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZfkyCYDe6riUeVAc7iNjQ9Al5HuobOQPBD4jD97mKPkfWzDv2sv9bBEZo3y56vH06ySKGtS/JF8PjFHevWa/M1l/+0+iO6C5GActpqMg1B+u5jlEcpXZifT/vaMFDzy1GBWq4Hy9tX+HQPyq5up9g3qHf25Hsun3lLU5A+IE7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7/WXxdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7/WXxdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F5E1F000FF;
	Sat, 12 Sep 2026 19:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242993;
	bh=yYGPxs+PuTUeDotunNDO2AXpVHN6DFicoOoFOWDRzS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7/WXxdAoxwRiXHMtqAJV23k2wcH/SARspxp6krBRzSBDECZTIYklc/2oNsKMQadA
	 kWDahSrbX/TcxjUlNkDqmH409/1A27XsqjntG9+lYB2T/umUI++O/HoFkcUVeqCn14
	 VlbmeCGiF3kghtLpZXUi18YARgESrTi98f+eIN6U=
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
Subject: [PATCH 5.10 597/798] lib/string: fix memchr_inv() for large ranges
Date: Sat, 12 Sep 2026 09:03:45 +0200
Message-ID: <20260912065530.805679016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4288e0158d47f..40420ec86806d 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -1088,7 +1088,8 @@ void *memchr_inv(const void *start, int c, size_t bytes)
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



