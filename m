Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025916;
	b=OaBxvWH6xmXMmVaZG4d/c0DkKGOC+CLxXY/LjCbhHyaqvtzPRNUr4dBUC3OrL12HCx/N
	 CY+5rHTi9dqutOxC1p30TYbIngu2Navz0GRbGhI3vOw6g+mghPYKTXDVxVKtCUfd6HnlA
	 esvxTdr/LIV8CgtrMKoO1G06lkoiG219A5rSj/X4ANaVS4+88ztpFtFYreSY6Hnvra5cy
	 5WMfEY4TCDaGgXhDrIzqw3/CZt7Lz8ADyKHurbdZICxP1CDw7jYAAK30eBIA+X8/sC0pM
	 fjyycj0iOCYegFx6dDMpzQTKKJec5fL1SW2lKvgIifHrDSQrRj2oAPmxKRU+2SVGGPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tbCEG+PWUgeXT/QwXBsTqcxkrRF6qGqlH3mr4Hm7V/c=;
	b=psYkkygC+B9ZtehzMHzn8EBKne6AGzImRh7WilqB/3swhzkk5n7shRAwQpyfGxoeXVqC
	 TKS0oQVWyZccAtpUSwOpMAPq+aF52KWzAapU5X3JCqmvdbGJhBrBycyQ/TV/m0cvJLDYD
	 hvY6nH1kekHw1NuEYcKdA/kN42GivRVbZPqm//cI7JCHTooi43Nt2yyoRq1IFMLiGwSEd
	 QwieyIspxfOnD1yuPz4g+9eQjO4PTcpicy3FVcpP5wjA8UJViQGrROWQ69NJxBf2QLhtU
	 8k43Y4nsowZ/rOcXoNuldZCnVlf/PzvPmAjQbsHuZvJLw1jObLG2MNdznjexel97Nig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pb1UZn7C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DBA606A31C;
	Wed, 18 Nov 2026 18:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pb1UZn7C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA141F000C4;
	Wed, 18 Nov 2026 18:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025916;
	bh=tbCEG+PWUgeXT/QwXBsTqcxkrRF6qGqlH3mr4Hm7V/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pb1UZn7CsBLrIjbJKyV7UwT31VjwOBptkreFE+B3Lb1ez4+aksecb/mVgCwxbJCWo
	 /Pl0de9hKauA4akEIC0Wt5GqF6d8DaZo+HQk5k0rGtTUgVeWZ73zfbyU/xdxc+chzU
	 zchmN/7SdRRc9Yyl2wvZyqScAVTqn8yX0AYEa4kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Caleb James DeLisle <cjd@cjdns.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1242/2151] clocksource/drivers/timer-econet-en751221: Fix clock reference leak
Date: Wed, 18 Nov 2026 15:49:37 +0100
Message-ID: <20261118150207.414251454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 36790ef57803400339d8ea4081d85483264dbd6c ]

timer_init() obtains the timer clock with of_clk_get() and only reads
its frequency with clk_get_rate(); the clock is never prepared nor
enabled. All four return paths after the acquisition (of_iomap()
failure, clocksource_mmio_init() failure, cevt_init() failure and
success) return without clk_put(), leaking the consumer reference.

Drop the reference with clk_put() right after the frequency has been
read. The clock enable state is untouched.

Fixes: 3b4c33ac87d0 ("clocksource/drivers: Add EcoNet Timer HPT driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Tested-by: Caleb James DeLisle <cjd@cjdns.fr>
Link: https://patch.msgid.link/20260915054552.1729612-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-econet-en751221.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/timer-econet-en751221.c b/drivers/clocksource/timer-econet-en751221.c
index 4008076b1a210..1859335345b59 100644
--- a/drivers/clocksource/timer-econet-en751221.c
+++ b/drivers/clocksource/timer-econet-en751221.c
@@ -181,6 +181,7 @@ static int __init timer_init(struct device_node *np)
 	}
 
 	econet_timer.freq_hz = clk_get_rate(clk);
+	clk_put(clk);
 
 	for (int i = 0; i < num_blocks; i++) {
 		econet_timer.membase[i] = of_iomap(np, i);
-- 
2.53.0



