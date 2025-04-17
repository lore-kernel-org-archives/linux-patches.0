Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1734A1E25E1;
	Thu, 17 Apr 2025 18:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913564; cv=none; b=GZZLUz6o9U8hNOz/Q+XonNoHUVouYplfTAr2mVwqrFaydp6ck8CBU4EhIf2BJKLe6DRYI7aAiQSYtGk5Yrt1It9zPRD/iBm/sMBcw3l5+YhmihH5czQYJB8GE/wNzp6QQxZAI4Tbg+lpyNcg6baEA7zMZ0iQdSjj17EwuTQntb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913564; c=relaxed/simple;
	bh=K8m0Er4xM3nhtm1bZF9MMqDhZ7LA+u0QGeRnPmI4ha0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FThoPCkJeMgAENz6JrJjql2zA0OKOpGPDEhBwHFlE5pwG/qVILEt0+TwrpPm4Q3DhduGfKMekeJgJobgOw/8QzgmuG+rwIyxMS2DfB7uEz8gLS3WKjkBSpr9Q02BMd1f9/vr9UP6CZR616nPhtdvZauRrTvv0wZNYDa1+snNz3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w75Cjkda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w75Cjkda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B2EC4CEE4;
	Thu, 17 Apr 2025 18:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913564;
	bh=K8m0Er4xM3nhtm1bZF9MMqDhZ7LA+u0QGeRnPmI4ha0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w75CjkdaOe1z11bz9/7fNeLX/j7f1oN/GYADramHbhPVP6S6KBMidMhVUNhfnoy8q
	 yo9WJYfK6AKib/Y3YCKPteq7VB7Jl48+gVphQAzU6IrsdLifSkS8Db3YfLhbhvddfg
	 kLyK7dUoaqiflY9Fe6erfqcO1vqJw8+P71S0k5C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 380/449] clk: qcom: gdsc: Release pm subdomains in reverse add order
Date: Thu, 17 Apr 2025 19:51:08 +0200
Message-ID: <20250417175133.555965504@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 0e6dfde439df0bb977cddd3cf7fff150a084a9bf upstream.

gdsc_unregister() should release subdomains in the reverse order to the
order in which those subdomains were added.

I've made this patch a standalone patch because it facilitates a subsequent
fix to stable.

Fixes: 1b771839de05 ("clk: qcom: gdsc: enable optional power domain support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20250117-b4-linux-next-24-11-18-clock-multiple-power-domains-v10-1-13f2bb656dad@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gdsc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gdsc.c
+++ b/drivers/clk/qcom/gdsc.c
@@ -571,7 +571,7 @@ void gdsc_unregister(struct gdsc_desc *d
 	size_t num = desc->num;
 
 	/* Remove subdomains */
-	for (i = 0; i < num; i++) {
+	for (i = num - 1; i >= 0; i--) {
 		if (!scs[i])
 			continue;
 		if (scs[i]->parent)


