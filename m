Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062306;
	b=FzPYPCc5iRo93oRbd5WeKs8Ri6u7gFfSiz7yINXsZnfOfBG5RGRF4IqYb8HiQlVW3dcr
	 cpnV+sb/Y3Z4/rAHN+tx6TqqA8bfbV2C82wFZGTEoR0qEuSz8qhciPfN7wL7zvMJMZ/5I
	 CRyWI7XD8n2ML4XR0jAeJC8scP8pFkMZjlarQ4Zu4dOs9LyvXmNjM3CSzv5V95nXVUObp
	 gHY+swrLZAkLbxLZcJPr09G4OOWMpCMTnxZ6E0cKphMg3INMls0IYS3r14SMAg49RNM/3
	 hQAHleJ36Oori8c18XNNiiwGM5YeOPPQsJ2QcaUjH/WgxLt8D/pprhHrW3h9sbHL8Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YdD7jNYE0xbBxydH6WT0rHDGLpDzBF1xPnJFe2zCOAQ=;
	b=V53QlOPTSMZxYBhKwewIgkJ3i7qxORYDWB/oz7ObxhtSMbO4OglDDvcqiyLD8k+tMlKc
	 STEdF7vRR1DeYZV+biT0hRtIHQvN0OHalpo7qIR13LyGIrdOmnbppBSTztEUelE2uRUMs
	 TLflk6tOgJWpH9KdR8N9YT6oBznPziIL+vPfiOCy3Oj2dmviHFmS2iXNPfDjTs+DK6ntM
	 YkPUGd47k/Kjk98dC8XNORRyzA6oDXVQjJFvqU+taqAG9sixpsW0quAIsgeDsRy1LBJ4k
	 UbxbyKycUBx32Sl24Y1+Dy4FEKZ1JEa1eECS5hDltLBpKdYYaFRxCdMwMm2/u0HlzoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLMdxvg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D84606A640;
	Sat,  7 Nov 2026 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLMdxvg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1521F0089F;
	Sat,  7 Nov 2026 14:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062306;
	bh=YdD7jNYE0xbBxydH6WT0rHDGLpDzBF1xPnJFe2zCOAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLMdxvg3s1oc3/0DoBy9naSlx4s+9/D8U5MBXRPf+6PU5jsElYszdNVz0YL2LM2cD
	 bK+uaeaa79TNMHOEVvRERGU5R2whjzLuK0TPa1k1NowDqjyLsEJnVXguZPZe6ai7di
	 FU6PARYmKaj3xsmN0sgymNFNAX06OUO0VndS4+Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1203/1536] clk: imx: Fix clock reference leak in imx_obtain_fixed_clock_hw()
Date: Sat,  7 Nov 2026 08:53:39 -0500
Message-ID: <20261107135031.537831384@linuxfoundation.org>
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



