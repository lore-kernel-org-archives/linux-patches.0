Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036400;
	b=XtovP92XrVzxTi2HOtW6+NodY0EVZN2t/ufNC7UIFcetIsFOlPHrMN9JXGbz60mdFUNs
	 WWqzr87ZfvizhUqEpraPbSdIe8JV0sMqSzaGQnh1aSV5sHvqQ9C885CV2UolyPiDflmpv
	 5/YZPB3JUs+q+nQI91SCU/Gv6WTj7Y9pu0uWMCJJq7ELPndu7vvXP+H0m8AK9uJs8bMII
	 B7KENyoHBwokgu781EBfSbV9z9VnP3DFepPsJnnHj47KReeM859+XO2gi06WGX0u7Dsdn
	 9Cma/9cpx9AKnnftAnuVOdk5Imd9qLjeoG1QO5KlgGlU/6yyUBTs1pX7Xuh8V1xJK3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zpryKQMkKR2ByrsTU9wp4SBQ6+3QDJ2CA1dRxB5QsKQ=;
	b=wPrKebXpwEsDysY/uEFVxRmOsewkHr9MNEnx2EKrURRn5FaYp6ZKMonfHtGZIj9VBNlX
	 wlgOo48GlmCSB7rATt0e3Ic4AUGMhTNzLsUQ4FRvzWRTwJovNyfYLg2FqpLiMSx81oiTz
	 M4hSh0/fc31awhBF4kwnsFLAkJTt5uTocWT2p+P6mVons/e4/WvQxE/IIJmEVQQp/Sz38
	 84DGLcmQAE6m5WLZhKVeK/vuMigzrv+20y4nSV08gdnpYNUSw76YgIkKfvJgjcLdpxIKc
	 E0mWrD+xwidz1VKqCd32Fp1apf+UYizF92QPX1usACG+heIGzxoE8YNDLudS8owpkNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQ3jWdhP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC86606A320;
	Wed, 18 Nov 2026 21:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQ3jWdhP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85561F000C4;
	Wed, 18 Nov 2026 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036400;
	bh=zpryKQMkKR2ByrsTU9wp4SBQ6+3QDJ2CA1dRxB5QsKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQ3jWdhPYXKcjuI+G50qpvbuIXfNRixKAW6GBaN7iQlGzzXpiHzy/17TYR1sgmxG5
	 MC+dJ0VKD6kGPlKuow6cDWCe8bCSKCXGGTfdvgiTsQGcqOXNwrinUn4gWKH0cEoAiX
	 xTkDDo0IqIIbtX1e93HA5HTVtb9NdBWq+nFzyAQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1045/3318] clk: imx: Fix clock reference leak in imx_obtain_fixed_clock_hw()
Date: Wed, 18 Nov 2026 15:27:47 +0100
Message-ID: <20261118150351.262793672@linuxfoundation.org>
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
index 056b8947f271f..ae20f9484b1ad 100644
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



