Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039921;
	b=mt9sY0TnoMxFDzodcBhLBN92orzyVyJyxQbBkyPuNo1v6wBGoWRGrAjn8a+8pE/ZeyTv
	 XEcWwwyIdFdKvpbuJyE+X9sgo/Gu+UhMGv2jPXFvruDBctghHmA7A+dExrTvgKnUUZzn3
	 qnXNYvPv5AUUdsyrUu4EQfmWFC4T5zMaJ+/xMLNFPFVrmqw4B8ukgs7X0u0/hYKI7XFy9
	 WHHN5teIqmaKFc/pTHrkVGWsrmz/Zg9awd52/fV+a1FeT2cP2uNNSq2lfBSbtIMer92Nx
	 W1J656ul41J4o1H57YvPrCW3NMHqI5tSMcYsFVgM1+oBqfnCTWIw4N8G1/DpyrEpBSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Db+NJFd+MKIBzxT2SFHLrOAFXDbfVOYFLJc/u2d1Twc=;
	b=CtwQpQIssVZ5wtA6wptabH+6BlrJD4806HZjwfPEOboZLeEkR6S4RGat5K6/83Cp7PCR
	 kLeoIMS9Xv2DYLmO063iI+3262Hqx7EU4M7z15WyewHgvo85DmRNVa9GfP0btN7lGMIrk
	 pFpN3pWvT6ewOJ+4NquujchW6Elr2hLJm/vVm+yOXMv9Elnpujr3QYQ7pCoKmNOkCZfYU
	 wWTYeA5p6YpLiw31Rg8Kzym2XSUb3PshTBK3eiE/9KLq9GBWIfeMhSEz/U164ProWGUvt
	 st3M3k4JGzhg0Q0utGznGm5lx/Mrq1xwvO2VgPYGZ3OXdHx9Yc9+7BGwLtGS5UG+FAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHmsUhUo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A3606A320;
	Wed, 18 Nov 2026 22:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JHmsUhUo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD8F1F000C4;
	Wed, 18 Nov 2026 22:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039921;
	bh=Db+NJFd+MKIBzxT2SFHLrOAFXDbfVOYFLJc/u2d1Twc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHmsUhUo5u0grd/eLNQMszO9zHe9IDelL+VeJdz/qdVAhh5HgZ71ejpIB1zUpoDne
	 YZQpSKAc/qEKOZhsJW451gUzLfbiJNnycRxr6WS5EVk0M46fHJxtcb/JNW5eqUzf5j
	 lzy4X0vnTX7jne/UjifSiNyfs6xtNRloDdOMtYlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2231/3318] mm/gup_test: safely calculate GUP batch size
Date: Wed, 18 Nov 2026 15:47:33 +0100
Message-ID: <20261118150428.804829584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarthak Sharma <sarthak.sharma@arm.com>

[ Upstream commit 44817a536aaa5bfac0d316242e93e489d0a69d5f ]

__gup_test_ioctl() calculates the end of a GUP batch using:

next = addr + nr * PAGE_SIZE;

If nr is too large, it can cause next to overflow and wrap around.
If it wraps, the next > end check is bypassed and a large value
of nr is passed to the GUP call, even though the pages array was
allocated according to gup->size. This can lead to out of bounds writes.

Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
contains zero pages. The code still calls GUP functions with pages + i,
which can point past the allocated array.

Calculate nr by taking the minimum of the number of pages per call and
the pages remaining in the address range. Reject zero sized and non
page aligned gup->size values and zero nr_pages_per_call value.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
Link: https://patch.msgid.link/20260915102524.125758-1-sarthak.sharma@arm.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup_test.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index c9e7c1cf5b080..6de8064090ea1 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -109,7 +109,8 @@ static int __gup_test_ioctl(unsigned int cmd,
 	bool needs_mmap_lock =
 		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
 
-	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
+	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX || !gup->size ||
+	    !gup->nr_pages_per_call || !PAGE_ALIGNED(gup->size))
 		return -EINVAL;
 	if (check_add_overflow((unsigned long)gup->addr,
 			       (unsigned long)gup->size, &end))
@@ -132,11 +133,9 @@ static int __gup_test_ioctl(unsigned int cmd,
 		if (nr != gup->nr_pages_per_call)
 			break;
 
+		nr = min_t(unsigned long, nr, (end - addr) / PAGE_SIZE);
+
 		next = addr + nr * PAGE_SIZE;
-		if (next > end) {
-			next = end;
-			nr = (next - addr) / PAGE_SIZE;
-		}
 
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:
-- 
2.53.0



