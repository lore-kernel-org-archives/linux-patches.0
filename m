Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062305;
	b=uMSjF+6Zz5Jskipq/yv/Mo7QsEE3gn6OlZqOqXAXdJkQDvFIpzHY0bFyZIIkz4gBfBRm
	 2PFMMHf7GHxx/skfzgM76WveRkSkS+n6j1vOEsXQ6JgEeN4WUdw/C/sTFc9mIWQZwWmfC
	 AQG8aZ8e8AUrrqxoXLjoTGuGXC+Kcah6q1TnvTKi3BTfEITng07zEMew1rrfLe68tEsX4
	 SUwMTZrUVamFKVw0G9o5gXzxXuy7lvgCJ/RvvCxY/hKXjQ6Fs1J6/ufUv1bvlX9U+BmgF
	 HmV5Dxb9jXr8B8KjJhstOudW47q1BQx4Utr/5OcWUpOinVu5882a7pPUolKu2eR9Cvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HI3jY2We2AeSskdsi7C24uay/BN2yPNt3O39JhwK4Cs=;
	b=Mc1rDOOQvtwTxWH34ihf5HtMJXhoqsTzaX5KpyCdlooD9CC6lcYPWpwv56vTzKU9AoAr
	 k+leGPgI3FlbYGy9MbjmfCaaKVh10XOlAXLpV041Y3WeKe0aHTj7RXwolfps/HQrZc3g3
	 zJmKKyFSNtHQchI0Oei1QejDjVmthMe6UaPwE6O4iZTqQfyUbTG9IewKqQCHFJwklAxdO
	 fZiuQO9MfO9eC6lxywu5zycatQ4/Nx+N4eMKGxkvx6DjKFdTes8RlhV0aLonMd91wfJNJ
	 OtTIEdjPEVGWPa3HiS7qpNICLa7BSK78YB7doMhvUfhdGAFgUKNA/foiwYFkWGfOT9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHjG+re1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E199A60A383D;
	Sat,  7 Nov 2026 14:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHjG+re1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE4A1F0089F;
	Sat,  7 Nov 2026 14:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062304;
	bh=HI3jY2We2AeSskdsi7C24uay/BN2yPNt3O39JhwK4Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHjG+re1n5syOHpWgHgIQodnWm6S9541xlr8p0viJ5jRFldvUtSL2G05fj4PEdYYn
	 4dYK6i+oe5UNxO8Y606180nEtDIE3fEBdj7qvgThH6bboL/09EreyY7Y0ncblw5BlS
	 f8W7FEOP+w0SIzBUXPZrgkFe1wuDTAfugnE1VQuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1202/1536] clk: imx: Fix clock reference leak in imx_get_clk_hw_by_name()
Date: Sat,  7 Nov 2026 08:53:38 -0500
Message-ID: <20261107135031.509950593@linuxfoundation.org>
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
index df83bd939492e..542b58ccf120b 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -119,12 +119,16 @@ struct clk_hw *imx_obtain_fixed_of_clock(struct device_node *np,
 struct clk_hw *imx_get_clk_hw_by_name(struct device_node *np, const char *name)
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
 EXPORT_SYMBOL_GPL(imx_get_clk_hw_by_name);
 
-- 
2.53.0



