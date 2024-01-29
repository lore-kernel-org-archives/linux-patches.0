Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B338F1586C1;
	Mon, 29 Jan 2024 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548401; cv=none; b=K72Dvz+i1O2TfxsXh6ejxacBJt0h9215B1A9UCfLHjgwvBXvDZ1kSFw6abXpkX8kkQoooD2eql54XWp1vcy6hKrHP0Ao9AE/Uws7oJTcRozaRO5Fx4gCGc0BNLcR++my1zc97hq9ByZ7MlBmJv9texo1hoQxAV8XoycKQHyyvL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548401; c=relaxed/simple;
	bh=3u/k5uUI9t/95mRk0IlL8VG3rOOHHYRmCPJgGxM2dKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yus2Fb1uVRfjtz/9LVw/3vNS0cd4aHGnYO1Bx3F60mFgQCrYXPYfyYDn6ST/1OXX+hr3llHMpCl8xG5skZ2LsJLGcyR/Yce7IN8pg0Ne2y+dJsAttmgPUyMbLkow98URyYlMwjSCJFo1rLl+Lq9QbHnhA9NXMtm+Gl7imGGk5Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08hzMePq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08hzMePq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761EFC433F1;
	Mon, 29 Jan 2024 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548401;
	bh=3u/k5uUI9t/95mRk0IlL8VG3rOOHHYRmCPJgGxM2dKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08hzMePq64HuJMVuVmDB6WnsvNtKrMVrPnoLRQPGbR1P8RW7K5tN5BCzcBbXlNFhz
	 l4ZkdNOp52B/Jw72srkX/1hCTaxQN28ZW8CBJb0I31BF5DhonHtkQT77hfbqfW3t+m
	 u26kJ3m4C+4EmSs/UksvGVyi5TrjZmjVVWPKyCWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/185] MIPS: lantiq: register smp_ops on non-smp platforms
Date: Mon, 29 Jan 2024 09:06:20 -0800
Message-ID: <20240129170004.375315380@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 4bf2a626dc4bb46f0754d8ac02ec8584ff114ad5 ]

Lantiq uses a common kernel config for devices with 24Kc and 34Kc cores.
The changes made previously to add support for interrupts on all cores
work on 24Kc platforms with SMP disabled and 34Kc platforms with SMP
enabled. This patch fixes boot issues on Danube (single core 24Kc) with
SMP enabled.

Fixes: 730320fd770d ("MIPS: lantiq: enable all hardware interrupts on second VPE")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/prom.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/mips/lantiq/prom.c b/arch/mips/lantiq/prom.c
index be4829cc7a3a..28da4e720d17 100644
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -114,10 +114,9 @@ void __init prom_init(void)
 	prom_init_cmdline();
 
 #if defined(CONFIG_MIPS_MT_SMP)
-	if (cpu_has_mipsmt) {
-		lantiq_smp_ops = vsmp_smp_ops;
+	lantiq_smp_ops = vsmp_smp_ops;
+	if (cpu_has_mipsmt)
 		lantiq_smp_ops.init_secondary = lantiq_init_secondary;
-		register_smp_ops(&lantiq_smp_ops);
-	}
+	register_smp_ops(&lantiq_smp_ops);
 #endif
 }
-- 
2.43.0



