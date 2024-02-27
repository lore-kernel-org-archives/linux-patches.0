Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C741420C9;
	Tue, 27 Feb 2024 13:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040570; cv=none; b=Nnasy09ipqBnsZRp8EhdXQ1Id+GUWlLGA9IPNnifGjR+GB3euQlPRsaK6wDOeehLIFc5i9qG6DBzLF73pwQjyG6m2zj4YMUGsMrlMhG11az521C/QbJauZUEUL32560f8+/WfpolG3PH8K0gTmTfcFi4bCx0gSdLIVa09dnMYYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040570; c=relaxed/simple;
	bh=OSOzUElWVvYR3xWZoaSXaO5Soi+fTUQcr90DFE9TJYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azm0W3uWnEb/NOp2s5W4kJUsoi9mW/T8tSoS7PZyDgwU7hc0hOBWac4rYV3+UB2CO5TgvTKPnflQBKDAph5s3B8ERXB/F71dyA2SDsLmUD8ZP0SMlvZPze+QXDLZLDSgN2Z6CuFOTo6eWKgCZKYt3C2P/FHK6n6R3CYfcz7TyxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDHEtMPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDHEtMPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDA3C433F1;
	Tue, 27 Feb 2024 13:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040570;
	bh=OSOzUElWVvYR3xWZoaSXaO5Soi+fTUQcr90DFE9TJYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDHEtMPlkB6DTjILCZeMZWYulLilUbunp0BYUtkf4vVoNBG9BUs3gNylToUfg/Eb/
	 R6wGHrExxGA1Z/A9NwlK4kjFfgE6jJMSHemjnlkQct7kGtZm3CabnCMxdG0nfbZXQ6
	 dPmWL9lVrhB7q09NTLb6bNY/tLsvOYzBtRziuUCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Huang Pei <huangpei@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 032/334] MIPS: reserve exception vector space ONLY ONCE
Date: Tue, 27 Feb 2024 14:18:10 +0100
Message-ID: <20240227131631.631484841@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



