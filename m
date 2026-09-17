Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362FB340283;
	Thu, 17 Sep 2026 18:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668929; cv=none; b=YUw5Qgena4R348mBz9cnnEdOVFT17R56EdNLcUR/ecvv8fC8ZxAUq+q2pWLPV6A/5jVx1wrILQiFsRf9O0YhkwDqyy5y+inh0ZzQK2nOqTioG/uCAVo0GMf8bMWS3U8T3tl7/uUIjrJHxFOaLMdG+Mima42liPx3EvvKkVJK+y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668929; c=relaxed/simple;
	bh=3AKcIimvZhpYhJXymyIKNPO7pk56HngRFAYGHpyzINM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Az99gjLc/lV7H+NwQB6PtZnCyUrNR9VwQKqRlvGqX8gqqwCj3kIJNxmTRnIANKLuOxLkQnbvwUpn48OSEkdF3kNffqXTCivr797xPWO8To6s2QHQbDSEp8NYy8uOIsftfBeAi9ich/iCElKp4a9Qztuw56N3J7MigWFi8UMRHJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOwctsF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOwctsF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9F01F000FF;
	Thu, 17 Sep 2026 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668928;
	bh=kpd3rp7Q52q7HcvoNqrhF0QyZuUJORNs2KNaKx4xFug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOwctsF4ZOXfuvzUkvm/to5DvOP6vxk2q2wJ3FB9GAVdn8NapJTRgULMQirMZ00ji
	 Id2RwlP4mdsA/qQIQjVas8kifML55eSXqE5Y4VR1cEvf7JbZTZWSCsOhgt544d3+Xx
	 mv0v0Qz1YB5lIhpLZ4K3no/B/tkgU3ItK7X0sDAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0586/1102] s390/boot: Fix physical memory search range
Date: Thu, 17 Sep 2026 16:08:49 +0100
Message-ID: <20260917151554.668518781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit a0c798ed4103316c23938bdf625af364fbd38016 ]

search_mem_end() calculates the number of 1MB blocks with a signed int
literal. CONFIG_MAX_PHYSMEM_BITS values of 51 and above either overflow
the signed int or shift beyond its width. This produces an invalid search
range when the binary-search memory detection fallback is used.

Use an unsigned long literal so the full supported physical address range
is represented.

Fixes: 54c57795e848 ("s390/mem_detect: replace tprot loop with binary search")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/physmem_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/physmem_info.c b/arch/s390/boot/physmem_info.c
index 1d131a81cb8be..f5d00f8cf5d65 100644
--- a/arch/s390/boot/physmem_info.c
+++ b/arch/s390/boot/physmem_info.c
@@ -140,7 +140,7 @@ static int tprot(unsigned long addr)
 
 static unsigned long search_mem_end(void)
 {
-	unsigned long range = 1 << (MAX_PHYSMEM_BITS - 20); /* in 1MB blocks */
+	unsigned long range = 1UL << (MAX_PHYSMEM_BITS - 20); /* in 1MB blocks */
 	unsigned long offset = 0;
 	unsigned long pivot;
 
-- 
2.53.0



