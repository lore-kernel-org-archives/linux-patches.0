Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063288;
	b=ZeE3KLudvbAv+k52ks4LwY2EtNglBiR4eKX90QWgbcRNbr24gCCsYq602PUwPR46mcT+
	 cPRcSB3l+YiEzZthCP9SqqK3eWISmTeV53s5oBBMjkopFy+c0Zb+E+6nI105bLCozRL/l
	 Zj/mK6psGKQsggvI4ViYEu142YcPvDh9ByNwTQU/8WzWcacSa/POgt0Kd9+7BJk45L8HH
	 4OR9VR6EBvqXFOqydIMdMcb10tIpZDRxFqn0t9tgMmqy2NNlERRoJktWAQ+iRz4dkh7uf
	 mcmchox1TsuCRfrqqf93fKYps/YERfr0NHYP6y0Zb8X7fZaCbU9jsVgnhIf2eEnIfWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BOiod6FB1+EltOUkgb+4cYI7ZTvKycRGEYlPWO8eIkU=;
	b=WVoirvhlz1TX3ZrCKd2b6jAiA3bxCv4l0pcqwjGFI0hQuxyeibPFVwrLbc3rDY3CRsU/
	 S8PDt12zeGd/EbsBXPUpCm/oZb54qzbEhxiWNvtTqvk3aF/AdK/WH1ktDDS/u1VFgCaK7
	 h3eR7FJmh7RRaDXGDpekUcLn9tRDv6cQiJCA/j8qYGUzly0jZ+ZNWSz0SFqC805F906Tp
	 PxE/9IfulTKS5H5KqtOIvMrpp+dL04Gg96J4TcW7f8XCSgIyTSuhd8WLG5QfhJ4E8xa4w
	 27rHpeN217ZjtA5R1EH8rqHhBBCV5PDpq1rS460Z6/aSFrfSbOSV9fXEfIi3vTPlpTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfOlNqgb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29299606A32C;
	Sat,  7 Nov 2026 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FfOlNqgb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB77B1F0089F;
	Sat,  7 Nov 2026 14:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063288;
	bh=BOiod6FB1+EltOUkgb+4cYI7ZTvKycRGEYlPWO8eIkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfOlNqgbgt9SgIvcFdoxEgHnvGGlRa0RUcYarh9ssObNo8Kd/sRh5YpLTGgya2hce
	 ktmy1nJKLMg4m1nAIHA/eqJY/dpIyiAHzI9jAMyOzZVyOeBwF6kHlYYN8jJed724q8
	 5224FZdtampYiX3GbJffzhYlkcW2jFL5xmKHBoKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 433/869] clk: imx: Fix clock reference leak in imx_obtain_fixed_clock_hw()
Date: Sat,  7 Nov 2026 08:51:55 -0500
Message-ID: <20261107134908.488111104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

[ Upstream commit 52d4d1b26a5bc64de95099d0a3dd8b90dba1f3a3 ]

imx_obtain_fixed_clock_hw() obtains the clock through
imx_obtain_fixed_clock_from_dt(), which creates a consumer reference
via of_clk_get_from_provider(). The reference is discarded right after
__clk_get_hw() returns the hardware pointer, leaking it.

Keep the imx_clk_fixed() fallback unchanged and drop the DT-obtained
consumer reference with clk_put() once the hardware pointer has been
extracted.

Fixes: a4a4069f4523 ("clk: imx: Add imx_obtain_fixed_clock clk_hw based variant")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260915055631.1730231-1-vulab@iscas.ac.cn
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index 542b58ccf120b..153e7405eae4d 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -95,11 +95,16 @@ struct clk_hw *imx_obtain_fixed_clock_hw(
 			const char *name, unsigned long rate)
 {
 	struct clk *clk;
+	struct clk_hw *hw;
 
 	clk = imx_obtain_fixed_clock_from_dt(name);
 	if (IS_ERR(clk))
-		clk = imx_clk_fixed(name, rate);
-	return __clk_get_hw(clk);
+		return __clk_get_hw(imx_clk_fixed(name, rate));
+
+	hw = __clk_get_hw(clk);
+	clk_put(clk);
+
+	return hw;
 }
 
 struct clk_hw *imx_obtain_fixed_of_clock(struct device_node *np,
-- 
2.53.0



