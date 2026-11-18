Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017934;
	b=NIpVShJViqryHPRbpNhjaa1drCdVxpLoLs7NDb32ks9r87BOl2aoRvZ5z0/QQtA36FX8
	 hCqq2xA5+aYk8nvvXV8kOEzZAQGL+30fJ3MeMK5RUEvNL08KdGHEHVqt3jZk4WAbvlioj
	 bhAKYCZ+x2hIf+0AAeggUTWDZx4GKeZ2kPUI5pGVnAdLTFAunevK6/wv2yuuncCCmAuAP
	 nb2s0hFq7T0h2vyblCGzyNp4GFKdutDBVhkrXX6rwH1meNzqplMNey/KRudzMozvyCDv+
	 3d6CgGEBcR8j3HMrf9njzQvlfWuVDGVkG0c8OmCpWnuaso3IWMIqAk9gP2gNUrOInkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bk2QuIN82RXJ1UlsDBfvUe4ZIpFdUm0GY3gcLJXR5+8=;
	b=yt98RzJVUbvGUEee7XJgLFY7PWjdkF8SZSjvKdLypsav6f/ni/st9iniEtSHbd5nS1ue
	 pBZdsx68RGeI8HFiW6GcnjEyhxHKaRcdP1WLbuQZ2dQHJvd3iEkuJ5rPyrdt3Hp47Vv3i
	 7JYACDUDtzW31Jj50xn0FfNZfocoB9L6/iULCeXYpxgtpEaDXCPFSPMrE/IJsjlSBDrRu
	 x9F7Dtp8vz5WqtBB7iJL2lPiEwImR8Dd2BAPb/sWcDY8FvAJEiy0cuuPurDLQhAt3lQFN
	 tSFu6CNU21trlrYqpuTXJNLFJCETvSKWp3w1cfOzfFrTEMxmqOb3Zh5F9B6YoyyyjUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8Pt36PI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DD2606A31C;
	Wed, 18 Nov 2026 16:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8Pt36PI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E621F000C4;
	Wed, 18 Nov 2026 16:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017934;
	bh=bk2QuIN82RXJ1UlsDBfvUe4ZIpFdUm0GY3gcLJXR5+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8Pt36PIhynY6OVjF9+r3xiwGMlimT2CN2ljNKmeYhWAZdiQBgqD1WN9pROzyLNXD
	 ZHaHPG9etuqbpixr/rIogx2kH1LDc8h1KDBwnVjKxaobHkNRVSCS9L8tdp+kwJZ50n
	 INNSueVLDxEURUQ3br/epXcFqux9+8SUQzYaHVHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1061/2651] pinctrl: stm32: Fix clock reference leak in stm32_pctl_probe()
Date: Wed, 18 Nov 2026 15:38:21 +0100
Message-ID: <20261118150326.178856904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 93127da05d560..6ebb8ea260d1b 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1980,6 +1980,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		pctl->clks[i].clk = of_clk_get_by_name(np, NULL);
 		if (IS_ERR(pctl->clks[i].clk)) {
 			fwnode_handle_put(child);
+			clk_bulk_put(i, pctl->clks);
 			return dev_err_probe(dev, PTR_ERR(pctl->clks[i].clk),
 					     "failed to get clk\n");
 		}
@@ -1990,6 +1991,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	ret = clk_bulk_prepare_enable(banks, pctl->clks);
 	if (ret) {
 		dev_err(dev, "failed to prepare_enable clk (%d)\n", ret);
+		clk_bulk_put(banks, pctl->clks);
 		return ret;
 	}
 
@@ -2014,6 +2016,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	}
 
 	clk_bulk_disable_unprepare(banks, pctl->clks);
+	clk_bulk_put(banks, pctl->clks);
 	return ret;
 }
 EXPORT_SYMBOL(stm32_pctl_probe);
-- 
2.53.0



