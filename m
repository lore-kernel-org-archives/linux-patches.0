Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055611;
	b=LvATTvGvuWJDfS9HFaRts75kz2T8puegYhLbaq2EDex4Cl5uudiHAFGxIHqM4LxXIf3A
	 LDpx7hAlkfHM8wYjwWO28a0aMnQIqH+Hn1hhqOyE2jM3PJfsfPpuCgv8efFRJ/fLa6sOC
	 7bqg7DKmgO7zwY5/LDixxh6R0rvU0JdogmDHZEVug2xMaGRvifZ9WghbQEtSrjOELvEnB
	 VR6YyYek0AU4LZrQT17ItHFNAdwfa7B8AazRxL1RLm3GCVHyWl9bGs7u5oF2WyOge3JqJ
	 DwU4P/YVvy7emmeD/IaT3G9HqtWelrdoqlOJ61N6WkAyb8RtlbTnRcJrP936Y/pldyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PEAL+kwOBVg0tUcJmf9e0tfDKkeaiXzEul8gZdH4KVA=;
	b=VkCgjbnaBQdZmci9k1BRp2iXvAka5Cy+hImyNy3bjgc9MtEehK0NTUJu/od+O62xlFgG
	 2s17+jeleh8ZjQHkDnnw+YvFdbVLWJFghWwTM8EryMHOoFk/tBZ/foD+W0hVTSz3IkWxn
	 eko78Lndg7AjLhbN9riTV5R34y6nE+Ml6mmUm/wqRLcEfkRmrWyytWEs6xWp5syzwhQeM
	 wXsJMV6D+LNzMvq4RAr3E749qh+lsRJF7HmZfqf4aC4gW+q9bkukOu/68VHxdMPsKk0BQ
	 +WO5j/+SNlH322GbnlVIRv+7Uc3iLQrTYsbEqJ4HrUHks45EMkiutQeFrstAVpvScnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sr9NCX+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B5A606A32A;
	Thu, 19 Nov 2026 02:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sr9NCX+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895991F000C4;
	Thu, 19 Nov 2026 02:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055611;
	bh=PEAL+kwOBVg0tUcJmf9e0tfDKkeaiXzEul8gZdH4KVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sr9NCX+D+5p1p8/nGxdtLWsV4aO+9fA8AWBLZmlvsm7ngFjvqP+V8VkrPprgskKme
	 4i+ntGPvHMmImxe3vgM6ek9/Gr3h5S7CLAgTYrSrtoqeYe+6bVHsO7egQ8mhD+tUuh
	 Wm0xAQiaotB8YXhQbEy2gfFQl/avIzJQO8qoBrsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1694/2214] rtc: ftrtc010: fix clock resource leak on probe failure
Date: Wed, 18 Nov 2026 15:56:10 +0100
Message-ID: <20261118150119.581380583@linuxfoundation.org>
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
index 14858d2faa2a7..c0c8f6feb79ce 100644
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



