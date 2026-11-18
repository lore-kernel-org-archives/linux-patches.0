Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036397;
	b=df+O0aVRsxon8lABAFaE1t/UcvB1HfCWY2aj8nU2zUM1T58De74ZUXgWssODG3zty4sn
	 mFWyzjlEnem5ptNJjqjyfpK5SR9vonpYT6ZjBHBShCOH5LLuS4CvfDtjcBYI6mEWborXJ
	 qTiQboOXTlxuSaEojzRqKvNI5so0GOJlnsRO43zFR+kr/yuSBcQjwn5iCm5nSEfmWOjl/
	 +GaErS4FyVCLlcj9+0kj/vHE0OJxlTYtSfxhgXmJKgweMg24RNAV3RxEmFt2CeOJWB6kQ
	 v23F8YCQquoarSs5t14zzYXWHJZ9CasoS2Qw1/TcpfZHOABfB7rZoKeYpcQ/ti4uihQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y1abZEl5P8Ul4IklJh2f4IVr8AxnxLfrPmMpZDSk38c=;
	b=wXc/DshT6FQAZHigdd61F7q2bPKXxUbgeXieDjnutnKomAETUh2DBaSZXAhrBpZOTwwf
	 tPCWOvXDLA7mK4/Awschwo5J4QpdpKRlVi1Ats2+447xhEea4W4kcsvaj3qDkrNGszCLj
	 lV04uHKz/YiwdRTcavLJAi8WuczYKf85oSUEdMfOv7mAVlCur3do3jZDED/S/IgEyyf+j
	 zoIwn89o6cQAv1c+QheM/7IToR0bL0N6fm1E+McG+eG1y+GLSgkbF/vP2z0dE6KFg6mL7
	 1wQRvpjzpMS6++RR9TAcBDZllk1Jcf3kTr1+6S0cwWyaCC713FxgpoElUN2b0cpYVTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bx4jdlfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB90A606A325;
	Wed, 18 Nov 2026 21:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bx4jdlfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2406C1F000C4;
	Wed, 18 Nov 2026 21:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036397;
	bh=y1abZEl5P8Ul4IklJh2f4IVr8AxnxLfrPmMpZDSk38c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bx4jdlfWGG+lhkvV9AFQMgzl9k53o+o1cbw//0rb04HX2+7AaS1phqO/VdzixtR3s
	 KKP4UXfC95l9qrEmwdh09ab2aPwWK+0ynQZwG3wguoirR+5xMCfi8Bp/ief8u6uHCr
	 lsH/kD0nFqQ68vvUdIlik7HGV3Bz71Sr0XPuZ89o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1044/3318] clk: imx: Fix clock reference leak in imx_get_clk_hw_by_name()
Date: Wed, 18 Nov 2026 15:27:46 +0100
Message-ID: <20261118150351.229005841@linuxfoundation.org>
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
index e35496af5ceba..056b8947f271f 100644
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



