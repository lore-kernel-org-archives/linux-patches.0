Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8504DDB40;
	Thu, 17 Sep 2026 15:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659142; cv=none; b=Vj9rGe0MLARwMB05tXg7dVCQofcKdYIbZu+6tLDZstYHtPwKDVnsjL8YDXUklALuWUDJl4NUoGVeSyyZJHxh8QejIpbDo2ohZMrwi1kJUVv0pmoINA5Pa1Q2GX+08YxCcuQIsG9yIFtkv2Wno8o27dP12wzhPazpxKbPnZL3K2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659142; c=relaxed/simple;
	bh=U6rqPO910R0mLRYTEPvldJdIvpNNXFRtFfCaVR5DzJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPX549e+PPuRVqkmqeSbTDGqn208dT6YFFjTSoGJXihEl8aqzZe+zd1Dy76jIZhmEyb7wsJxXzqmUIEApLmr/uLz9UC/IiurUJ1byBdpT1y+KmvNs5VJcsA6iqqJzD4TgF8L85EzDQ+CbxE/GJ/P/rF/vOk9UMuQtm04oUh2Yvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNPOwB7h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNPOwB7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9519E1F00893;
	Thu, 17 Sep 2026 15:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659132;
	bh=a5E+4ki1cf2ig/UfBvovkg+g+1uKE6DaaU8iu7ro6q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNPOwB7hXTcd6mforKEDlLVxv3PiHDrX7qbi4Z+/qY0wYAWqaAeTr5K+2KgV/r7S1
	 kXuYtXLKTqNX+amqj71CTi83ivd0OFcZ8LPOBeESt3Na6BL3Z+OI4fSg0Ym2+zwHUp
	 D9QaXWNO7M5SyomE3lhNeJPdPS5fWktcND3/cgKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 153/733] s390/boot: Fix physical memory search range
Date: Thu, 17 Sep 2026 16:07:41 +0100
Message-ID: <20260917151354.872973095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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



