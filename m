Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D6C56742;
	Tue, 23 Jan 2024 01:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974050; cv=none; b=YkJcM+WMgXitoc9dQB2whWnNsuGrmWvasNBW94RhYhcxDTunKPNprdLwT6uFw0XvlxxPsw/I5CCXWdon5Sm7UEpryCXERZDEiqw/Ual6fa+uHhoFTgiTl2ZGaHoPa68N57gHuNzwp+M/yTfFrTzebfUbVjhzBG0izEdvBisMzcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974050; c=relaxed/simple;
	bh=gSyPunUltPe8/pG+bgjoiLjU0gM27VsLC+f3HJnbVfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Srr44n3zm5mar7yycd7Zb5vA5lf9mnasAgzsatQE29EoZOQTi14lFpM8HDeFipX6NueQx/eVqYQWDyKGPQId5JwDnQCIxQXiFA32Xh/tSBdvu0XGzp950uoVYvPho7Lg9MKQOx6gX2I35/ebQtFpvOGpMDHCoqisbpfKVoavLyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxYKy9s3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxYKy9s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AC0C43601;
	Tue, 23 Jan 2024 01:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974049;
	bh=gSyPunUltPe8/pG+bgjoiLjU0gM27VsLC+f3HJnbVfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxYKy9s302OKM0DsRZPhnR27kKPJvdBLK6a8mv5dvBm5Q7109TSUCCaQZQddM2r0w
	 0RNwSfr9f9NF2RRHFjH3/b4nAy+i4hcMnJjOMi/HbOtfHvK1TxKBdxnDEZsSl5VPBJ
	 CFIElBI7lsVG4deEXBVLBld5MJQi+Z0VEQ4mmEwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/583] powerpc/powernv: Add a null pointer check in opal_event_init()
Date: Mon, 22 Jan 2024 15:51:08 -0800
Message-ID: <20240122235812.744295687@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 8649829a1dd25199bbf557b2621cedb4bf9b3050 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: 2717a33d6074 ("powerpc/opal-irqchip: Use interrupt names if present")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231127030755.1546750-1-chentao@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-irqchip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/opal-irqchip.c b/arch/powerpc/platforms/powernv/opal-irqchip.c
index f9a7001dacb7..56a1f7ce78d2 100644
--- a/arch/powerpc/platforms/powernv/opal-irqchip.c
+++ b/arch/powerpc/platforms/powernv/opal-irqchip.c
@@ -275,6 +275,8 @@ int __init opal_event_init(void)
 		else
 			name = kasprintf(GFP_KERNEL, "opal");
 
+		if (!name)
+			continue;
 		/* Install interrupt handler */
 		rc = request_irq(r->start, opal_interrupt, r->flags & IRQD_TRIGGER_MASK,
 				 name, NULL);
-- 
2.43.0



