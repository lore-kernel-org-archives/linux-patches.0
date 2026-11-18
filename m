Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036632;
	b=GukH6bz9JyUVMDrgRa7ZA4XXz3tjpYlezxEi36PD3RKJ8H62vGGhM7VRBREabXEVoT/U
	 e1B4Q+Ber46faDoXwxIVDXa9mHglJ6ApvWg6br+fB8wUrs5nJPotNVasLhxV5ndF57F07
	 7OctVrkbEED+OFGLP+w2IV+YK0AfdahwMtDtDA1EH54dcSMrUnUkyAk1JJLsPDt0WodMR
	 S4b6dWrSa/mtImz3Nb31lbrigA9QosS2rbVolR5jq1s6yUBn2ccCZFIvoyLzFXnWDGQSn
	 3RYIiP0J6d9Oje6OsRwR5oj12BDMVnQpp17m7XGenqsAtgyZVBmw7wPmRu+nX8C845g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5PgscWduZ5x8P6zIRYZN+ZZ9EU07JrhY1ex8Y20Ek70=;
	b=q6L5t9M0ElPm5Xntv1g/z9otDcj4Hi6KM+Mbg3yW5GXW1TE8zCAOot5g5mVG2j3l3ybU
	 9QD/jauvN1iccajmwkVbcnNCpHiICoW1HhQAwzTpRQKWLdw3LK8KN/2u5kX+nZFGuju57
	 5WvlIxqnuHRqLFID+xQMQ/cvvT0/qtdWOHTV+JxzkMqY/YusV0vIqbbadew0Vafe28D5k
	 aXKy5e65NjUENldislR9K4aLi0hRg0O1/H8J9BiSr2MOMVcIj1PVibSYn+m6eznZzHt4v
	 K/q+rVm3PWiTpGNkcvBujSOwAdQg4HzEUzF7Jkk9VMYZA1Heafv6CitlV9NS3elFHGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oHF35f9m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FAB606A31C;
	Wed, 18 Nov 2026 21:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oHF35f9m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4CD1F000C4;
	Wed, 18 Nov 2026 21:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036632;
	bh=5PgscWduZ5x8P6zIRYZN+ZZ9EU07JrhY1ex8Y20Ek70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHF35f9mCvQcE3vh/iagUTAr/P3S0WcJhfghfE1o/xk0RgPqGyN8Beggwop7AR3VT
	 n62q1l0yeIdEaF0Yr3S26TtPWZuS+6NBl4bIZwjHs1uxuxZ66WIQpsyipb7UiGx63c
	 kiNtucwmZ4yXglyLtXJ1syCq4wO/d6UJfJz90z34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radiy Zhambakiev <r.zhambakiev@prosoftsystems.ru>,
	Andreas Kemnade <andreas@kemnade.info>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1129/3318] mfd: tps65217: Fix NULL pointer dereference on IRQ init failure
Date: Wed, 18 Nov 2026 15:29:11 +0100
Message-ID: <20261118150353.910180837@linuxfoundation.org>
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



