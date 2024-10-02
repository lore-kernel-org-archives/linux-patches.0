Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86FD17B421;
	Wed,  2 Oct 2024 13:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877015; cv=none; b=KXGlp0CIphmu5tyUZrTI9Qqz3zxIe+vxYuooZroX+HluUE62tQRuhU8E+zOjy5yUHvD9C8vUsaUyMGRinfxzylnHSxLpCUo2b/medMvhQ39LB0JD9e1GHbA9fkS+DPG2TkRg+3mjOVi6n5eYv8F0KIwK7MVDzHs+r/gA/O9tzjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877015; c=relaxed/simple;
	bh=+l1OD3V+99ZriAvqaccydxN2+z9gskL9VhqYtgOuZjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2URrcKuJkt9DgOmLoyJmyPfev9l4QBAyLxEQmQ9j+EOWHBuH+wwBQgRicUModO86TefTpUHY/9gxNm4PPF3fJckdmC9u2+dJFAzXrQ/EIF+TA6t1d+oQJ5V9sNU5ftMSnfY1rTzY+NcvKr8BntuGOW3CTS0MAiqug/4YTbeMWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q67wUQhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q67wUQhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9CDC4CEC2;
	Wed,  2 Oct 2024 13:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877015;
	bh=+l1OD3V+99ZriAvqaccydxN2+z9gskL9VhqYtgOuZjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q67wUQhDtAfIY8zp/S6yxpYb7kN+GqJMKrHa3RuTtA7Mt5ETvxg+DrTuMvDXuLXdO
	 pnJ6EWdNEKmphntmXM0awWtiAS55sY9pHfPzYXoOP800G0wamT5TlLZUSZABCjjF+P
	 dUwRLch/sz4Nzc4jHqZjVC2NlN3F7/UZqxpM0OR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Guoqing Jiang <guoqing.jiang@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.11 636/695] hwrng: mtk - Use devm_pm_runtime_enable
Date: Wed,  2 Oct 2024 15:00:34 +0200
Message-ID: <20241002125847.904603151@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@canonical.com>

commit 78cb66caa6ab5385ac2090f1aae5f3c19e08f522 upstream.

Replace pm_runtime_enable with the devres-enabled version which
can trigger pm_runtime_disable.

Otherwise, the below appears during reload driver.

mtk_rng 1020f000.rng: Unbalanced pm_runtime_enable!

Fixes: 81d2b34508c6 ("hwrng: mtk - add runtime PM support")
Cc: <stable@vger.kernel.org>
Suggested-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/mtk-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -142,7 +142,7 @@ static int mtk_rng_probe(struct platform
 	dev_set_drvdata(&pdev->dev, priv);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
+	devm_pm_runtime_enable(&pdev->dev);
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 


