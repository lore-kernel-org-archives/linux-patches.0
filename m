Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E7C78B61;
	Tue, 27 Feb 2024 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043199; cv=none; b=AggBA4Gc4p8ThGm+SwQeQj8txTMogcMPf3OEGzUUd/7hw0RllsePJD2hyBo+m2CT8SeLqoBNXPQTp5c3qb1X0ayKVql9D8/Sx+J3DvzYIYd5fN9k2tmpPvH2UK8a1HnttjbgIwNoyV1k/7w1QFyoJ5sUVxqFtMnITVlI7OTMwE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043199; c=relaxed/simple;
	bh=pseK6M990om+kS/rrVy5sG2hIWicWvX3yMHbzAxldUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7P5L8n0vxY0+LcxyFPxpI7xaKJTXLCwiCwHsZrrG62kgqy8wluDJlJLtPGsHw4d3Myxe6318xMI4rfyYYNLk24oznZW6vUMRpDvmHfhZ+CrdK06YZq7pNJlBqru8koDWJsqRHbrMHBOb1CZmDqI+k5anvkuv9TihgtnZk7SMrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMmnyHR/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMmnyHR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F457C433C7;
	Tue, 27 Feb 2024 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043199;
	bh=pseK6M990om+kS/rrVy5sG2hIWicWvX3yMHbzAxldUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMmnyHR/VAmLR/EmJ6p8/5xNYyzdCr6QB+1bZ1XsITvhp7whimpDInDJ9F1iU3gkd
	 E7hx7fKAZgk7GVJ+9Hu7SsnYLdfOevop2LW2+Y4N9wXXf8nt60zedtV06x2nr7K0el
	 giosyEsL4M3SqC8k4+SbeRJzwNjF0/6qVhI8Xpyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Huang Pei <huangpei@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/195] MIPS: reserve exception vector space ONLY ONCE
Date: Tue, 27 Feb 2024 14:24:45 +0100
Message-ID: <20240227131611.194973905@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huang Pei <huangpei@loongson.cn>

[ Upstream commit abcabb9e30a1f9a69c76776f8abffc31c377b542 ]

"cpu_probe" is called both by BP and APs, but reserving exception vector
(like 0x0-0x1000) called by "cpu_probe" need once and calling on APs is
too late since memblock is unavailable at that time.

So, reserve exception vector ONLY by BP.

Suggested-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Huang Pei <huangpei@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/traps.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 246c6a6b02614..5b778995d4483 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2007,7 +2007,13 @@ unsigned long vi_handlers[64];
 
 void reserve_exception_space(phys_addr_t addr, unsigned long size)
 {
-	memblock_reserve(addr, size);
+	/*
+	 * reserve exception space on CPUs other than CPU0
+	 * is too late, since memblock is unavailable when APs
+	 * up
+	 */
+	if (smp_processor_id() == 0)
+		memblock_reserve(addr, size);
 }
 
 void __init *set_except_vector(int n, void *addr)
-- 
2.43.0



