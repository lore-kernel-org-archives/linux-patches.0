Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040565;
	b=f6NLKb/IdpWrowL7Foz5Ua3hmi1nxm3rvw8DjlWACfE7qzOw58f0k3Kr9WmOIU3Eig7V
	 umCs0917fmikIFzyhZqJzaFSaq3f3RqOXTXkPkt6eny6d8Z6bkOhswRYD/jB41DPQhSzD
	 r1TOikMD+LLVM1/eayULqpdJeFPCmi2fw37oTlxZMkf5J7GVp3nLQNceOTYmZa7j+VEWF
	 ej7lM4EE8tjkTPhMrr9seMJ3lTMRx7y0NLAVRB6hQERHuvAuCimJ4p4+tp0vovmS0/KDt
	 R2CgRpfHw33r8KwjGN5WAfuw8XeAip3ixrttA6avZwDZcn0wPgXd0NHauz7Yvf2hSTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2DsKNDXQUh3Oqufalh3nInCvho6yldFUkTQ9Fxsq9Y8=;
	b=m1beWoOZbxGFNGF8Kx40JZJbtHabKQjafeOROcrG3a99eZhO4l3ama/IkYtwnjaTIy4R
	 A8SejDlB3JxmE5AymBX/oWRwEFMMi4VxZIlK1LpE9MSG7ytMlFXUsLnAR2P19AwOa6mNF
	 8a+nFhqt+Ygsl40kG4JyOU7kyn0Tk0oM0XbHGf7CNFfi5wPRpO8xmom+R/Ddofz3s2kP5
	 6XivIW/jTosn48x4Fdb8RUdolhsPqf3gVu+WO8fXs5j0g3JjOKaWRJkDNbQk1+sN1cWy9
	 WFnVGSBzYYxQa3TP/EIMK77qEoxBvPGZvzgWfnMCARaZB9+g4Clhx4Yuiz4jw6AFEag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmx1svd6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30660606A320;
	Wed, 18 Nov 2026 22:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmx1svd6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870A81F000C4;
	Wed, 18 Nov 2026 22:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040565;
	bh=2DsKNDXQUh3Oqufalh3nInCvho6yldFUkTQ9Fxsq9Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmx1svd6ROcbAhjjhQorqMvErR/LKCa4vXXJ6Bw3zVder2NlTZz9IcCovzE6XSU43
	 400NwSlq6joUXWTPjoWVsSLbzykVdf4ML0aNKWVhs/oWGkuItb+Lw60ueo2vkFFntq
	 VCyEG/YSPZeqAB7WgL7+NE5qgZThsRsiWvF7oLzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2490/3318] rtc: ftrtc010: fix clock resource leak on probe failure
Date: Wed, 18 Nov 2026 15:51:52 +0100
Message-ID: <20261118150436.092523769@linuxfoundation.org>
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

From: Liu Dalin <liudalin@kylinsec.com.cn>

[ Upstream commit c60478875a445dee1206aad6285c18cd8c91f7f2 ]

When devm_rtc_register_device() fails, ftrtc010_rtc_probe() returns
the error directly without releasing clocks obtained via
clk_prepare_enable(). This leaks both extclk and pclk resources,
which may prevent subsequent probe attempts or module removal.

Capture the return value and jump to the error handling path to
properly release clocks via clk_disable_unprepare().

Fixes smatch warnings:
- drivers/rtc/rtc-ftrtc010.c:189 ftrtc010_rtc_probe() warn:
  'rtc->extclk' from clk_prepare_enable() not released on lines: 183.
- drivers/rtc/rtc-ftrtc010.c:189 ftrtc010_rtc_probe() warn:
  'rtc->pclk' from clk_prepare_enable() not released on lines: 183.

Fixes: fdcfd854333b ("rtc: rework rtc_register_device() resource management")
Assisted-by: smatch:2.0 [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Liu Dalin <liudalin@kylinsec.com.cn>
Link: https://patch.msgid.link/AC51B5F2C5FFEBB0+20260827080320.3351155-2-liudalin@kylinsec.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ftrtc010.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ftrtc010.c b/drivers/rtc/rtc-ftrtc010.c
index 84483e311b782..fb66228039b8b 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -181,7 +181,11 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 	if (unlikely(ret))
 		goto err_disable_extclk;
 
-	return devm_rtc_register_device(rtc_dev);
+	ret = devm_rtc_register_device(rtc_dev);
+	if (ret)
+		goto err_disable_extclk;
+
+	return 0;
 
 err_disable_extclk:
 	clk_disable_unprepare(rtc->extclk);
-- 
2.53.0



