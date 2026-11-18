Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048908;
	b=fnn84yOO2ACb+TdqYmFli+4I6HE84WHXAsAhw2umJnMSRCD6c+RJWsgHBYL1HZzo/G52
	 Wq61K4jFyyWGHGuxi0A4HyogjkvmTXzYsxKyzxjMPLim2zL3xYjI3VWSfsCCFr4w3nqiP
	 0gcwowy6DVsgUPPWNTMbsBz+6buIJwy6gwnA8wybmtDyWSwCh2f6ckYryoW9ddRqyBl91
	 LB783JJqNJJXDlfrpkeD27tUFoUHiXehA5kZzW7Y+xqXDXBPg7cfqyiYyPW8b6pID902p
	 Le6ODyTkc5D5j/TaA5735C2aEofnFED514nqfbQBZYuAboS6i63NRQ8R79aVkrOVhhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fjE1XQHTIabcJbKSAtr1rheEGSL9ifyTQdPnzStLdnI=;
	b=1M1XISTpRP3qEhB5YHhXLH3o74qK6XEZ6TuuMqC9nN5aCv85c/qSWMUIYaZ2O6pWVsgi
	 bAfHnhaNyHVp29KZ/mOM6YQW1lPUSINPWdNMqYpXrPZCe4a5l0O89kP46WiBmbwN+vwXj
	 HgU8iB0Dr2n9eAnG9y3/x4NjgwlU8RFs6RRnEDnUODersTRrVUq8HJasfMNbYdWDKTWTq
	 IinRwz5DroJeXf3IOi3fFtG6ROf5yw3HnOBx+aLLFhOBYMm+TN2wlM9ApXarRKWhD0jfj
	 oZQ4j8vAhyKFg45e0HSBY9G21ILiOU+THhNPLc5JqCmVASUlvUK6KLbLz8bZMOogVGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DB5HtvWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F1E606A32F;
	Thu, 19 Nov 2026 00:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DB5HtvWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5BD1F000C4;
	Thu, 19 Nov 2026 00:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048907;
	bh=fjE1XQHTIabcJbKSAtr1rheEGSL9ifyTQdPnzStLdnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DB5HtvWXdxIbNtHyVFHjc1Y4QvZsga5TH3LUzXVQsJvDy9OoyXCOnLwljx2v/B+uZ
	 JO1zblW+B3ERZ62WccDf7tn0hGzKvY1FfioDJ5o1lOJ1SQAARR0cUIT6R6jeZvDa2/
	 GhMpIzmTTFjv68i8OKtuRoM1X/Qfff74T8Xc02kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2160/2857] rtc: ftrtc010: fix clock resource leak on probe failure
Date: Wed, 18 Nov 2026 15:53:14 +0100
Message-ID: <20261118150319.169503780@linuxfoundation.org>
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



