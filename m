Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46771F2381;
	Thu, 12 Dec 2024 17:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024017; cv=none; b=c5VRnsTlllA1QnJnpjpGnuxWd4VuTM0NDSgomIxZXiqak+b+b4r51azcFuMxLy6VpfnyyYCp8N37PtNY91hh9Q6QcbLctXahaqe+gAvE7bopz0/zkW/Gfu+msdu6Vn/8RFkDvn50VdFRE4DKDGm3k8Oxhq4RQA1QKdFzeKXiuNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024017; c=relaxed/simple;
	bh=WXi1VMkCCtQFeZZewDXmuJlHQVQc3+UUMsbwSGRLfDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueA3Ja3C09tidIhiHOwGF2JRL3T//jhALmCUMU95O43EiL91xmRcIwrn7lvPK7/hg9M04oxGh7YhEnDq0AwF8FyOYo+mYnOTIOM9/7aK8IV1HcGbg50ue+NZOSC4XteIgGoY+Eki25OfWvIiQoP/g7oA4nrO/4rAwTL95Xk+f0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlJF47/f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlJF47/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AF7C4CECE;
	Thu, 12 Dec 2024 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024017;
	bh=WXi1VMkCCtQFeZZewDXmuJlHQVQc3+UUMsbwSGRLfDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlJF47/fZlIYnBNyG25/gemqvHDzBuX/Qk2Fk7Xt9UNVTVH7SKNe3Cgcz4+Hl1T5T
	 hV4CXxEwBCTBOmiAbIfvoMdixArhvvMsuqEl4EAVmT67IGEUXqaqo74e6lX7QsrZKI
	 1wnecRnjHSYa9bHIbWQNy9dU6W/nCeDifV2cbUtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 151/459] net: rfkill: gpio: Add check for clk_enable()
Date: Thu, 12 Dec 2024 15:58:09 +0100
Message-ID: <20241212144259.477390009@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingwei Zheng <zmw12306@gmail.com>

[ Upstream commit 8251e7621b25ccdb689f1dd9553b8789e3745ea1 ]

Add check for the return value of clk_enable() to catch the potential
error.

Fixes: 7176ba23f8b5 ("net: rfkill: add generic gpio rfkill driver")
Signed-off-by: Mingwei Zheng <zmw12306@gmail.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20241108195341.1853080-1-zmw12306@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rfkill/rfkill-gpio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index f74baefd855d3..2df5bf240b64a 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -30,8 +30,12 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 {
 	struct rfkill_gpio_data *rfkill = data;
 
-	if (!blocked && !IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
-		clk_enable(rfkill->clk);
+	if (!blocked && !IS_ERR(rfkill->clk) && !rfkill->clk_enabled) {
+		int ret = clk_enable(rfkill->clk);
+
+		if (ret)
+			return ret;
+	}
 
 	gpiod_set_value_cansleep(rfkill->shutdown_gpio, !blocked);
 	gpiod_set_value_cansleep(rfkill->reset_gpio, !blocked);
-- 
2.43.0



