Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062401;
	b=r755xxscgn4M+KBK/E5CpGcjIUqGjzzGyqZmwt7rWhxwsE3fRjbhSpZX4bZ9bHGTzsAn
	 XjbPOtRTjHkR37i0X8PKfYtn3HkIr65Q50ugiLzvn2cSvJer1GK7k9fWuN3CQVuM6NEI6
	 KAHbajPoLQX2tH3FhvQjtxnj4fGioPxR3VwiSjxPFQB0ppaSj/mvbMl20CMRw1Z39ZVTr
	 OWJRKB8XAUw9ieLlZnbv4BbI+C+f6+Rm0b8uetp+4TBdFnmSADxAyoxLZTxhOVE53XFr+
	 J/Ego52A6Q+Je0A6gezAAPn1RkX8m397SpdX60PvmI2yBsvYinQSKOL1IhBJi+eAGSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mh+ZAEKkPl4DQ3ltLwOlhMieAGfSq0vuK3MP8nLxmbw=;
	b=AlMH8OWuMXrLyMqtCb9FI/m9UZlUH7G8/HPj0Hx5FePPM0IwZsCQPv5p5mqxZnLH1ciu
	 0fmN556ncrR8FCfK1lq1NPH2bDNLnEDVkrlKy4yoDObUDczwK7dEgLFtsw41F8+3+dt80
	 DTo3Y9v6ql7HkXzlJp/yjtjKyBhCp4nDdoTCiEf5XxYMqgFoxAdZ8X/bkcJkAzeANmtHe
	 eFmUs1jFA2q1aMUGrxlUjz2VRm0eXkK1q3Y1dmbHTiOzpcPltMRdsVQVGaluMWrLrfKKP
	 HT+5NdNRKj1pc9hj+yA5wATW1h6exvheGfG2fKTM9lCO14lx9jMepf7ncnM2dCaYCXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BacgiXLF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346F3606D83E;
	Sat,  7 Nov 2026 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BacgiXLF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11371F008A1;
	Sat,  7 Nov 2026 14:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062401;
	bh=mh+ZAEKkPl4DQ3ltLwOlhMieAGfSq0vuK3MP8nLxmbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BacgiXLFZ+6z8d84OWvHZkyuB4iokdbYh6RKAT7zBFTpE/zqJ6S393KUzppRv5w/n
	 IIx925kwCle8NTMpKKw2RaSs7qF24FEQbf19DihcLIhOorbEGYXagc4t+evDWvtB7d
	 l3PBI0Zqo2wzrdu5P2cNUgAls1N6SkMzyNhmnOQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1317/1536] mfd: tps65217: Fix NULL pointer dereference on IRQ init failure
Date: Sat,  7 Nov 2026 08:55:33 -0500
Message-ID: <20261107135034.796478254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>

[ Upstream commit 0473a5b0663663b75573bf284beb77459e07c461 ]

tps65217_probe() ignores the return value of tps65217_irq_init(), so
when the irq domain creation fails the probe still completes and the
driver ends up bound with a NULL tps->irq_domain. Unloading the
module then makes tps65217_remove() call irq_domain_remove() on the
NULL pointer and oops the kernel. On top of that, irq_find_mapping()
may fall back to the default irq domain and dispose of mappings that
belong to other interrupt controllers.

Check the return value and abort the probe on failure so the error
is reported and no inconsistent state is left for removal.

Fixes: 6556bdacf646fcaa ("mfd: tps65217: Add support for IRQs")
Cc: stable@vger.kernel.org
Signed-off-by: Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20261002113624.178588-2-r.zhambakiev@prosoftsystems.ru
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65217.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
index 029ecc32f0782..a88dd69a2febc 100644
--- a/drivers/mfd/tps65217.c
+++ b/drivers/mfd/tps65217.c
@@ -333,7 +333,9 @@ static int tps65217_probe(struct i2c_client *client)
 	}
 
 	if (client->irq) {
-		tps65217_irq_init(tps, client->irq);
+		ret = tps65217_irq_init(tps, client->irq);
+		if (ret)
+			return ret;
 	} else {
 		int i;
 
-- 
2.53.0



