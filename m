Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024927;
	b=tliLq7SwOYjqTQ8etWtTm+6RG9O6uOrzXDDie6MxLeqJWpAWBAhXa9sbeqrs2MZKnroB
	 jtRHtkwrF2IUVoHO3BGdS1hHkV0OzG4PgfwvRPU4jal+5ttBIsW6nfFUt1rCufrgCadWY
	 ClCKsGFR1ys057nhGRHjs8YVP+URTd8wnxWNVAmwjy/11fRGQg+75KI39pGxc9f0W8gyv
	 d91pBMjv+0dNcpp6imwGjWtO8y06l8iIDVif2YY5HxQ50+wNQTzXVMzyLMRIucmU0jvVc
	 4qHIM9R2QC1lfg2CcaYHiM3gFnue9OdcAJ2WDBBYGtiZI8ESOR4gUE5evwQAl1ctxTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aMtrEINGOqEiY/nf77ja7I2VfqaOwzvHuPWpNKstuqk=;
	b=4OTRkgxojG8ekVTB1CLKJ61pDHKjOHZTbj3NCg3+EI/mHVsAxjXeH7CZ3PZUfOR0XpUk
	 haGqOKmV4G5CjiPRdRUjSS/DhHMt48k6Q17E/SnLcVlNa/1IKgxmnnZ+C3evPSyXzqcl1
	 01eNmI7X1OBBANQPyywHx8ehdPQUM6ob+7MesXflAHC1lS8Dea4y36T2NQCteh8mzFUSL
	 VCyDWDHdUtg1Vf4M67X18hSUrT+fIFE5RjSWShUVVmPWuNWswfDnBfZVXtIi59jY/G769
	 jZO2IZLMWbfkLDB0S2P8v1cSBA+CUSKsufzS8oraFXACX3bcqp1mlgqp8PuC8oEW04g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngAygBK3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1057606A31C;
	Wed, 18 Nov 2026 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngAygBK3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB511F000C4;
	Wed, 18 Nov 2026 18:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024926;
	bh=aMtrEINGOqEiY/nf77ja7I2VfqaOwzvHuPWpNKstuqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngAygBK3mQFNoTinZV8ewscOzQvG/icE1PlKEmL99zS9lZuBNDJhjA2tyf7o9/M9h
	 CI/Fpca/g5wIe3zbb4Khp1WJ8Rrza9ZvFxwGtbShBAY2hD3E33IRZYp1wpI/9I8tU1
	 d3jsKyqKNTnBwzrFCS4R3LCTrfLRFedETWKPN4Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0897/2151] pinctrl: stm32: Fix clock reference leak in stm32_pctl_probe()
Date: Wed, 18 Nov 2026 15:43:52 +0100
Message-ID: <20261118150154.968965216@linuxfoundation.org>
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

[ Upstream commit dfd8259507c53a3c7eb0dd11c1152c88e12aa316 ]

stm32_pctl_probe() obtains one clock per bank with
of_clk_get_by_name(), but none of the error paths drop those
references: the loop returns directly when a later clock lookup fails,
and both the clk_bulk_prepare_enable() failure and the err_register
path return without calling clk_bulk_put().  clk_bulk_disable_unprepare()
only disables the clocks, it does not release them.

Release the references on these paths; the success path keeps them as
the driver needs them for suspend/resume.

Fixes: 451bc9aea9a1 ("pinctrl: stm32: Add check for clk_enable()")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index f64dbb29a99dc..384fdc13a504b 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1763,6 +1763,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		pctl->clks[i].clk = of_clk_get_by_name(np, NULL);
 		if (IS_ERR(pctl->clks[i].clk)) {
 			fwnode_handle_put(child);
+			clk_bulk_put(i, pctl->clks);
 			return dev_err_probe(dev, PTR_ERR(pctl->clks[i].clk),
 					     "failed to get clk\n");
 		}
@@ -1773,6 +1774,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	ret = clk_bulk_prepare_enable(banks, pctl->clks);
 	if (ret) {
 		dev_err(dev, "failed to prepare_enable clk (%d)\n", ret);
+		clk_bulk_put(banks, pctl->clks);
 		return ret;
 	}
 
@@ -1797,6 +1799,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	}
 
 	clk_bulk_disable_unprepare(banks, pctl->clks);
+	clk_bulk_put(banks, pctl->clks);
 	return ret;
 }
 EXPORT_SYMBOL(stm32_pctl_probe);
-- 
2.53.0



