Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048854;
	b=lZp7Ak9b6ZS6VRprGY/DLMpeq9X3+S3sMIWe1UVT8LfO169E7HqMfSW5VfPGaIX0LgE1
	 mXWzdWXua+jEY9FZjOkrGzO1TGLyqCdQEf5iBm32JCFeh2Tk745/b0QHcFi0JFw/2wI3E
	 3x9Vk2ffY5efv/mj0aHBtOfROFCROypL4NKEZzHf6v9M0BXa8UmHp9YVB+cVbpyGQd/aL
	 HchARuBe7QCbCT5+5uTPZszEx5v6zxh+zYOm1GodcOnniIXY+6XxSsAxJclXofoWjIuIG
	 FVyTpN4TnzSZmbREta/AmbUb8Chf10b9dHE3v0nI7Gx2wAYK65lMw74YHssroF35ltg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v1NJWFr9S8yQNwfBq5Ziow6kcKSTj6hkOEXHlxOHBpg=;
	b=oOFbSNOeSmhSHroAo5cttBaPPKh370Hz1MNISHnmR7SYX4cQt4l7QNvSCYGYfYGuNPrp
	 UBr0/4CgJq3uTa82gBQXU9aag8UV59mDU5E6YGNjNd592WiAsXvwJ4G4hVw3CWLIOC10l
	 kpsyG8r42PYxT13ocPLWQxVpgd8QWsG7AAuIQXLOmVH9tcB2LTqJSe0yfnYG48qLdCIJq
	 VcF7oSroErXJXzNOxCJWABxi2lWVy+Qtgp05+yGKxQaaFtWy3yYTH9AGaTR+EB9zsIGLr
	 KmVdH5M1hEGKl1MWt1gmFxqTGZ3IR2qJs1bsOddo3gRWIyGGHpIjYywhVv9lIBM5K2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDSV6ByV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF93606A320;
	Thu, 19 Nov 2026 00:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NDSV6ByV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B6A1F000C4;
	Thu, 19 Nov 2026 00:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048854;
	bh=v1NJWFr9S8yQNwfBq5Ziow6kcKSTj6hkOEXHlxOHBpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDSV6ByVrquaY6c2qkx7Wx35LGZ3Z3+SwVNcIpKryKT26Gqy0UVV6YxDmb6pTnfYv
	 +Cbk0mSQ5fsqWv4CTJm9NYjkcKGNNpWcMY/sNLRrQanpEHCHqbDdc6dz63X3t2OLAA
	 jssr0CKNvltmaEX5PyX0g0IkAIGKGnvuKG9QA0tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2143/2857] pinctrl: stm32: Fix clock reference leak in stm32_pctl_probe()
Date: Wed, 18 Nov 2026 15:52:57 +0100
Message-ID: <20261118150318.562772204@linuxfoundation.org>
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
index 19ad91104cda6..635bfcdc91423 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1646,6 +1646,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 		pctl->clks[i].clk = of_clk_get_by_name(np, NULL);
 		if (IS_ERR(pctl->clks[i].clk)) {
 			fwnode_handle_put(child);
+			clk_bulk_put(i, pctl->clks);
 			return dev_err_probe(dev, PTR_ERR(pctl->clks[i].clk),
 					     "failed to get clk\n");
 		}
@@ -1656,6 +1657,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	ret = clk_bulk_prepare_enable(banks, pctl->clks);
 	if (ret) {
 		dev_err(dev, "failed to prepare_enable clk (%d)\n", ret);
+		clk_bulk_put(banks, pctl->clks);
 		return ret;
 	}
 
@@ -1680,6 +1682,7 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	}
 
 	clk_bulk_disable_unprepare(banks, pctl->clks);
+	clk_bulk_put(banks, pctl->clks);
 	return ret;
 }
 
-- 
2.53.0



