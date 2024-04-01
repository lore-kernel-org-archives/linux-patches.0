Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC8143AD6;
	Mon,  1 Apr 2024 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987947; cv=none; b=U4/NXA9gjwUXkXSKdRPDoeplF6WDd/UZC79KxYWZK6C2b75EbHhhoh6Dh26gbkSSITaHj5u15tJKV1plHXCZwh0SOGgfp7bAJmXbuYHXn1y1QNzxB+S1uRxmdyJj85wSCvoLNQefO+O01dCdtzCoMVCS5Rfd0lYajFRidZkxnw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987947; c=relaxed/simple;
	bh=0PjHsngTRhL05k3nikCA/iX3Pp8TwBLyqUwshew/woA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXcTulqe9myw8isCoG4ryZQ3JpAjiRiRfpAwwRLNQ47G3guTzpiGYephrqNPvuQbCPI+EF4zYXAop8/7NEpU1vURUG0+1r0R59skDKIUQAB4ol2IgsmFJyzvbWa1vLSgKhSepaE3XHzfcnFDgsKjMsQzIdx4G/l1EN8aOczuxOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnJri6Q9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnJri6Q9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410BAC433C7;
	Mon,  1 Apr 2024 16:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987946;
	bh=0PjHsngTRhL05k3nikCA/iX3Pp8TwBLyqUwshew/woA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fnJri6Q9uqCfMTOMfJ8+lCptq5pj9VVhVObhnnBjtCzvr4AhZZK8ILBoMoCNBlMQQ
	 tqlsZVMGhZsbI2Bfjdby4jt7TTmPXCNjFK9l5RdFsia3/zG3IK1PnSFu0vhakORO+/
	 1eDKuQ1i3bIk186yb1kisJMW7o5Bf5/t8BLR5LuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 037/432] powerpc/smp: Increase nr_cpu_ids to include the boot CPU
Date: Mon,  1 Apr 2024 17:40:24 +0200
Message-ID: <20240401152554.238549979@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 777f81f0a9c780a6443bcf2c7785f0cc2e87c1ef ]

If nr_cpu_ids is too low to include the boot CPU adjust nr_cpu_ids
upward. Otherwise the kernel will BUG when trying to allocate a paca
for the boot CPU and fail to boot.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231229120107.2281153-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 58e80076bed5c..77364729a1b61 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -381,6 +381,12 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 			nr_cpu_ids);
 	}
 
+	if (boot_cpuid >= nr_cpu_ids) {
+		set_nr_cpu_ids(min(CONFIG_NR_CPUS, ALIGN(boot_cpuid + 1, nthreads)));
+		pr_warn("Boot CPU %d >= nr_cpu_ids, adjusted nr_cpu_ids to %d\n",
+			boot_cpuid, nr_cpu_ids);
+	}
+
 	/*
 	 * PAPR defines "logical" PVR values for cpus that
 	 * meet various levels of the architecture:
-- 
2.43.0



