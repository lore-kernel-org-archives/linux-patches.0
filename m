Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE6A4F3ECD;
	Thu, 17 Sep 2026 17:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665516; cv=none; b=QmGu/uzi0E3V13a8ltNWhkBdxxnF3ZcfiesakK8h8Ig+IOfEulMB66rv7N613PeDRJeEPRWbSFrAwnigSkvF12jSsBTYSNugS4HA6uP5fF+0vd4uOQ85wv8HkqvKLs77EkzvWwYJDnKQShkNfQEHHwFApgXyA1O8WACTpCFQsDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665516; c=relaxed/simple;
	bh=SoxfVfbIFiZJLTUjiNSGuHfRWzXeMLIAvGW9HdWIpIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2OIgC+dezXj0JsHg9mh3uJAw5PbuDXXgc5DrjcfKRVbstMoG7ZGzuRL8EWkcx5yRXlzpFEy+cfxuMzO2wbrlpESfuNxEidhxL6LDH8c2vlfGiVGmnwSToDpKJEL1x3BGqerDcKuQjfGTnb6uRXXj4sQfhX/+/BWBpNOJ9/NJo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2N0A9Ac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2N0A9Ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862E81F000FF;
	Thu, 17 Sep 2026 17:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665515;
	bh=v+9pn9WORkpHU+MiEKLflfOdg3BevlwYJZ7GzAjiVbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2N0A9Ac9KQY0oiDuegTjxjbI2WUEfjCKMI7jYf1oj1GXF7i231yM7IY8xkSq2EZH
	 BE3kEEYW6OmpTVkTq3WZYL/OSrCLSiW+6HHpTm9P/gJHk+8X10LgKoARWG7pVTWfMP
	 ISsYEK6t3jT8CDJvjs32+hSFuoe9y4p0eNOWrJNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0693/1250] s390/boot: Fix physical memory search range
Date: Thu, 17 Sep 2026 16:08:08 +0100
Message-ID: <20260917151610.674226412@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 1f2ca5435838e..0ebb2174713f2 100644
--- a/arch/s390/boot/physmem_info.c
+++ b/arch/s390/boot/physmem_info.c
@@ -141,7 +141,7 @@ static int tprot(unsigned long addr)
 
 static unsigned long search_mem_end(void)
 {
-	unsigned long range = 1 << (MAX_PHYSMEM_BITS - 20); /* in 1MB blocks */
+	unsigned long range = 1UL << (MAX_PHYSMEM_BITS - 20); /* in 1MB blocks */
 	unsigned long offset = 0;
 	unsigned long pivot;
 
-- 
2.53.0



