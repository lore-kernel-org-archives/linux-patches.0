Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAA63C1986;
	Wed, 30 Sep 2026 19:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795072; cv=none; b=iouBgeN6OrRZLXv6sS98CCVa1IB1sFqCUk4VljSqpKKegbZy4uPtxbtKcZovyse83eiXr1VNWZNSvJxzAR4zj5tLZqKyzZmlH0nj6/BYlPS24YW3gBh4NwKmb+5fRiXTDBRtC9uzfET3kTq8tFIqyNKNffGjYeK4CO3uV0mMPTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795072; c=relaxed/simple;
	bh=wZcM03LOCCxFHkDh1yqpqWGUy+A1MhKu9uu8QiJsAiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URAf5haXrt2bjSq8cHHySdDWyZdoRtzrHvcF3OoIAxtkG4Q9NkVmf3Op8/BQULyJz2DfbNRDzS+fczX53MA5NOCipEflQcgbZlTO8bdBQVzsDzZNugFPbRAGL8MBtJ1VCZ1xJMSASmAU/2qdXJD+dQbKsEFPnNu92eeYqyGMtvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zz+/Swvt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zz+/Swvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77921F00898;
	Wed, 30 Sep 2026 19:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795071;
	bh=e8KyPURpzVqT7T2uiLbUVcbEEpGCSmVz1ZATIMh0OLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zz+/Swvt8CGe5cQuObrjA802U2XGXsI7iwJ59j423L9R14issrDyUXOmwxsZkqZi2
	 4FId3wrZ+RXmPGfMaalkF6LRipN5OYtTgF3ExaRMCmpbqIUu+znzWmrqN3Au2xm6xk
	 RcZHL0WZCTONmcUE1Vy/jlbChrSJCCsc4mzIUxYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0434/1193] s390/boot: Fix physical memory search range
Date: Wed, 30 Sep 2026 17:18:38 +0200
Message-ID: <20260930152443.833418666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 0cf79826eef99..8b78d30212867 100644
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



