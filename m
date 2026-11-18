Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058568;
	b=gl3moI0m4prG7euOFGNTlOR8+1qU2dkoAILtcLVuffTxVfNpBQBZnZKos0h4m0yi9IYc
	 MpWSiof6HczCXN0S1xLC/iPoMYM4DIFi567eMPmSKyxR4S+H8U7MzPs3MMRgMhlVg3+HT
	 zb+RDEPQ2SYRcOVmlbYCyP1/hBURLussFdpgzMpY3hd9Y0tF9KwXHYJ0WTCoSOhCf9f8N
	 VdPWm6lYcT/O1EMbgcYNEoSUMHRRe3Pza7FpyYNUJlZ9ArtgaMJcuxVsXHTnugZYGkb9Y
	 JdMAS81V6kv5IJRBU1bRUaU0op6rA6zmRyx9iefObApef57L3TFdSpQKgA288MREO1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EODp6AifyMeMlZGOT96w6ADqRvra8D1qpX58V/VX4nU=;
	b=LLvW5dDDQHhAiFgFU/qpsl4IZQV4QBkYx6fHv9qfK+06Biv9TkFMXpDRAV2qdyObzygI
	 7ymxgsJaCroVDZfv6bmnBDNlBRUsO/gpqUeWcDudCABTVQhDj2AgtSXgy5r7MzEsqiuDz
	 1afrWGA47fgpO2ax5GQPlKXqVvjFKlrtx28FPcfVbOA0/Z+IDgGom1K0j3Ns6+Uu3znDY
	 zNqVXoN0iSmG5cD/NTqa6zGBxfnwbQ7q12ei3GXE4n1Xksxy0hyJxZzHwdCS81yMtl1fU
	 YII0VJgCIINrVO7Z0oqTKHF8zqsBQ0DGhrFL8+J3kQR67uPGAR4Lcto6nC/sh/mz6WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6iia3iI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A748606A333;
	Thu, 19 Nov 2026 03:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v6iia3iI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B7E1F000C4;
	Thu, 19 Nov 2026 03:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058568;
	bh=EODp6AifyMeMlZGOT96w6ADqRvra8D1qpX58V/VX4nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v6iia3iIiH9S07UsQKWRoDR1hAXTM03l7X2eS3RCFFGuTPAGLoUhB2vR/Oe39GA6f
	 3Goov/GuS0nwrR3x7K4CudNSMo56Z7PKa1i+dQ+GIAUYwVVlFFfF0cY7N8rwgwgc+a
	 hh9AVTiBR3srXpGMK1KEoGGaaUG4vKG/KpqJkvmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0492/1848] clk: imx: Fix clock reference leak in imx_get_clk_hw_by_name()
Date: Wed, 18 Nov 2026 15:42:10 +0100
Message-ID: <20261118145934.965034131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



