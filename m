Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036607;
	b=XUKDYPLUQWu5TzlqDZd+SJ/o5oj6fMsDg+roOMDIxfclIQxZrrpTmFb2ZZT+HoTjzFyL
	 jeSOivt2OnSYEuDj74ntoAOnRUY5vFXgWYeCQFubYR5PZ4fuoTl7s/s4UDrDbpMMgK0Ya
	 byHkery3Nmy8/fKhHL/TJRF0SstRctht+50PRwjeuEhiVBTJ+OQeU4WV6PVGnejb8sz7V
	 TSg5u28BKUrUT5DzZqusN27dkohCWyw80QwvhIRaYcw0UoqnOddOkQC1Ojnqzu1efeZvk
	 D2j/EP9RuMQK5lX0JEk1FtkOudTHiRSnV/L+Wt2lptLPtSaWTyyurjFqH+UX538v1ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DgsZdpqsqBKf2I7QJGm+V0/iXkOD0KvxKtlBfdoI638=;
	b=Hi3LJy1SN4dRDbyB7DL8DInzHBryh3W3YR5VNk0kvnQGClqRvq8X6P8Xvdx5R609rdX9
	 RMUpbZDd8bYNmu4D4jCksVi5IhXtHxVXxxofhii1rBJgYrdTK85Vm3BUUbTwaWyFAYPeQ
	 24fSPfR4O/Ax8bpWjGuXB/nzr8C469Lr74Uo9zYPomAXVK3ZIri4DYLEIQRTKadIH/SfP
	 6KT1rk54pgdjHjxXxJEwFwexoZ1+XFLe/e/zt+ffTbmU0yvsEHEDSZFlIvpParkHOCDMM
	 w1YGz+Vf4b3J721qrxT/cb7kMoLafjKKnneNPXpfOR00xqLg0rbnSrZdcySnchfbGWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJtrIbEF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1249606A325;
	Wed, 18 Nov 2026 21:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rJtrIbEF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B4F1F000C4;
	Wed, 18 Nov 2026 21:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036607;
	bh=DgsZdpqsqBKf2I7QJGm+V0/iXkOD0KvxKtlBfdoI638=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rJtrIbEFadBniyRRjN52vm9N2NixY2YrCJWuOAFBs0e5Iy8ocZfTpYGI5uy3Rpctb
	 GJULsCiTF5OXyomvb2FWY+7biaOr8M4kV8hg9rwipHyk03qiKRMTu24RSA2LpulgSR
	 gdbwkeRyAjIrH6IDNIySu4KukP8y+aFDpP5zEJ9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1121/3318] irqchip/mchp-eic: Fix clock reference leak in mchp_eic_probe()
Date: Wed, 18 Nov 2026 15:29:03 +0100
Message-ID: <20261118150353.659213247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit af9c707eb065a7d48eb92dc15acdb4346acf5db0 ]

of_clk_get_by_name() returns the clock with an elevated reference count
that mchp_eic_probe() keeps for the lifetime of the driver, but none of
the probe error paths drops it, so the reference is leaked whenever
probe fails after the clock has been obtained.

Put the reference in the error cleanup.  The clk_prepare_enable()
failure path must jump there directly as it cannot call
clk_disable_unprepare() on a clock that was never enabled.

Fixes: 00fa3461c86d ("irqchip/mchp-eic: Add support for the Microchip EIC")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916190349.2094401-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mchp-eic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mchp-eic.c b/drivers/irqchip/irq-mchp-eic.c
index 8a5baa0987a4b..b425db30338df 100644
--- a/drivers/irqchip/irq-mchp-eic.c
+++ b/drivers/irqchip/irq-mchp-eic.c
@@ -228,7 +228,7 @@ static int mchp_eic_init(struct device_node *node, struct device_node *parent)
 
 	ret = clk_prepare_enable(eic->clk);
 	if (ret)
-		goto unmap;
+		goto clk_put;
 
 	for (i = 0; i < MCHP_EIC_NIRQ; i++) {
 		struct of_phandle_args irq;
@@ -264,6 +264,8 @@ static int mchp_eic_init(struct device_node *node, struct device_node *parent)
 
 clk_unprepare:
 	clk_disable_unprepare(eic->clk);
+clk_put:
+	clk_put(eic->clk);
 unmap:
 	iounmap(eic->base);
 free:
-- 
2.53.0



