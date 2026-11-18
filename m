Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047920;
	b=feIV9ZnQPGFwAxJIelS7obPWDLzdPsNoS6h3l+yyJhPOcpMt7kIan6PO8L58g1yn8nHB
	 /V5vMv/JrfgBIn2wPvbJk+8C1BAGpr/QqtVhRkf1kuqEO66MnEV51ahARfGo5kQ+TRrkE
	 tSnDhUvWBs5r5voaPItPxKyl8Iva7g+5lXIW0krXgKwih/GfG9o/Dz0iiQJx6FwEEJIID
	 RNTWH+5hfuCWGntS1IB320aPJtrdw1GpZMXN6QlZPakctC2HR7cjmO3An9IGSqWC2qUWf
	 bFKYGoCaLj1/sMV1W/nQxWeIsekbw1HyZzOhrgMgt6n4ATLxhaWVyu8U2RKe3bDEUdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z4UHk7zwt6yIotejv9bH30qmMgZRoNox1Af/sFuztPw=;
	b=xwkuKbKDSsYLkPBZX4Y6UAqNgg/66lpWadvOzh//wlIi0tMldCEGV6TrWIqdD8TxQwzU
	 1h3ZX1ojX2nj59T1F58HvfrujP/usuXAZW1pMOT/gNAR3dapVOfUhvlGm7x0/mBw4uLxb
	 9otYwqZlJ/2349efWkYPzAAyVVtKbPr46tksnr2CPJVu83vHwrX+/IOBDkPB5LcxaH7Ff
	 88LJ7s5bbVgYx1oMoT/8Q3oyQDHPS/E/Duxr4W0KHOhn18KZiSDdvqGtNH1TGQRT8F465
	 3gWFDvyLKXWovl//07B37FLlIGyU7q1jc3bJ3mOTLhcXg/rADgDmbikQRGnJ/3yACaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTy47Ymo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FF9606A31C;
	Thu, 19 Nov 2026 00:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTy47Ymo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AE81F000C4;
	Thu, 19 Nov 2026 00:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047919;
	bh=Z4UHk7zwt6yIotejv9bH30qmMgZRoNox1Af/sFuztPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTy47YmoMyEh+S6U4bS1Ib2fRd8nSeZP196zAOIw6QRlQHgoVm4IfXycKuyRzgx/n
	 EcKnR7msx8gu7xs7OezrbBscFw8rUPeCXloNAf4DNs3e6llGhjNmGlVC/KaA/4Led0
	 5qRLAAfhs1yli/a5shbP+vnOJgIJ3q9NMYvexrX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1773/2857] microblaze: CCF: fix refcount leak
Date: Wed, 18 Nov 2026 15:46:47 +0100
Message-ID: <20261118150305.117272827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit aeedf85beac51c7cd8f7bf4c918a0104dfdb8b78 ]

Every value returned from of_clk_get() is supposed to be cleaned up
via clk_put() once not needed anymore.

Fixes: c1120542b99a ("microblaze: Add support for CCF")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Link: https://patch.msgid.link/20260526184105.18962-4-grandmaster@al2klimov.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/cpu/cpuinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c b/arch/microblaze/kernel/cpu/cpuinfo.c
index cd9b4450763b0..32c508e85408a 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -133,6 +133,7 @@ void __init setup_cpuinfo_clk(void)
 		cpuinfo.cpu_clock_freq = fcpu(cpu, "timebase-frequency");
 	} else {
 		cpuinfo.cpu_clock_freq = clk_get_rate(clk);
+		clk_put(clk);
 	}
 
 	if (!cpuinfo.cpu_clock_freq) {
-- 
2.53.0



