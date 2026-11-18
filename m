Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045389;
	b=jv80KVb706w7S37nRvQEUl7GCNTxisC9H4vUL7jUqdBMc6O60J5vYXxunuaxNf5QyO7X
	 HXnx/3ocS5O+3mgs+z+gtbxKDiY2MpXnKhziozrO0gkfbGr2WXkBq3rbRLno0ynMzzlFJ
	 UV4nNd72+K3DIsXGaJnS35sBn+4K17mmU4ng0X5VDePfyO0TTOPhU5e4i+YdJaCsQ7MPq
	 EmDpVABM9HgQyaTE0HrFLHqJrLydCj3cOwdgwpFMdOT7cB63cy50cgt8V/pLivOQ5U1L1
	 zFrCCZPcC5Hji12FiRRwpZKyO9IS3TRNhhcPWqbYLUoQMz4CpBB5nBVf7SG1TT6Eseg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=72c6q2dGEs2vfnc0oJ0N1fcgPfd+rYhQR3TrBVc9abI=;
	b=pdakI1INTLWoqW+N8YS4wpiHkVxIHNMMwyWD7Id7trx/DMug87XtERch6CszcgKKMGGu
	 tkZf5StejUuysk+YGXhLkcNe8BI3PkFnwWUXVLl9iOUXdLi9GCVp1Hnp3lg9VCvZ73POO
	 ZhkMXMGcXf5icG0mId4LDZumERKo7gtvQ1Iqg+mT3tB4ZLlVR5hKzdqVZYnfviy1YhYTp
	 +UELY/DzMochEbKu8ihjiN+kDNFgMaOru/Bth/hAfpAT2JcW9dunBZCjoAScqZCujWM/0
	 XTYT3dgcHNs9GiOvP/JfpHML98a49LxjDINJKt4PNkEHVb8yVxQNrC1xBi8mYFGfizw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXXGbU8P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD99C606A320;
	Wed, 18 Nov 2026 23:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXXGbU8P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285571F000C4;
	Wed, 18 Nov 2026 23:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045389;
	bh=72c6q2dGEs2vfnc0oJ0N1fcgPfd+rYhQR3TrBVc9abI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXXGbU8PE5OcDMchl69BpVCwoLdGDTu4ORrAq65KAfDzhza5piizNKpvpi3TDj4GS
	 wQNwQh4x+mK5cOD5vV/03tlIysi3f+EkTNDCrLuHnCpKo0nxUVDfVIcSCHIn/Bexvv
	 lP0MtG7iZPzdX+xcaQdyeXu9lECLA0xj2OxzEAtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0907/2857] clk: imx: Fix clock reference leak in imx_get_clk_hw_by_name()
Date: Wed, 18 Nov 2026 15:32:21 +0100
Message-ID: <20261118150234.226918719@linuxfoundation.org>
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
index 5582f18dd632f..4aa86bf8a8b93 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -114,12 +114,16 @@ struct clk_hw * imx_obtain_fixed_clk_hw(struct device_node *np,
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



