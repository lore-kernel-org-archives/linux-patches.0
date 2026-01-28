Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340E326ED40;
	Wed, 28 Jan 2026 16:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616166; cv=none; b=U9+oC2NyHcTnv32K8qGomjQ5g2W5X1j+WTXbmbubKzs8pTK8qV/RTiSL/p3PM+GK8EG8mp9BsmamE0nxoQnhepGhndtxOR0C33qr0WQ8/fkHbHqzS4AkKKfMtsWIMf91Lq3GQALamxUn1TIoKgjUzYjI+u3/ss6b04fTQPiDhAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616166; c=relaxed/simple;
	bh=dVE0jbvSaPhoAcGimLnjxGF/Ef8TITqVjRVrfq9W7gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fs94O9k4sxZvpK+07ypJE8QJGOYjLowRbL9kCj0ZchHUz0i9n2SM4OKAzqvusHQ2gYJEJbYKnQY5vuVOG8jjMXWu/GjuudOeKeeOZTIgzYs8/z/3+W2iAWFKtRDQM1UkcGngsr2KOLxkMeV9QHtBh7HNbCni3OdJS47GPi3v6EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEyV3ipN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEyV3ipN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8220EC4CEF1;
	Wed, 28 Jan 2026 16:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616166;
	bh=dVE0jbvSaPhoAcGimLnjxGF/Ef8TITqVjRVrfq9W7gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEyV3ipNdKRBm2kORSC8svOMiqz//j5P3/3kmKW2EmulIZpuaqHgKLdo9WuZxMGbh
	 LIdSDw7/3QVZwQtKirs5EdNMCIy25MPCEyCt93a9vyO7BPtnrS7viStjnlRo8da9yX
	 vB6FTvWamVQbyM1thmDjE3FHwqZiuyq5RAKx2z38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Subject: [PATCH 6.18 225/227] irqchip/renesas-rzv2h: Prevent TINT spurious interrupt during resume
Date: Wed, 28 Jan 2026 16:24:30 +0100
Message-ID: <20260128145352.533155962@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit cd4a3ced4d1cdb14ffe905657b98a91e9d239dfb ]

A glitch in the edge detection circuit can cause a spurious interrupt. The
hardware manual recommends clearing the status flag after setting the
ICU_TSSRk register as a countermeasure.

Currently, a spurious interrupt is generated on the resume path of s2idle
for the PMIC RTC TINT interrupt due to a glitch related to unnecessary
enabling/disabling of the TINT enable bit.

Fix this issue by not setting TSSR(TINT Source) and TITSR(TINT Detection
Method Selection) registers if the values are the same as those set
in these registers.

Fixes: 0d7605e75ac2 ("irqchip: Add RZ/V2H(P) Interrupt Control Unit (ICU) driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260113125315.359967-2-biju.das.jz@bp.renesas.com
[tm: Added field_get() to avoid build error]
Signed-off-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-renesas-rzv2h.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-renesas-rzv2h.c
+++ b/drivers/irqchip/irq-renesas-rzv2h.c
@@ -89,6 +89,8 @@
 #define ICU_RZG3E_TSSEL_MAX_VAL			0x8c
 #define ICU_RZV2H_TSSEL_MAX_VAL			0x55
 
+#define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
+
 /**
  * struct rzv2h_hw_info - Interrupt Control Unit controller hardware info structure.
  * @tssel_lut:		TINT lookup table
@@ -328,6 +330,7 @@ static int rzv2h_tint_set_type(struct ir
 	u32 titsr, titsr_k, titsel_n, tien;
 	struct rzv2h_icu_priv *priv;
 	u32 tssr, tssr_k, tssel_n;
+	u32 titsr_cur, tssr_cur;
 	unsigned int hwirq;
 	u32 tint, sense;
 	int tint_nr;
@@ -376,12 +379,18 @@ static int rzv2h_tint_set_type(struct ir
 	guard(raw_spinlock)(&priv->lock);
 
 	tssr = readl_relaxed(priv->base + priv->info->t_offs + ICU_TSSR(tssr_k));
+	titsr = readl_relaxed(priv->base + priv->info->t_offs + ICU_TITSR(titsr_k));
+
+	tssr_cur = field_get(ICU_TSSR_TSSEL_MASK(tssel_n, priv->info->field_width), tssr);
+	titsr_cur = field_get(ICU_TITSR_TITSEL_MASK(titsel_n), titsr);
+	if (tssr_cur == tint && titsr_cur == sense)
+		return 0;
+
 	tssr &= ~(ICU_TSSR_TSSEL_MASK(tssel_n, priv->info->field_width) | tien);
 	tssr |= ICU_TSSR_TSSEL_PREP(tint, tssel_n, priv->info->field_width);
 
 	writel_relaxed(tssr, priv->base + priv->info->t_offs + ICU_TSSR(tssr_k));
 
-	titsr = readl_relaxed(priv->base + priv->info->t_offs + ICU_TITSR(titsr_k));
 	titsr &= ~ICU_TITSR_TITSEL_MASK(titsel_n);
 	titsr |= ICU_TITSR_TITSEL_PREP(sense, titsel_n);
 


