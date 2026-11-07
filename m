Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064614;
	b=l1TDc/Of/Zq9lVSJWiCotpBJiLfXksXwDb8Te/D8rBl09zi/ZWKPncI+SP+X86DN0zWw
	 mWSlGQXMvahBfZ0HzFITQZwC/XIUVum+3Q4l2DD3dmZ14glRUjSgj086mbNzy6zKazois
	 A6R5ry/e4lE7GumIi78SugxFM8BSH1mfzj94zzrtHWD099Ya/Lw1kvibgbwVBN06VvyAl
	 yE05BNYZYv5bKaeZRi9mPLTbjFI202ff0cOP/cjt4vPFVuSKywVQG3LUdE4+q0ym4yAXS
	 rr44uRZkMxDKtrSS7h7TQATE5IQgWKu6pxkA8hWuc+nXKzytXYrQYN0c0z/HBAKi98w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YUlJy5LR0H19revfhpkRQiLXUievYu1Q0vSFjSx67o0=;
	b=CDbY7l1LtJpadvKVD8qhpuFezhPpLw4Amq9hhdXHiUOSG7gQ+wBJQiZUdUoYaAFnY65k
	 7Y51rWu7OexktDoqoQooikfTpanBE8ZTrJkB+SRgZu0gbBXrsiXI39cm+XqO/TkfJGvG4
	 aPfo24HsEbYlcSjfqQ0WXvGGjk34ey8cRn2f0magdynf/WRgyUNKJQdJZvf4TcUuOorGL
	 WfyBtNgE4WRWuk6dtMrEFRkfYWc58w0RYQ97rgRazp9YQ/fFDSEa5XLrTy9PSKCn/YNy5
	 FLPtPBPzWOGvoObPy9IKBPllw+wMCdS6DGNjs9q8rKG7mjHwgRHYbhl2N9v5hBa/MYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RWPE0n5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC01606EE9B;
	Sat,  7 Nov 2026 15:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RWPE0n5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E92A1F0089F;
	Sat,  7 Nov 2026 15:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064613;
	bh=YUlJy5LR0H19revfhpkRQiLXUievYu1Q0vSFjSx67o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RWPE0n5oIgCDKXFH71DhkWxx20xs6/PdtzKFdc3EFGAlNGUuZRruBwPEVTxIsF/0
	 IK5RN9Ox7M3ZaKhz9vLBhL7PSpQ8LMSfB8f4V7SAyrUBfv/fcrih3RPmBnpkpJ9F7V
	 0PL4EbEwqrH7glNikCLaTSNpZhIPPruVkVZFo2T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0587/1257] clk: imx: Fix clock reference leak in imx_get_clk_hw_by_name()
Date: Sat,  7 Nov 2026 08:48:03 -0500
Message-ID: <20261107134955.555519393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index f38506830ccf3..e113e30514fa2 100644
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



