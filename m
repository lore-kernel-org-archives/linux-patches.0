Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052549;
	b=NjsDgg1ZX3WngGps0rTvcdemIPD/vsIskbq17BS4w/myTMb9HWc8DYvLYLwjrmteA7Qm
	 TYnNs1JPZkH1l9GV88U7z/3raDZQP0eaWBbPD14BrqhKglD+d77rdhWmHS0IyyFkiv/4S
	 lLeXLwBK7SitTf7X82GIpKpN5wuURXzJ6aSA7czqjDAp0j88xQ+jH+zAJuFzajynhezEk
	 mvn56WTXrKRo2it0ssobLIGl38zEfXpQQ0ITa8SJrPO4W3m0C/JRVBIfg9CuONFDoE26l
	 ySyFXR3lDFRuWbLJPLXRze3p9aMVOOIgSVLcGrUeebAf3OLqG/z8r7KMKmVg1jxjtbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KNz8zCojOrT8XAAHbeJVOiPncgBeH5siGamc8T2EXms=;
	b=ZY50JYjxuEQC7oL5un6PXJULjxgk8NtdHVMVB+u9MefzF2L5tRmc92d+EXf2XmGukHA4
	 mal+2M/nMkTdMxDK8WYG6UTv6LXSy1fWtnVtXLKyPczRkc1kGszawrg4GMgF/aFKX7B0Z
	 BiWzhfSeq6JNQRDXtKs/GIgO7vTasUS2xqWlzJRfRWu43woqSZXbo8rFfYL2IJJZD1Rnp
	 vhjHOXYb8KAhXrUg/wbTDPUwxPAEVcrfI3/buH2XdXchBkAHPTMKi6LH9C2mUv6P+iXnr
	 c+dfJDY9ioJhCjbLXazYcERcmugrOBCFsRZ2/xC8w/W2n2uhPMabyeKEH8neJ53f3WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lI/A+faN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ECD606A31C;
	Thu, 19 Nov 2026 01:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lI/A+faN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55041F000C4;
	Thu, 19 Nov 2026 01:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052549;
	bh=KNz8zCojOrT8XAAHbeJVOiPncgBeH5siGamc8T2EXms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lI/A+faNGSbDZzx8vM15/OzXf958zmQBeB4SyOOa+tS+LJg3Fn5dm9GMmgwy7wXGq
	 keMA8iGQAPz+C1UkQBUDkjLES0XxSejBBx1AHwffxDBQLp4pf6D7VPRSDfr1I4ah/W
	 GSYrE0aerYJffXTFMiO4Cz6f/39JdqLQXZBfFCRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0603/2214] clk: imx: Fix clock reference leak in imx_get_clk_hw_by_name()
Date: Wed, 18 Nov 2026 15:37:59 +0100
Message-ID: <20261118150035.141406214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 8e177ca735761a1f03e1dedffd7ab00d6d0540ae ]

imx_get_clk_hw_by_name() obtains a consumer clock with
of_clk_get_by_name(), extracts the hardware pointer with __clk_get_hw()
and returns it without ever calling clk_put(), leaking the consumer
reference on both return paths.

Extract the hardware pointer first and drop the clock reference with
clk_put() before returning.

Fixes: 3b315214e091 ("clk: imx: implement new clk_hw based APIs")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260915055515.1730145-1-vulab@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index be0493e5b494e..0a375fbca9e51 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -111,12 +111,16 @@ struct clk_hw * imx_obtain_fixed_clk_hw(struct device_node *np,
 					const char *name)
 {
 	struct clk *clk;
+	struct clk_hw *hw;
 
 	clk = of_clk_get_by_name(np, name);
 	if (IS_ERR(clk))
 		return ERR_PTR(-ENOENT);
 
-	return __clk_get_hw(clk);
+	hw = __clk_get_hw(clk);
+	clk_put(clk);
+
+	return hw;
 }
 EXPORT_SYMBOL_GPL(imx_obtain_fixed_clk_hw);
 
-- 
2.53.0



