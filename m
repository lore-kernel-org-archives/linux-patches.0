Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC2A13AA4C;
	Tue, 27 Feb 2024 14:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044128; cv=none; b=g+b3fCc1aYPWUFsqhGnDEwNq01D/FWZjbOdEsESTim6p1INqr/fRZNtWY37woPS3XHgt5oSKDZLzzWw8BKk4vvmxSf8vCezSbJ8yiROeH0nFIHDLbFOFv6eiI4n+CQDlvfWoPlVmos8EMYT+nZahetUgxal7W2QgKU4pQPdGhEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044128; c=relaxed/simple;
	bh=8XDS2wVv85M/xIKsSEqkiIGBra4tSNWYz84nYsF2yLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3cZQIBH0WSiW43poXYRZ6hseFp07hu+nY5xnPDBmNbMlw+m64RAwPWXvHZ891q+JgP5h/5vRMdDqyJs4wcELTcUSHgX9Vv93C95VtH47qQoq926NTN9XcJl4XcNnnqcdQtMxUAnsXO3P0DGxN+B8wfMxWeMinaw+6JintQMB9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lk2+uZCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lk2+uZCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF509C433F1;
	Tue, 27 Feb 2024 14:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044128;
	bh=8XDS2wVv85M/xIKsSEqkiIGBra4tSNWYz84nYsF2yLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lk2+uZCTTPTRP6mDKE+/bQrlwdVp1xTESTEZTQLsggHnILgjta5Y8g2Uh1N2PyuJf
	 ZuxgDZ9k83UUN4AnFwXGn76LzoNi0IRj1SmXpfa2xw4BUyBKW1gHOD9uwwQKrOc2cL
	 b4xdLyKtHX96IVDjrA0y1yyPKYgPnujS6GI1Ekwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/122] irqchip/mips-gic: Dont touch vl_map if a local interrupt is not routable
Date: Tue, 27 Feb 2024 14:26:45 +0100
Message-ID: <20240227131600.152135161@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit 2c6c9c049510163090b979ea5f92a68ae8d93c45 ]

When a GIC local interrupt is not routable, it's vl_map will be used
to control some internal states for core (providing IPTI, IPPCI, IPFDC
input signal for core). Overriding it will interfere core's intetrupt
controller.

Do not touch vl_map if a local interrupt is not routable, we are not
going to remap it.

Before dd098a0e0319 (" irqchip/mips-gic: Get rid of the reliance on
irq_cpu_online()"), if a local interrupt is not routable, then it won't
be requested from GIC Local domain, and thus gic_all_vpes_irq_cpu_online
won't be called for that particular interrupt.

Fixes: dd098a0e0319 (" irqchip/mips-gic: Get rid of the reliance on irq_cpu_online()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230424103156.66753-2-jiaxun.yang@flygoat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index fc25b900cef71..7888e3c08df40 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -398,6 +398,8 @@ static void gic_all_vpes_irq_cpu_online(void)
 		unsigned int intr = local_intrs[i];
 		struct gic_all_vpes_chip_data *cd;
 
+		if (!gic_local_irq_is_routable(intr))
+			continue;
 		cd = &gic_all_vpes_chip_data[intr];
 		write_gic_vl_map(mips_gic_vx_map_reg(intr), cd->map);
 		if (cd->mask)
-- 
2.43.0



