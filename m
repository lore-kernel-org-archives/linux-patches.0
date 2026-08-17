Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2D33D5C07;
	Mon, 17 Aug 2026 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980309; cv=none; b=sQGiYNWTWKnZP5G3p30K2IisFeopF8Xh/TmCXzZ6GYiBNOHbnzmCP7xHRPsmUo0nhaYS2BQl+bcn9Jwp1YG5wr734ZeHZ+1krM2u2XnfMP5AtA+gPjG9O3MxX+CNlIA/2nl2d9Ttq2Lzxeh1D0Dns/Fba2UR9YFUgA+KEswGxsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980309; c=relaxed/simple;
	bh=G5w5rL0C6I+LYwMJcoi9zFzGFy8+Ct88gEvDPum7Po8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfO96gKID/3vIHSbeReslTisQIbiixYEyBD9lshLpezDYqgpIFjk5t1TN/n7SifyIJduCgAkHqih6hN3ozbVNcAXahcDF7YssbFakyXOYnLQN3ToG5FMv/kUj5GiKmetEIJ6adW+1Y3v1MMPu1SWaXdWA8ZIqsHQCGqa4n97Jpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXA4zanA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXA4zanA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EB01F000E9;
	Mon, 17 Aug 2026 15:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980308;
	bh=yUYndBbTwA9Anf1pm+dHJk5x06OgYmjNIHACKzzfF3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXA4zanAUU03iZYn8W14eg80C/jsUA+2Wr80ZiASaOJDseohACpE9AEvLpX5ZdMxS
	 WlhNGdtiuTf9FtlbHYsfJurA+nZoLZ3tdrkej6Ot4TP6/ix5zsdEMcofWo0ISuM3ZH
	 6vR71HY912+WJ8h+JaK/d6F3VvEwgBi5QTmbHM80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 489/609] ARM: npcm: Fix OF node refcount leaks in SMP setup
Date: Mon, 17 Aug 2026 15:33:05 +0200
Message-ID: <20260817132600.286000889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8eb052f48331474c2789d07b7f11165c323bd2f9 ]

npcm7xx_smp_boot_secondary() and npcm7xx_smp_prepare_cpus() look up
the GCR and SCU nodes with of_find_compatible_node(). The returned
nodes are used for of_iomap(), but the node references are never
released.

of_iomap() does not consume the device node reference, and iounmap()
only releases the MMIO mapping. Drop each node reference after the
corresponding mapping attempt.

Fixes: 7bffa14c9aed ("arm: npcm: add basic support for Nuvoton BMCs")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Avi Fishman <avifishman70@gmail.com>
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-npcm/platsmp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-npcm/platsmp.c b/arch/arm/mach-npcm/platsmp.c
index 21633c70fe7fe..fe63edc9886df 100644
--- a/arch/arm/mach-npcm/platsmp.c
+++ b/arch/arm/mach-npcm/platsmp.c
@@ -35,6 +35,7 @@ static int npcm7xx_smp_boot_secondary(unsigned int cpu,
 		goto out;
 	}
 	gcr_base = of_iomap(gcr_np, 0);
+	of_node_put(gcr_np);
 	if (!gcr_base) {
 		pr_err("could not iomap gcr");
 		ret = -ENOMEM;
@@ -63,6 +64,7 @@ static void __init npcm7xx_smp_prepare_cpus(unsigned int max_cpus)
 		return;
 	}
 	scu_base = of_iomap(scu_np, 0);
+	of_node_put(scu_np);
 	if (!scu_base) {
 		pr_err("could not iomap scu");
 		return;
-- 
2.53.0



