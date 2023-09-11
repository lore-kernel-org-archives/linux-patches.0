Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945551170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17082C433C8;
	Mon, 11 Sep 2023 13:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440590;
	bh=9PXvsWga6eogYamu/Q8gXFAuij/8BOCxlr483cO8RHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eGWHataKjv2cHQDMLCXSpOHqUpZnO5/0MwTRNy8stB0v115NcH+KnJwrXcd72638
	 REWzwPoAhKgz5QKco3JSIHcRaZbJrlDF4CYYiLucLhHFkfYeBigQjxzj2IkXbfmEfb
	 1EPP63FesaoK+XRU4isFB8idp/GA2xcNjrHq8B5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 116/739] crypto: stm32 - Properly handle pm_runtime_get failing
Date: Mon, 11 Sep 2023 15:38:35 +0200
Message-ID: <20230911134654.337291461@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit aec48805163338f8413118796c1dd035661b9140 ]

If pm_runtime_get() (disguised as pm_runtime_resume_and_get()) fails, this
means the clk wasn't prepared and enabled. Returning early in this case
however is wrong as then the following resource frees are skipped and this
is never catched up. So do all the cleanups but clk_disable_unprepare().

Also don't emit a warning, as stm32_hash_runtime_resume() already emitted
one.

Note that the return value of stm32_hash_remove() is mostly ignored by
the device core. The only effect of returning zero instead of an error
value is to suppress another warning in platform_remove(). So return 0
even if pm_runtime_resume_and_get() failed.

Fixes: 8b4d566de6a5 ("crypto: stm32/hash - Add power management support")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/stm32/stm32-hash.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index f0df32382719c..342ed46ddf882 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1705,9 +1705,7 @@ static int stm32_hash_remove(struct platform_device *pdev)
 	if (!hdev)
 		return -ENODEV;
 
-	ret = pm_runtime_resume_and_get(hdev->dev);
-	if (ret < 0)
-		return ret;
+	ret = pm_runtime_get_sync(hdev->dev);
 
 	stm32_hash_unregister_algs(hdev);
 
@@ -1723,7 +1721,8 @@ static int stm32_hash_remove(struct platform_device *pdev)
 	pm_runtime_disable(hdev->dev);
 	pm_runtime_put_noidle(hdev->dev);
 
-	clk_disable_unprepare(hdev->clk);
+	if (ret >= 0)
+		clk_disable_unprepare(hdev->clk);
 
 	return 0;
 }
-- 
2.40.1



