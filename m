Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F22B13B2B4;
	Tue, 27 Feb 2024 14:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042548; cv=none; b=Tbh9+atsqo0oJ0IexbZvRkLU/BI5jEz+7wwj1nLwIPdtEzaO3qY+zv9JhfJeonM+MBQ36DSQtYo3AnM7sro6p7/aq5V5nebjEctuZ/6TL0ydH3AEmtE8scA5CZn1KjDMHPEan6KM9FJTY/7Ak4beuCCcbTBKjxMIJbjxVNd6jVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042548; c=relaxed/simple;
	bh=/TJrwYkaMBP5PK7CVezi1Fmsm7hAEyaEqrPB0b3Go4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nb1c1rsHBQaOaH/OQC9KTcX/q5mFwlV3DwqXnzrGfOMm3IIR3Go5kE1JpXmS9PcBJqEwCK9xDw2/hdyDkxRIyDTYUVR1FoJZu0JbvhjZCUCQdlIqu2uazIpAo1bx+8sePHnd1StYtIYcNv/OseMW49dROwNs5TLNdFf92QqzXJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOFD62MK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOFD62MK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A22AC433F1;
	Tue, 27 Feb 2024 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042548;
	bh=/TJrwYkaMBP5PK7CVezi1Fmsm7hAEyaEqrPB0b3Go4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOFD62MKf1QZH7erhVkHaWsUxGaSelvyGrW4VlyZWo2HOMWMXzUdgieguFg1BwHXv
	 uots90d5UArApbGU/m2YTBuQX1c95pxcVepTOkyGGHcAf1s2G3mbGNmWpNzOYgTDjV
	 ZxkvAiAKSTotmXm8OcXxjv7ryetveN0sO0FfOhqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Huang Pei <huangpei@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/245] MIPS: reserve exception vector space ONLY ONCE
Date: Tue, 27 Feb 2024 14:23:36 +0100
Message-ID: <20240227131616.031161607@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index afb2c955d99ef..5c01a21a216b9 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2001,7 +2001,13 @@ unsigned long vi_handlers[64];
 
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



