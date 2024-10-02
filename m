Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EB61D079C;
	Wed,  2 Oct 2024 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880076; cv=none; b=gWI7wlDbFPJJqywjV+Kef3dwVVl2qPkzGoiv+7xnO8JORmKOzW/IkKYC8vKw++oSzSzHI0hJbsQHQn+zoRkxPx5Foa8h18B7kCLniBKp1POy3WFeADYHHnsQKFa7LeY5xsSMjECBlWwWKjsGmHzYxtg9lsvEoojiFA43M6UEp98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880076; c=relaxed/simple;
	bh=KJcVRSf/YYc2gDewBLVkJnFnI6jZEPzbWb+QWFU1eYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRStCQ1oWBUSC7Q70XiG9SaWNpulUnfX+jvCO+0X7NEQGLj9ITIP/5toF0iRJ9E7wk3El8oujOMrJrcXWT8uawVlwB036FsfYIAsHuTfR19DhwCUUQWtB29BXV8oIn1sTrIlFU+PRWyZvE/zJdEzaQ/5QSCtNL05IjHg7cWJQ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=my18wIOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="my18wIOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8EAC4CEC2;
	Wed,  2 Oct 2024 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880075;
	bh=KJcVRSf/YYc2gDewBLVkJnFnI6jZEPzbWb+QWFU1eYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=my18wIOe570tH4GrFinf0tdD/2s3w+SNiJ4W4rsToC3QnBc2Bo1rJQEnTP1fE8ll8
	 47BbV8gGFslFddGVDo2Vh3pszP/m1KxTW9m8RcWYmTs1clK8+pDuEFzdy6gU5t1nSw
	 muYIAQuevuMW4K2qrTnL50swznQh3WkKOD/XfDbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Xingyu Wu <xingyu.wu@starfivetech.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 305/538] clk: starfive: Use pm_runtime_resume_and_get to fix pm_runtime_get_sync() usage
Date: Wed,  2 Oct 2024 14:59:04 +0200
Message-ID: <20241002125804.455541622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit 55c312c1b2be6d43e39c280ad6ab4b711e545b89 ]

We need to call pm_runtime_put_noidle() when pm_runtime_get_sync()
fails, so use pm_runtime_resume_and_get() instead. this function
will handle this.

Fixes: dae5448a327ed ("clk: starfive: Add StarFive JH7110 Video-Output clock driver")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Link: https://lore.kernel.org/r/20240815093853.757487-1-liuyuntao12@huawei.com
Reviewed-by: Xingyu Wu <xingyu.wu@starfivetech.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/starfive/clk-starfive-jh7110-vout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/starfive/clk-starfive-jh7110-vout.c b/drivers/clk/starfive/clk-starfive-jh7110-vout.c
index 10cc1ec439251..36340ca42cc7e 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-vout.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-vout.c
@@ -145,7 +145,7 @@ static int jh7110_voutcrg_probe(struct platform_device *pdev)
 
 	/* enable power domain and clocks */
 	pm_runtime_enable(priv->dev);
-	ret = pm_runtime_get_sync(priv->dev);
+	ret = pm_runtime_resume_and_get(priv->dev);
 	if (ret < 0)
 		return dev_err_probe(priv->dev, ret, "failed to turn on power\n");
 
-- 
2.43.0



